//
//  CityWeatherSheetViewModel.swift
//  Weather
//
//  Created by Ruslan Kandratsenka on 24.01.25.
//

import Foundation
import CoreData

class CityWeatherSheetViewModel: ObservableObject {
    @Published var isLoaded = false
    
    public func getForecast(for city:CityResponse) async throws {
        
    }
    
    
    
}
