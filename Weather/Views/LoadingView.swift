//
//  CitySearchViewRow.swift
//  Weather
//
//  Created by Ruslan Kandratsenka on 24.01.25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ProgressView() {
                    Text("Loading")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .tint(.gray)
                .controlSize(.large)
            }.frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color(red: 0.8,green: 0.8, blue: 0.8,opacity: 0.8))
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
