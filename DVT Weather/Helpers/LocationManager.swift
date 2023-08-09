//
//  LocationManager.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 05/08/2023.
//

import CoreLocation
import Combine

class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    private var subject = PassthroughSubject<CLLocation, Error>()
    
    var locationPublisher: AnyPublisher<CLLocation, Error> {
        return subject.eraseToAnyPublisher()
    }
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            subject.send(location)
            subject.send(completion: .finished)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        subject.send(completion: .failure(error))
    }
}
