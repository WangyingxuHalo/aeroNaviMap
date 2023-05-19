//
//  SearchView.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/25/22.
//

import SwiftUI
import MapboxMaps

struct SearchView: View {
    @StateObject var searchViewViewModel: SearchViewViewModel
    @StateObject var airportSearchTabViewModel: AirportSearchTabViewModel = AirportSearchTabViewModel()
    @StateObject var navSearchTabViewModel: NavSearchTabViewModel = NavSearchTabViewModel()
    @StateObject var vorSearchTabViewModel: VorSearchTabViewModel = VorSearchTabViewModel()
    @StateObject var ndbSearchTabViewModel: NdbSearchTabViewModel = NdbSearchTabViewModel()
    @StateObject var airwaySearchTabViewModel: AirwaySearchTabViewModel = AirwaySearchTabViewModel()
    @StateObject var ilsSearchTabViewModel: ILSSearchTabViewModel = ILSSearchTabViewModel()
    @Binding var mapView: MapView
    var body: some View {
        TabView(selection: $searchViewViewModel.selectedTab) {
            AirportSearchTabView(airportSearchTabViewModel: airportSearchTabViewModel, mapView: $mapView)
                .tabItem {
                    HStack {
                        Text("Airport")
                    }
                }
                .tag(0)
            NAVSearchTabView(navSearchTabViewModel: navSearchTabViewModel, mapView: $mapView)
                .tabItem {
                    HStack {
                        Text("NAV")
                    }
                }
                .tag(1)
            VORSearchTabView(vorSearchTabViewModel: vorSearchTabViewModel, mapView: $mapView)
                .tabItem {
                    HStack {
                        Text("VOR")
                    }
                }
                .tag(2)
            NdbSearchTabView(ndbSearchTabViewModel: ndbSearchTabViewModel, mapView: $mapView)
                .tabItem {
                    HStack {
                        Text("NDB")
                    }
                }
                .tag(3)
            AirwaySearchTabView(airwaySearchTabViewModel: airwaySearchTabViewModel, mapView: $mapView)
                .tabItem {
                    HStack {
                        Text("Airway")
                    }
                }
                .tag(4)
            ILSSearchTabView(ilsSearchTabViewModel: ilsSearchTabViewModel, mapView: $mapView)
                .tabItem {
                    HStack {
                        Text("ILS")
                    }
                }
                .tag(5)
        }
        .padding()
        .background(Color(uiColor: UIColor.theme.darkBlue))
        .onChange(of: searchViewViewModel.selectedTab) { _ in
            searchViewViewModel.writePerferenceIntoDisk()
        }
    }
}
