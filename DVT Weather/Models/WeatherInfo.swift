//
//  WeatherInfo.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 04/08/2023.
//

import Foundation
import UIKit


struct Coordinate: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
}

struct MainInfo: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
}

struct CurrentWeatherData: Codable {
    let coord: Coordinate
    let weather: [Weather]
    let main: MainInfo
    let dt: Int
    let name: String
    let wind: Wind
}

struct ForecastData: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable {
    let dt: Int
    let main: MainInfo
    let weather: [Weather]
}
