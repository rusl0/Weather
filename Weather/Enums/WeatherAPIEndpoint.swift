//
//  WeatherApiEndpoint.swift
//  Weather
//
//  Created by Ruslan Kandratsenka on 24.01.25.
//

import Foundation

enum WeatherAPIEndpoint {
    
    private var appid: String { return "baa4933d3d3ed61db81c255924a35bf7"}
    
    case geo(name:String)
    case forecast(lat:Double,lon:Double)
    
    var url: URL {
        switch self {
            case .geo(let name):
                
                var url = URL(string: "http://api.openweathermap.org/geo/1.0/direct")!
                let queryItems = [
                    URLQueryItem(name: "q", value: name),
                    URLQueryItem(name: "limit", value: "5"),
                    URLQueryItem(name: "appid", value: appid)
                ]
                url.append(queryItems: queryItems)
                return url
            case .forecast(let lat, let lon):
                var url = URL(string: "http://api.openweathermap.org/data/2.5/forecast")!
                let queryItems = [
                    URLQueryItem(name: "lat", value: String(lat)),
                    URLQueryItem(name: "lon", value: String(lon)),
                    URLQueryItem(name: "units", value: "metric"),
                    URLQueryItem(name: "cnt", value: "1"),
                    URLQueryItem(name: "appid", value: appid)
                ]
                url.append(queryItems: queryItems)
                return url
        }
    }
    
    
}
