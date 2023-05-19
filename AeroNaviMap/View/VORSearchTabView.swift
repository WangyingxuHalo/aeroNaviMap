//
//  VORSearchTabView.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/9/22.
//

import SwiftUI
import MapboxMaps

struct VORSearchTabView: View {
    @ObservedObject var vorSearchTabViewModel: VorSearchTabViewModel
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
                TextField(text: $vorSearchTabViewModel.name) {
                    Text("Name")
                }
                        .autocorrectionDisabled()
                TextField(text: $vorSearchTabViewModel.icao) {
                    Text("ID")
                }
                .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()

                TextField(text: $vorSearchTabViewModel.region) {
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
                    if vorSearchTabViewModel.isSearchInvalid {
                        VStack {
                            Text("Please include more details for search.")
                        }
                    } else {
                        if vorSearchTabViewModel.searchResults.isEmpty {
                            VStack {
                                Text("We cannot find any record.")
                            }
                        } else {
                            ForEach($vorSearchTabViewModel.searchResults) { vor in
                                NavigationLink {
                                    InfoPanelView(searchedVor: vor.wrappedValue, mapView: $mapView)
                                } label: {
                                    if let unwrappedName = vor.ident,
                                       let name = unwrappedName.wrappedValue {
                                        Text(name)
                                    }
                                }
                            }
                        }
                    }
                }
            }
                    .navigationViewStyle(StackNavigationViewStyle())
        }

                .onChange(of: vorSearchTabViewModel.name) { _ in
                        vorSearchTabViewModel.searchVor()
                }
                .onChange(of: vorSearchTabViewModel.icao) { _ in
                    vorSearchTabViewModel.searchVor()
                }
                .onChange(of: vorSearchTabViewModel.region) { _ in
                    vorSearchTabViewModel.searchVor()
                }
    }
}
