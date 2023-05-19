//
//  NAVSearchTabView.swift
//  AeroNaviMap
//
//  Created by Yingxu Wang on 11/2/22.
//
import SwiftUI
import MapboxMaps

struct NAVSearchTabView: View {
    @ObservedObject var navSearchTabViewModel: NavSearchTabViewModel
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
                TextField(text: $navSearchTabViewModel.icao) {
                    Text("ID")
                }
                .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()

//                TextField(text: $navSearchTabViewModel.region) {
//                    Text("Region")
//                }
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
                    if navSearchTabViewModel.isSearchInvalid {
                        VStack {
                            Text("Please include more details for search.")
                        }
                    } else {
                        if navSearchTabViewModel.searchResults.isEmpty {
                            VStack {
                                Text("We cannot find any record.")
                            }
                        } else {
                            ForEach($navSearchTabViewModel.searchResults) { nav in
                                NavigationLink {
                                    InfoPanelView(searchedNav: nav.wrappedValue, mapView: $mapView)
                                } label: {
                                    if let unwrappedName = nav.ident, let unwrappedLaty = nav.laty, let unwrappedLonx = nav.lonx,
                                       let name = unwrappedName.wrappedValue, let laty = unwrappedLaty.wrappedValue, let lonx = unwrappedLonx.wrappedValue {
                                        Text("\(name) \(laty), \(lonx)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
                    .navigationViewStyle(StackNavigationViewStyle())
        }

                .onChange(of: navSearchTabViewModel.icao) { _ in
                    navSearchTabViewModel.searchAirport()
                }
                .onChange(of: navSearchTabViewModel.region) { _ in
                    navSearchTabViewModel.searchAirport()
                }
    }
}
