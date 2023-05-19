//
//  AirportInfoPanel.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 10/25/22.
//

import SwiftUI
import MapboxMaps

struct AirportInfoPanel: View {
    @ObservedObject var airportInfoPanelViewModel: AirportInfoPanelViewModel
    
    @Binding var mapView: MapView
    var body: some View {
        TabView {
            AirportGeneralInfoTab(airportInfoPanelViewModel: airportInfoPanelViewModel)
                    .tabItem {
                        Label("General", systemImage: "info.circle.fill")
                    }
            AirportRunwayInfoTab(airportInfoPanelViewModel: airportInfoPanelViewModel)
                    .tabItem {
                        Label("Runway", systemImage: "r.rectangle.roundedbottom")
                    }
            AirportWikiInfoTab(airportInfoPanelViewModel: airportInfoPanelViewModel)
                .tabItem {
                    Label("Wikipedia", systemImage: "book.closed.fill")
                }
        }
    }
}

