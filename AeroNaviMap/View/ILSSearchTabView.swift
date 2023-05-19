//
//  ILSSearchTabView.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/12/22.
//

import SwiftUI
import MapboxMaps

struct ILSSearchTabView: View {
    @ObservedObject var ilsSearchTabViewModel: ILSSearchTabViewModel
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
                TextField(text: $ilsSearchTabViewModel.ident) {
                    Text("ICAO")
                }
                .textInputAutocapitalization(.characters)
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
                    if ilsSearchTabViewModel.isSearchInvalid {
                        VStack {
                            Text("Please include more details for search.")
                        }
                    } else {
                        if ilsSearchTabViewModel.searchResults.isEmpty {
                            VStack {
                                Text("We cannot find any record.")
                            }
                        } else {
                            ForEach($ilsSearchTabViewModel.searchResults) { ils in
                                NavigationLink {
                                    ILSInfoPanel(searchedILS: ils.wrappedValue, mapView: $mapView)
                                } label: {
                                    if let unwrappedName = ils.name,
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

        .onChange(of: ilsSearchTabViewModel.ident) { _ in
            ilsSearchTabViewModel.searchILS()
                }

    }
}
