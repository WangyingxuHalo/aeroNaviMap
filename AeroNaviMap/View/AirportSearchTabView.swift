//
//  AirportSearchTabView.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/25/22.
//

import SwiftUI
import MapboxMaps

struct AirportSearchTabView: View {
    @ObservedObject var airportSearchTabViewModel: AirportSearchTabViewModel
    @Binding var mapView: MapView
    @Environment(\.colorScheme) var themeScheme
    @State var viewTabBackgroundColor = UIColor.theme.grayBackground
    let sec1Columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        VStack {
            LazyVGrid(columns: sec1Columns) {
                TextField(text: $airportSearchTabViewModel.name) {
                    Text("Name")
                }
                        .autocorrectionDisabled()
                TextField(text: $airportSearchTabViewModel.icao) {
                    Text("ICAO")
                }
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                TextField(text: $airportSearchTabViewModel.city) {
                    Text("City")
                }
                        .autocorrectionDisabled()
                TextField(text: $airportSearchTabViewModel.state) {
                    Text("State")
                }
                        .autocorrectionDisabled()
                TextField(text: $airportSearchTabViewModel.region) {
                    Text("Region")
                }
                        .autocorrectionDisabled()
            }
            .padding()
            .background(Rectangle()
                .cornerRadius(5.0)
                .onAppear {
                    viewTabBackgroundColor = themeScheme == .dark ? UIColor.theme.blackBackground : UIColor.theme.grayBackground
                }
                .foregroundColor(Color(uiColor: viewTabBackgroundColor))
            )
            NavigationView {
                List {
                    if airportSearchTabViewModel.isSearchInvalid {
                        VStack {
                            Text("Please include more details for search.")
                        }
                    } else {
                        if airportSearchTabViewModel.searchResults.isEmpty {
                            VStack {
                                Text("We cannot find any record.")
                            }
                        } else {
                            ForEach($airportSearchTabViewModel.searchResults) { airport in
                                NavigationLink {
                                    InfoPanelView(searchedAirport: airport.wrappedValue, mapView: $mapView)
                                } label: {
                                    if let unwrappedId = airport.ident,
                                        let unwrappedName = airport.name,
                                       let id = unwrappedId.wrappedValue, let name = unwrappedName.wrappedValue {
                                        Text("\(id) - \(name)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
                    .navigationViewStyle(StackNavigationViewStyle())
        }
                .onChange(of: airportSearchTabViewModel.name) { _ in
                    airportSearchTabViewModel.searchAirport()
                }
                .onChange(of: airportSearchTabViewModel.icao) { _ in
                    airportSearchTabViewModel.searchAirport()
                }
                .onChange(of: airportSearchTabViewModel.city) { _ in
                    airportSearchTabViewModel.searchAirport()
                }
                .onChange(of: airportSearchTabViewModel.state) { _ in
                    airportSearchTabViewModel.searchAirport()
                }
                .onChange(of: airportSearchTabViewModel.region) { _ in
                    airportSearchTabViewModel.searchAirport()
                }
    }
}
