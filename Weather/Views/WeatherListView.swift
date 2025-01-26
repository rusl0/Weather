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
    @State private var showAlert = false
    
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
                                Text(" \(item.country ?? "")")
                                    .font(.title2)
                                    .bold()
                                Spacer()
                                Text(temperatureFormatter(value: item.temperature))
                                    .font(.title2)
                            }
                            .padding(.bottom, 1)
                            VStack(alignment: .leading){
                                Text("Wind speed: \(speedFormatter(value:item.windSpeed)) m/s")
                                Text("Wind direction: \(item.windAngle) \(angleFormatter(value: item.windAngle))")
                            }
                            .padding(.bottom)
                        }
                        .padding(.horizontal, 15)
                    }
                    .groupBoxStyle(CardGroupBoxStyle())
                }
                .onDelete(perform: deleteItems)
            }
            .alert("Update error", isPresented: $showAlert, actions: {
                Button("Ok",role: .cancel) {}
            })
            .navigationTitle("Forecast")
            .listStyle(.inset)
        }
        .refreshable {
            Task {
                do {
                    try await updateData()
                } catch {
                    showAlert = true
                }
            }
        }
    }
    
    private func updateData() async throws{
        let request = Forecast.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        request.fetchLimit = 60
        
        guard let date = Calendar.current.date(byAdding: .hour, value: -3, to: Date()) else {
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

func speedFormatter(value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 1
    return formatter.string(from: NSNumber(value: value)) ?? "0"
}

func angleFormatter(value: Int16) -> String {
    
    switch value {
        case 0..<12,349...360:
            return "N"
        case 12..<34:
            return "NNE"
        case 34..<57:
            return "NE"
        case 57..<79:
            return "ENE"
        case 79..<102:
            return "E"
        case 102..<124:
            return "ESE"
        case 124..<147:
            return "SE"
        case 147..<169:
            return "SSE"
        case 169..<192:
            return "S"
        case 192..<214:
            return "SSW"
        case 214..<237:
            return "SW"
        case 237..<259:
            return "WSW"
        case 259..<282:
            return "W"
        case 282..<304:
            return "WNW"
        case 304..<327:
            return "NW"
        case 327..<349:
            return "NNW"
        default:
            return ""
    }
}
