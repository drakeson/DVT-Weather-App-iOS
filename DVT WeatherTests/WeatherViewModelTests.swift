//
//  WeatherViewModelTests.swift
//  DVT WeatherTests
//
//  Created by Kato Drake Smith on 08/08/2023.
//

import XCTest
import Combine
@testable import DVT_Weather


final class WeatherViewModelTests: XCTestCase {
    
    var viewModel: WeatherViewModel!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        viewModel = WeatherViewModel()
    }
    
    override func tearDownWithError() throws {
        cancellables.removeAll()
        viewModel = nil
    }
    
    func testFetchCurrentWeatherSuccess() {
        let expectation = XCTestExpectation(description: "Fetch current weather")
        
        viewModel.fetchCurrentWeather(lat: 0.0512, lon: 32.4637)
        
        viewModel.$currentWeather
            .dropFirst()
            .sink { currentWeather in
                XCTAssertNotNil(currentWeather)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchForecastSuccess() {
        let expectation = XCTestExpectation(description: "Fetch forecast")
        
        viewModel.fetchForecast(lat: 0.0512, lon: 32.4637)
        
        viewModel.$forecastData
            .dropFirst()
            .sink { forecastData in
                XCTAssertFalse(forecastData.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchPlaceDataSuccess() {
        let expectation = XCTestExpectation(description: "Fetch place data")
        
        viewModel.fetchPlaceData(placeName: "Gulu")
        
        viewModel.$placeData
            .dropFirst()
            .sink { placeData in
                XCTAssertNotNil(placeData)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
    }


    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
