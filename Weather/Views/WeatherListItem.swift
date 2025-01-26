//
//  WearherListItem.swift
//  Weather
//
//  Created by Ruslan Kandratsenka on 24.01.25.
//

import SwiftUI

struct WeatherListItem: View {
    
    var body: some View {
        GroupBox {
            VStack {
                HStack {
                    Text("City name")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Text(temperatureFormatter(value: 0.5))
                        .font(.title2)
                }
                .padding(.bottom, 1)
                
                VStack(alignment: .leading){
                    Text("Скорость ветра 1м/с")
                    Text("Направление ветра")
                }
                .padding(.bottom)
            }
            .padding(.horizontal, 15)
        }
        .groupBoxStyle(CardGroupBoxStyle())
    }
}

struct WearherListItem_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListItem()
    }
}

//
//func temperatureFormatter(value: Double) -> String {
//    
//    let measurement = Measurement(value: value, unit: UnitTemperature.celsius)
//    
//    let formatter = MeasurementFormatter()
//    formatter.unitStyle = .short
//    formatter.numberFormatter.maximumFractionDigits = 0
//    formatter.unitOptions = .temperatureWithoutUnit
//    
//    return formatter.string(from: measurement)
//}
