//
//  WeatherViewModel.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 05/08/2023.
//

import UIKit
import Combine

class WeatherViewModel: ObservableObject {
    //MARK: - Propeties
    private var cancellables: Set<AnyCancellable> = []
    private let weatherRepository = WeatherRepository()
    private let coreDataManager = CoreDataManager.shared
    @Published var currentWeather: CurrentWeatherData?
    @Published var forecastData: [ForecastItem] = []
    @Published var placeData: CurrentWeatherData?
    
    
    //MARK: -  Fetch Current Weather ViewModel
    func fetchCurrentWeather(lat: Double, lon: Double) {
        weatherRepository.fetchWeather(lat: lat, lon: lon).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching current weather: \(error)")
                }
            }) { [weak self] currentWeather in
                self?.currentWeather = currentWeather
                // Save to CoreData
                self?.coreDataManager.saveCurrentWeatherData(currentWeatherData: currentWeather)
            }.store(in: &cancellables)
    }
    
    
    
    
    
    //MARK: -  Fetch Forecast ViewModel
    func fetchForecast(lat: Double, lon: Double) {
        weatherRepository.fetchForecast(lat: lat, lon: lon).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching forecast: \(error)")
                }
            }) { [weak self] forecastData in
                let utcDifference = TimeZone.current.secondsFromGMT() / 3600
                let noonComponents = DateComponents(hour: 12 + utcDifference, minute: 0, second: 0)
                let dailyWeather = forecastData.list.filter {
                    let dateNew = Date(timeIntervalSince1970: TimeInterval($0.dt))
                    return Calendar.current.date(dateNew, matchesComponents: noonComponents)
                }
                self?.forecastData = dailyWeather
                
                // Save to CoreData
                self?.coreDataManager.saveForecastData(forecastItems: dailyWeather)
                
            }.store(in: &cancellables)
    }
    
    
    
    
    
    
    //MARK: -  Fetch Place Weather ViewModel
    func fetchPlaceData(placeName: String) {
        weatherRepository.fetchPlaceData(placeName: placeName).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching place data: \(error)")
                }
            }) { [weak self] placeData in
                self?.placeData = placeData
            }.store(in: &cancellables)
    }
    
}


