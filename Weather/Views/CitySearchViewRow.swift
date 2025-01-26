//
//  CitySearchViewRow.swift
//  Weather
//
//  Created by Ruslan Kandratsenka on 24.01.25.
//

import SwiftUI

struct CitySearchViewRow: View {
    
    let city: CityResponse
    
    var body: some View {
        HStack {
            Text("\(city.name) \(city.country)")
            if city.isLocal {
                Spacer()
                Image(systemName: "checkmark.circle")
            }
        }
        .background(Color(UIColor.white))
    }
}

struct CitySearchViewRow_Previews: PreviewProvider {
    static var previews: some View {
        CitySearchViewRow(city: CityResponse(name: "City 1", country: "BY", lat: 10, lon: 10))
    }
}
