//
//  CityResponse.swift
//  Weather
//
//  Created by Ruslan Kandratsenka on 24.01.25.
//

import Foundation

struct CityResponse: Decodable, Identifiable {
    let id = UUID()
    var isLocal = false
    
    let name: String
    let country: String
    let lat: Double
    let lon: Double
    
    private enum CodingKeys: String, CodingKey {
        case name
        case country
        case lat
        case lon
    }
    
    mutating func setLocal() {
        isLocal = true
    }
}
