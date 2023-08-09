//
//  WeatherRepository.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 05/08/2023.
//

import Foundation
import Combine

class WeatherRepository {
    
    //MARK: - Fetch Weather From URL
    func fetchWeather(lat: Double, lon: Double) -> AnyPublisher<CurrentWeatherData, Error> {
        let urlString = "\(WeatherAPI.baseUrl)weather?lat=\(lat)&lon=\(lon)&appid=\(WeatherAPI.apiKey)\(WeatherAPI.units)"
        return URLSession.shared.dataTaskPublisher(for: URL(string: urlString)!)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: CurrentWeatherData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    //MARK: - Fetch Forecast From URL
    func fetchForecast(lat: Double, lon: Double) -> AnyPublisher<ForecastData, Error> {
        let urlString = "\(WeatherAPI.baseUrl)forecast?lat=\(lat)&lon=\(lon)&appid=\(WeatherAPI.apiKey)\(WeatherAPI.units)"
        return URLSession.shared.dataTaskPublisher(for: URL(string: urlString)!)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: ForecastData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    //MARK: - Fetch Place Weather From URL
    func fetchPlaceData(placeName: String) -> AnyPublisher<CurrentWeatherData, Error> {
        let urlString = "\(WeatherAPI.baseUrl)weather?q=\(placeName)&appid=\(WeatherAPI.apiKey)\(WeatherAPI.units)"
        return URLSession.shared.dataTaskPublisher(for: URL(string: urlString)!)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: CurrentWeatherData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
