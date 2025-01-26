//
//  ContentView.swift
//  Weather
//
//  Created by Ruslan Kandratsenka on 24.01.25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            WeatherListView()
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Search")
                }
            CitySearchView()
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Weather")
                }
        }
    }
}
