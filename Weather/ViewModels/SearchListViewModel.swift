//
//  SearchListViewModel.swift
//  Weather
//
//  Created by Ruslan Kandratsenka on 24.01.25.
//

import SwiftUI
import CoreData

class SearchListViewModel: ObservableObject {
    
    private let context = PersistenceController.shared.container.viewContext
    private var cityFetchedResult = [Forecast]()
    @Published var citys = [CityResponse]()
    @Published var searchString = ""

    public func searchCitys() async {
        do {
            let request = Forecast.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            cityFetchedResult = (try? context.fetch(request)) ?? []
            
            
            let endpoint = WeatherAPIEndpoint.geo(name: searchString)
            let (data,_) = try await URLSession.shared.data(from: endpoint.url)
            let result = try JSONDecoder().decode([CityResponse].self, from: data)
            
            await MainActor.run(body: {
                
                citys = result.map { item in
                    if cityFetchedResult.contains(where: { $0.name == item.name && $0.country == item.country }) {
                        var newItem = item
                        newItem.isLocal = true
                        return newItem
                    } else {
                        return item
                    }
                }})
        } catch {
            await MainActor.run(body: {
                citys = []
            })
        }
    }
    
    public func clean() {
        citys = []
    }
    
    public func storeCity(city: CityResponse) async {
        do {
            print("Exec")
            let forecastEndpoint = WeatherAPIEndpoint.forecast(lat: city.lat, lon: city.lon)
            let (data,_) = try await URLSession.shared.data(from: forecastEndpoint.url)
            let forecast = try JSONDecoder().decode(ForecastResponse.self, from: data)
            
            guard let forecastItem = forecast.list.first else {
                return
            }
            
            let newForecast = Forecast(context: context)
            newForecast.name = city.name
            newForecast.lon = city.lon
            newForecast.lat = city.lat
            newForecast.country = city.country
            newForecast.timestamp = forecastItem.dt
            newForecast.temperature = forecastItem.main.temp
            newForecast.windSpeed = forecastItem.wind.speed
            newForecast.windAngle = forecastItem.wind.deg
                        
            try context.save()
            
            await MainActor.run(body: {
                citys = citys.map { item in
                    if item.name == city.name && item.country == city.country {
                        var newItem = item
                        newItem.isLocal = true
                        return newItem
                    } else {
                        return item
                    }
                }
            })
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
