//
//  SearchVC.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 04/08/2023.
//

import UIKit
import Combine
import SwiftUI


class SearchVC: UIViewController, UISearchBarDelegate {
    
    //MARK: - Propeties
    let uiComponents = UIComponents()
    private var viewModel = WeatherViewModel()
    private var cancellables = Set<AnyCancellable>()
    let weatherInfoView = WeatherInfoView()
    var currentWeatherData: CurrentWeatherData?
    private let coreDataManager = CoreDataManager.shared
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search City"
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .white
        return searchBar
    }()
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    //MARK: - Selectors
    @objc func showFavourite() {
        let favouriteView = FavouriteVC()
        let hostingController = UIHostingController(rootView: favouriteView)
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true, completion: nil)
    }
    
    @objc func saveCity() {
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
    
    
    
    
    //MARK: - Helpers
    func configureUI() {
        title = "Search for City"
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
        
        
        let likeIcon = createBarButtonItem(imageName: "heart", action: #selector(saveCity))
        let favouriteIcon = createBarButtonItem(imageName: "list.number", action: #selector(showFavourite))
        navigationItem.rightBarButtonItems = [favouriteIcon, likeIcon]
        
        // Create and configure UISearchBar
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        // Add a UIView
        weatherInfoView.setDimensions(width: view.frame.width, height: 250)
        view.addSubview(weatherInfoView)
        weatherInfoView.anchor(top: searchBar.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {}
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let place = searchBar.text {
            viewModel.fetchPlaceData(placeName: UIComponents().urlEncode(place)!)
            viewModel.$placeData.sink { [weak self] placeData in
                if let placeData = placeData {
                    self?.displayPlaceData(placeData)
                    self?.currentWeatherData = placeData
                }
            }.store(in: &cancellables)
        }
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    
    
    
    func displayPlaceData(_ placeData: CurrentWeatherData?) {
        let navigationBarAppearance = UINavigationBarAppearance()
        
        guard let placeName = placeData?.name else { return }
        guard let weatherType = placeData?.weather[0].main else { return }
        guard let maxTemp = placeData?.main.temp_max else { return }
        guard let minTemp = placeData?.main.temp_min else { return }
        guard let currentTemp = placeData?.main.temp else { return }
        
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
    
    
    
    
    
    
    //MARK: - Bar Buttons
    func createBarButtonItem(imageName: String, action: Selector) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: imageName), style: .plain, target: self, action: action)
        barButtonItem.tintColor = .white
        return barButtonItem
    }
    
}
