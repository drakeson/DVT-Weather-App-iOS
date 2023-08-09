//
//  CityRowView.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 04/08/2023.
//

import SwiftUI

struct CityRowView: View {
    var city: City
    var body: some View {
        VStack {
            Text(city.name)
        }
    }
}

