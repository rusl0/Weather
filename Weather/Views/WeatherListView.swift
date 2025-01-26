//
//  WeatherListView.swift
//  Weather
//
//  Created by Ruslan Kandratsenka on 24.01.25.
//

import SwiftUI

struct WeatherListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Forecast.name, ascending: true)], animation: .default)
    private var items: FetchedResults<Forecast>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    GroupBox {
                        VStack {
                            HStack {
                                Text(item.name ?? "" )
                                    .font(.title2)
                                    .bold()
                                Spacer()
                                Text(temperatureFormatter(value: item.temperature))
                                    .font(.title2)
                            }
                            .padding(.bottom, 1)
                            VStack(alignment: .leading){
                                Text("Скорость ветра: \(item.windSpeed) м/с")
                                Text("Направление ветра \(item.windAngle)")
                            }
                            .padding(.bottom)
                        }
                        .padding(.horizontal, 15)
                    }
                    .groupBoxStyle(CardGroupBoxStyle())
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Forecast")
            .listStyle(.inset)
        }
        .refreshable {
            Task {
                await updateData()
            }
        }
    }
    
    private func updateData() async {
        let request = Forecast.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        request.fetchLimit = 60
        
        guard let date = Calendar.current.date(byAdding: .hour, value: -3, to: Date()) else {
            print("error")
            return
        }
        
        request.predicate = NSPredicate(format: "timestamp > %d",Int32(date.timeIntervalSince1970))
        let forecastResult = (try? viewContext.fetch(request)) ?? []
        
        await withTaskGroup(of: Void.self) { taskGroup in
            for forecastItem in forecastResult {
                taskGroup.addTask {
                    
                    do {
                        let forecastEndpoint = WeatherAPIEndpoint.forecast(lat: forecastItem.lat, lon: forecastItem.lon)
                        let (data,_) = try await URLSession.shared.data(from: forecastEndpoint.url)
                        let forecast = try? JSONDecoder().decode(ForecastResponse.self, from: data)
                        
                        guard let item = forecast?.list.first else {
                            return
                        }
                        
                        forecastItem.temperature = item.main.temp
                        forecastItem.timestamp = item.dt
                        forecastItem.windAngle = item.wind.deg
                        forecastItem.windSpeed = item.wind.speed
                    } catch {
                    }
                }
            }
        }
        
        do {
            if viewContext.hasChanges {
                try viewContext.save()
            }
        } catch {
            
        }
    }
    
    private func deleteItems(offset: IndexSet) {
        withAnimation {
            offset.map { items[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}

struct WeatherListView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListView()
    }
}

func temperatureFormatter(value: Double) -> String {
    let measurement = Measurement(value: value, unit: UnitTemperature.celsius)
    let formatter = MeasurementFormatter()
    formatter.unitStyle = .short
    formatter.numberFormatter.maximumFractionDigits = 0
    formatter.unitOptions = .temperatureWithoutUnit
    return formatter.string(from: measurement)
}
