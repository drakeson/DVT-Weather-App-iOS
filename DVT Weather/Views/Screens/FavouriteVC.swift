//
//  FavouriteVC.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 04/08/2023.
//

import SwiftUI

struct FavouriteVC: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ContentView(coreDataManager: CoreDataManager.shared)
                .navigationBarTitle("Favourite Cities")
                .navigationBarItems(leading: Button("Back") {
                    presentationMode.wrappedValue.dismiss()
                })
        }
    }
}


struct ContentView: View {
    @ObservedObject var viewModel: FavouriteViewModel
    @State private var selectedCity: City? = nil
    
    init(coreDataManager: CoreDataManager) {
        self.viewModel = FavouriteViewModel(coreDataManager: coreDataManager)
    }
    
    var body: some View {
        List(viewModel.cities) { city in
            NavigationLink(destination: DetailsVC(city: city)) {
                CityRowView(city: city)
            }
        }
    }
}


struct FavouriteVC_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteVC()
    }
}
