//
//  AirwayInfoPanel.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/12/22.
//

import SwiftUI
import MapKit
import MapboxMaps

struct AirwayInfoPanel: View {
    var searchedAirway: Airway
    @Binding var mapView: MapView
    var body: some View {
        VStack {
            AirwayInfoPanelDetail(airwayInfoPanelViewModel: AirwayInfoPanelViewModel(airway: searchedAirway), mapView: $mapView)
        }
    }
    
        
}
