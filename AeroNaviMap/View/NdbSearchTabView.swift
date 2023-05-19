//
//  NdbSearchTabView.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/9/22.
//

import SwiftUI
import MapboxMaps

struct NdbSearchTabView: View {
    @ObservedObject var ndbSearchTabViewModel: NdbSearchTabViewModel
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
                TextField(text: $ndbSearchTabViewModel.name) {
                    Text("Name")
                }
                        .autocorrectionDisabled()
                TextField(text: $ndbSearchTabViewModel.icao) {
                    Text("ID")
                }
                .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()

                TextField(text: $ndbSearchTabViewModel.region) {
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
                    if ndbSearchTabViewModel.isSearchInvalid {
                        VStack {
                            Text("Please include more details for search.")
                        }
                    } else {
                        if ndbSearchTabViewModel.searchResults.isEmpty {
                            VStack {
                                Text("We cannot find any record.")
                            }
                        } else {
                            ForEach($ndbSearchTabViewModel.searchResults) { ndb in
                                NavigationLink {
                                    InfoPanelView(searchedNdb: ndb.wrappedValue, mapView: $mapView)
                                } label: {
                                    if let unwrappedId = ndb.ident,
                                       let unwrappedName = ndb.name,
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

                .onChange(of: ndbSearchTabViewModel.name) { _ in
                    ndbSearchTabViewModel.searchVor()
                }
                .onChange(of: ndbSearchTabViewModel.icao) { _ in
                    ndbSearchTabViewModel.searchVor()
                }
                .onChange(of: ndbSearchTabViewModel.region) { _ in
                    ndbSearchTabViewModel.searchVor()
                }
    }
}
