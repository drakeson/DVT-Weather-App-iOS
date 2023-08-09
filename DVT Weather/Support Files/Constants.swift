//
//  Constants.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 03/08/2023.
//

import Foundation

//MARK: - OpenWeatherAPI
struct WeatherAPI {
    static let baseUrl = "https://api.openweathermap.org/data/2.5/"
    static let apiKey = "4a605e032f8621d60541439ee2237631"
    static let units = "&units=metric"
}


//MARK: - MESSAGES
struct AppMessages {
    static let success = "Successful"
    static let error = "Error fetching data from api"
    static let load = "Loading..."
    static let tryA = "Try Again"
    static let wifi = "Wifi Connection"
    static let mobile = "Cellular Connection"
    static let unavailable = "Internet Not Avialable"
    static let noConnection = "No Connection"
    static let noData = "No data returnned from server"
    static let failed = "Failure response"
    static let invalidResponse = "Unable to process response"
    static let failedRequest = "Failed request from server"
}

