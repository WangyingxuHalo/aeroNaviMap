//
//  ILSInfoPanel.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/12/22.
//

import SwiftUI
import MapKit
import MapboxMaps

struct ILSInfoPanel: View {
    var searchedILS: ILS
    @Binding var mapView: MapView
    var body: some View {
        VStack {
            ILSInfoPanelDetail(ilsInfoPanelViewModel: ILSInfoPanelViewModel(ils: searchedILS), mapView: $mapView)
        }
    }
    
        
}
