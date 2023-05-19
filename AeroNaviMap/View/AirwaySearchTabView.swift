//
//  AirwaySearchTabView.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/12/22.
//

import SwiftUI
import MapboxMaps

struct AirwaySearchTabView: View {
    @ObservedObject var airwaySearchTabViewModel: AirwaySearchTabViewModel
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
                TextField(text: $airwaySearchTabViewModel.airway_name) {
                    Text("Airway Name")
                }
                        .autocorrectionDisabled()
//                TextField(text: $airwaySearchTabViewModel.airway_type) {
//                    Text("Airway Type")
//                }
//                .textInputAutocapitalization(.characters)
//                        .autocorrectionDisabled()

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
                    if airwaySearchTabViewModel.isSearchInvalid {
                        VStack {
                            Text("Please include more details for search.")
                        }
                    } else {
                        if airwaySearchTabViewModel.searchResults.isEmpty {
                            VStack {
                                Text("We cannot find any record.")
                            }
                        } else {
                            ForEach($airwaySearchTabViewModel.searchResults) { airway in
                                NavigationLink {
                                    AirwayInfoPanel(searchedAirway: airway.wrappedValue, mapView: $mapView)
                                } label: {
                                    if let unwrappedName = airway.airway_name, let unfrom = airway.from_waypoint_id, let unto = airway.to_waypoint_id,
                                       let from = unfrom.wrappedValue, let to = unto.wrappedValue,
                                       let name = unwrappedName.wrappedValue {
                                        Text("\(name) \(from)-\(to)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
                    .navigationViewStyle(StackNavigationViewStyle())
        }

                .onChange(of: airwaySearchTabViewModel.airway_name) { _ in
                    airwaySearchTabViewModel.searchAirway()
                }
                .onChange(of: airwaySearchTabViewModel.airway_type) { _ in
                    airwaySearchTabViewModel.searchAirway()
                }
    }
}
