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
    @State private var showNetworkAlert = false
    @State private var showSaveDataAlert = false
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    List {
                        ForEach(viewModel.citys, id: \.id) { cityItem in
                            CitySearchViewRow(city: cityItem).onTapGesture {
                                if !cityItem.isLocal {
                                    Task {
                                        do {
                                            try await viewModel.storeCity(city: cityItem)
                                        } catch {
                                            showSaveDataAlert = true
                                        }
                                        isUpdating = false
                                    }
                                }
                            }
                        }
                    }
                    .alert("Citys aquire error", isPresented: $showNetworkAlert) {
                        Button("Ok", role: .cancel) {}
                    }
                    .alert("Save data error", isPresented: $showSaveDataAlert) {
                        Button("Ok", role: .cancel) {}
                    }
                    .navigationTitle("Search city")
                    .searchable(text: $viewModel.searchString,placement: .navigationBarDrawer(displayMode: .always))
                    .onSubmit(of: .search) {
                        isUpdating = true
                        Task {
                            do {
                                try await viewModel.searchCitys()
                            } catch {
                                showNetworkAlert = true
                            }
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

