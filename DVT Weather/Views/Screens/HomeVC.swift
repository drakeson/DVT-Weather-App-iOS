//
//  HomeVC.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 03/08/2023.
//

import UIKit
import SwiftUI
import Combine

class HomeVC: UIViewController {
    
    //MARK: - Propeties
    let uiComponents = UIComponents()
    let weatherInfoView = WeatherInfoView()
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel = WeatherViewModel()
    let locationManager = LocationManager()
    var forecastData = [ForecastData]()
    var currentWeatherData: CurrentWeatherData?
    private let coreDataManager = CoreDataManager.shared
    let reachability = try! Reachability()
    
    let forecastTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged,object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.requestLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name:
                .reachabilityChanged, object: reachability)
    }
    
    
    
    //MARK: - Selectors
    @objc func showFavourite() {
        let favouriteView = FavouriteVC()
        let hostingController = UIHostingController(rootView: favouriteView)
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true, completion: nil)
    }
    
    @objc func searchCity() {
        let searchViewController = SearchVC()
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @objc func likeIconTapped() {
        guard let currentWeatherData = currentWeatherData else { return}
        coreDataManager.saveCity(currentWeatherData: currentWeatherData).sink { completion in
            switch completion {
            case .finished:
                self.view.makeToast("Saved to Favourite Cities", duration: 3.0, position: .bottom)
            case .failure(let error):
                self.view.makeToast("Error saving \(error)", duration: 3.0, position: .bottom)
            }
        } receiveValue: { _ in }.store(in: &cancellables)
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            setupLocationUpdates()
        case .cellular:
            setupLocationUpdates()
        case .unavailable:
            updateUIWithSavedData()
        case .none:
            updateUIWithSavedData()
        }
    }
    
    
    //MARK: - Helpers
    
    
    func configureUI() {
        // Right bar button items
        let favouriteIcon = createBarButtonItem(imageName: "list.number", action: #selector(showFavourite))
        let searchIcon = createBarButtonItem(imageName: "magnifyingglass", action: #selector(searchCity))
        navigationItem.rightBarButtonItems = [searchIcon, favouriteIcon]
        
        // Left bar button items
        let likeIcon = createBarButtonItem(imageName: "heart", action: #selector(likeIconTapped))
        navigationItem.leftBarButtonItems = [likeIcon]
        
        // Add a UIView
        weatherInfoView.setDimensions(width: view.frame.width, height: 250)
        view.addSubview(weatherInfoView)
        weatherInfoView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        // Add a UITableView
        forecastTableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: "ForecastCell")
        forecastTableView.dataSource = self
        forecastTableView.delegate = self
        view.addSubview(forecastTableView)
        forecastTableView.anchor(top: weatherInfoView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
    }
    
    
    //MARK: - Bar Buttons
    func createBarButtonItem(imageName: String, action: Selector) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: imageName), style: .plain, target: self, action: action)
        barButtonItem.tintColor = .white
        return barButtonItem
    }
    
    
    
    
    
    
    
    //MARK: - Get Location
    func setupLocationUpdates() {
        locationManager.locationPublisher.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.view.makeToast("Didn't get Location", duration: 3.0, position: .bottom)
                print("Location error: \(error.localizedDescription)")
            }
        }, receiveValue: { location in
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            self.fetchWeatherData(latitude: latitude, longitude: longitude)
            
        }).store(in: &cancellables)
    }
    
    
    
    
    
    
    
    
    
    //MARK: - Fetch Weather Data
    private func fetchWeatherData(latitude: Double, longitude: Double) {
        viewModel.fetchCurrentWeather(lat: latitude, lon: longitude)
        viewModel.$currentWeather.sink { [weak self] currentData in
            self?.updateUI(with: currentData)
            self?.currentWeatherData = currentData
        }.store(in: &cancellables)
        
        viewModel.fetchForecast(lat: latitude, lon: longitude)
        viewModel.$forecastData.receive(on: DispatchQueue.main).sink { [weak self] data in
            self?.forecastTableView.reloadData()
        }.store(in: &cancellables)
    }
    
    
    
    
    
    
    //MARK: - Fetch Saved Data
    private func updateUIWithSavedData() {
        coreDataManager.fetchSavedWeatherDataPublisher().sink { [weak self] currentWeatherData in
            self?.updateUI(with: currentWeatherData)
        }.store(in: &cancellables)
        
        coreDataManager.fetchForecastDataPublisher().sink { [weak self] forecastData in
            self?.viewModel.forecastData = forecastData
            self?.forecastTableView.reloadData()
        }.store(in: &cancellables)
    }
    
    
    
    
    
    
    //MARK: - Update UI
    
    private func updateUI(with weatherInfo: CurrentWeatherData?) {
        let navigationBarAppearance = UINavigationBarAppearance()
        
        guard let placeName = weatherInfo?.name else { return }
        guard let weatherType = weatherInfo?.weather[0].main else { return }
        guard let maxTemp = weatherInfo?.main.temp_max else { return }
        guard let minTemp = weatherInfo?.main.temp_min else { return }
        guard let currentTemp = weatherInfo?.main.temp else { return }
        
        let backgroundColor = uiComponents.displayBackgroundColor(conditionString: weatherType.lowercased())
        let backgroundImage = uiComponents.displayBackgroundImage(conditionString: weatherType.lowercased())
        navigationBarAppearance.backgroundColor = backgroundColor
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        title = placeName
        view.backgroundColor = backgroundColor
        weatherInfoView.backgroundImage.image = backgroundImage
        
        weatherInfoView.locationLabel.text = placeName
        weatherInfoView.temperatureLabel.text = uiComponents.formatTemperature(degrees: currentTemp)
        weatherInfoView.weatherTypeLabel.text = weatherType
        
        
        weatherInfoView.bottomStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        weatherInfoView.bottomStackView.addArrangedSubview(weatherInfoView.createNestedStackView(label: "Min", value: uiComponents.formatTemperature(degrees: minTemp)))
        weatherInfoView.bottomStackView.addArrangedSubview(weatherInfoView.createNestedStackView(label: "Current", value: uiComponents.formatTemperature(degrees: currentTemp)))
        weatherInfoView.bottomStackView.addArrangedSubview(weatherInfoView.createNestedStackView(label: "Max", value: uiComponents.formatTemperature(degrees: maxTemp)))
        
    }
    
    
}



//MARK: - UITableView Functions
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.forecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastTableViewCell
        let forecastItem = viewModel.forecastData[indexPath.row]
        let dayLabelString = Date(timeIntervalSince1970: TimeInterval(forecastItem.dt)).getDayForDate()
        
        cell.dayLabel.text = dayLabelString
        cell.forecastImageView.image = uiComponents.displayWeatherIcon(conditionString: forecastItem.weather[0].main.lowercased())
        cell.temperatureLabel.text = uiComponents.formattedTemperature(min: forecastItem.main.temp_min, max: forecastItem.main.temp_max)
        cell.backgroundColor = .clear
        
        return cell
    }
    
}
