//
//  FavouriteViewModel.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 07/08/2023.
//


import Combine

class FavouriteViewModel: ObservableObject {
    //MARK: - Propeties
    @Published var cities: [City] = []
    private let coreDataManager: CoreDataManager
    private var cancellables = Set<AnyCancellable>()
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        fetchCities()
    }
    
    
    //MARK: -  Fetch Saved Cities ViewModel
    func fetchCities() {
        do {
            let fetchedCities = try coreDataManager.fetchCities()
            self.cities = fetchedCities.map { City(from: $0) }
        } catch {
            print("Error fetching cities: \(error.localizedDescription)")
        }
    }
}






