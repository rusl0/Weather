//
//  ForecastResponse.swift
//  Weather
//
//  Created by Ruslan Kandratsenka on 24.01.25.
//

import Foundation


struct ForecastResponse: Decodable {
    let list: [ForecastItem]
}

struct ForecastItem: Decodable {
    let dt: Int32
    let main: ForecasrTemperature
    let wind: ForecastWind
}

struct ForecasrTemperature: Decodable {
    let temp: Double
}

struct ForecastWind: Decodable {
    let speed: Double
    let deg: Int16
}
