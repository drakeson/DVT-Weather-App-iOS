//
//  CoreDataManager.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 07/08/2023.
//

import CoreData
import Combine


class CoreDataManager {
    //MARK: - Propeties
    static let shared = CoreDataManager()
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "OfflineData")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load CoreData stack: \(error)")
            }
        }
    }
    
    
    //MARK: Save Current Weather
    func saveCurrentWeatherData(currentWeatherData: CurrentWeatherData) {
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CurrentWeather")
        do {
            let existingWeatherData = try context.fetch(fetchRequest) as! [NSManagedObject]
            if let firstObject = existingWeatherData.first {
                firstObject.setValue(currentWeatherData.coord.lon, forKey: "lon")
                firstObject.setValue(currentWeatherData.coord.lat, forKey: "lat")
                firstObject.setValue(currentWeatherData.weather.first?.main, forKey: "weatherMain")
                firstObject.setValue(currentWeatherData.main.temp, forKey: "temp")
                firstObject.setValue(currentWeatherData.main.temp_min, forKey: "tempMin")
                firstObject.setValue(currentWeatherData.main.temp_max, forKey: "tempMax")
                firstObject.setValue(currentWeatherData.name, forKey: "name")
                
                do {
                    try context.save()
                } catch {
                    print("Error updating CoreData: \(error)")
                }
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "CurrentWeather", in: context)!
                let currentWeatherEntity = NSManagedObject(entity: entity, insertInto: context)
                currentWeatherEntity.setValue(currentWeatherData.coord.lon, forKey: "lon")
                currentWeatherEntity.setValue(currentWeatherData.coord.lat, forKey: "lat")
                currentWeatherEntity.setValue(currentWeatherData.weather.first?.main, forKey: "weatherMain")
                currentWeatherEntity.setValue(currentWeatherData.main.temp, forKey: "temp")
                currentWeatherEntity.setValue(currentWeatherData.main.temp_min, forKey: "tempMin")
                currentWeatherEntity.setValue(currentWeatherData.main.temp_max, forKey: "tempMax")
                currentWeatherEntity.setValue(currentWeatherData.name, forKey: "name")
                
                do {
                    try context.save()
                } catch {
                    print("Error saving new CoreData: \(error)")
                }
            }
        } catch {
            print("Error fetching existing CoreData: \(error)")
        }
    }
    
    
    
    
    
    //MARK: Fetch Current Weather
    func fetchSavedWeatherDataPublisher() -> AnyPublisher<CurrentWeatherData?, Never> {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentWeather")
        
        return Future<CurrentWeatherData?, Never> { promise in
            do {
                if let savedWeatherEntities = try context.fetch(fetchRequest) as? [NSManagedObject],
                   let savedWeatherEntity = savedWeatherEntities.first {
                    let lon = savedWeatherEntity.value(forKey: "lon") as? Double ?? 0.0
                    let lat = savedWeatherEntity.value(forKey: "lat") as? Double ?? 0.0
                    let weatherMain = savedWeatherEntity.value(forKey: "weatherMain") as? String ?? ""
                    let temp = savedWeatherEntity.value(forKey: "temp") as? Double ?? 0.0
                    let tempMin = savedWeatherEntity.value(forKey: "tempMin") as? Double ?? 0.0
                    let tempMax = savedWeatherEntity.value(forKey: "tempMax") as? Double ?? 0.0
                    let name = savedWeatherEntity.value(forKey: "name") as? String ?? ""
                    let wind = savedWeatherEntity.value(forKey: "wind") as? Double ?? 0.0
                    let pressure = savedWeatherEntity.value(forKey: "pressure") as? Int ?? 0
                    let humidity = savedWeatherEntity.value(forKey: "humidity") as? Int ?? 0
                    
                    let currentWeatherData = CurrentWeatherData(
                        coord: Coordinate(lon: lon, lat: lat),
                        weather: [Weather(id: 0, main: weatherMain)],
                        main: MainInfo(temp: temp, temp_min: tempMin, temp_max: tempMax,
                                       pressure: pressure, humidity: humidity),
                        dt: 0, name: name, wind: Wind(speed: wind))
                    
                    promise(.success(currentWeatherData))
                } else {
                    promise(.success(nil))
                }
            } catch {
                print("Error fetching saved weather data: \(error)")
                promise(.success(nil))
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    
    
    //MARK: Save Forecast Data
    func saveForecastData(forecastItems: [ForecastItem]) {
        let context = persistentContainer.viewContext
        
        // Delete existing forecast data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Forecast")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Error deleting existing forecast data: \(error)")
        }
        
        // Save new forecast data
        for forecastItem in forecastItems {
            let entity = NSEntityDescription.entity(forEntityName: "Forecast", in: context)!
            let forecastItemEntity = NSManagedObject(entity: entity, insertInto: context)
            
            forecastItemEntity.setValue(UUID(), forKey: "id")
            forecastItemEntity.setValue(forecastItem.dt, forKey: "dt")
            forecastItemEntity.setValue(forecastItem.weather[0].main, forKey: "weatherMain")
            forecastItemEntity.setValue(forecastItem.main.temp_max, forKey: "tempMax")
            forecastItemEntity.setValue(forecastItem.main.temp_min, forKey: "tempMin")
            
            do {
                try context.save()
            } catch {
                print("Error saving forecast data: \(error)")
            }
        }
    }


    
    
    //MARK: Fetch Forecast Data
    func fetchForecastDataPublisher() -> AnyPublisher<[ForecastItem], Never> {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Forecast")
        
        return Future<[ForecastItem], Never> { promise in
            do {
                let forecastItemEntities = try context.fetch(fetchRequest) as? [NSManagedObject] ?? []
                var forecastItems: [ForecastItem] = []
                
                for forecastItemEntity in forecastItemEntities {
                    let dt = forecastItemEntity.value(forKey: "dt") as? Int ?? 0
                    let weatherMain = forecastItemEntity.value(forKey: "weatherMain") as? String ?? ""
                    let tempMin = forecastItemEntity.value(forKey: "tempMin") as? Double ?? 0.0
                    let tempMax = forecastItemEntity.value(forKey: "tempMax") as? Double ?? 0.0
                    
                    
                    let mainInfo = MainInfo(temp: 0.0, temp_min: tempMin, temp_max: tempMax, pressure: 0, humidity: 0)
                    let weather = [Weather(id: 0, main: weatherMain)]
                    let forecastItem = ForecastItem(dt: dt, main: mainInfo, weather: weather)
                    forecastItems.append(forecastItem)
                }
                
                promise(.success(forecastItems))
            } catch {
                print("Error fetching forecast data: \(error)")
                promise(.success([]))
            }
        }
        .eraseToAnyPublisher()
    }

    
    
    
    //MARK: Save City
    func saveCity(currentWeatherData: CurrentWeatherData) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            let context = self.persistentContainer.viewContext
            
            let fetchRequest: NSFetchRequest<Cities> = Cities.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name = %@", currentWeatherData.name)
            
            do {
                let existingCities = try context.fetch(fetchRequest)
                if let existingCity = existingCities.first {
                    existingCity.tempMin = currentWeatherData.main.temp_min
                    existingCity.tempMax = currentWeatherData.main.temp_max
                    existingCity.weatherMain = currentWeatherData.weather.first?.main
                    existingCity.name = currentWeatherData.name
                    existingCity.lon = currentWeatherData.coord.lon
                    existingCity.lat = currentWeatherData.coord.lat
                    existingCity.temp = currentWeatherData.main.temp
                    existingCity.pressure = currentWeatherData.main.pressure
                    existingCity.humidity = currentWeatherData.main.humidity
                    existingCity.wind = currentWeatherData.wind.speed
                    existingCity.createdAt = Date()
                } else {
                    let newCity = Cities(context: context)
                    newCity.tempMin = currentWeatherData.main.temp_min
                    newCity.tempMax = currentWeatherData.main.temp_max
                    newCity.weatherMain = currentWeatherData.weather.first?.main
                    newCity.name = currentWeatherData.name
                    newCity.lon = currentWeatherData.coord.lon
                    newCity.lat = currentWeatherData.coord.lat
                    newCity.temp = currentWeatherData.main.temp
                    newCity.pressure = currentWeatherData.main.pressure
                    newCity.humidity = currentWeatherData.main.humidity
                    newCity.wind = currentWeatherData.wind.speed
                    newCity.createdAt = Date()
                }
                
                try context.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    
    //MARK: Fetch Cities
    func fetchCities() throws -> [Cities] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Cities> = Cities.fetchRequest()
        
        return try context.fetch(fetchRequest)
    }
    
}
