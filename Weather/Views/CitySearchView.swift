//
//  CitySearchView.swift
//  Weather
//
//  Created by Ruslan Kandratsenka on 24.01.25.
//

import SwiftUI

struct CitySearchView: View {
    @Environment(\.isSearching) private var isSearching
    @State private var isUpdating = false
    @ObservedObject var viewModel = SearchListViewModel()
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    List {
                        ForEach(viewModel.citys, id: \.id) { cityItem in
                            CitySearchViewRow(city: cityItem).onTapGesture {
                                if !cityItem.isLocal {
                                    Task {
                                        await viewModel.storeCity(city: cityItem)
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle("Search city")
                    .searchable(text: $viewModel.searchString,placement: .navigationBarDrawer(displayMode: .always))
                    .onSubmit(of: .search) {
                        isUpdating = true
                        Task {
                            await viewModel.searchCitys()
                            isUpdating = false
                        }
                    }
                    .onChange(of: isSearching, perform: { newValue in
                        if !newValue {
                            viewModel.clean()
                        }
                    })
                    .onAppear {
                        viewModel.clean()
                    }
                }
                .disabled(isUpdating)
            }
            if isUpdating {
                LoadingView()
            }
        }
    }
}

struct CitySearchView_Previews: PreviewProvider {
    static var previews: some View {
        CitySearchView()
    }
}

