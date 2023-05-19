//
//  AirwayInfoPanelDetail.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/12/22.
//

import SwiftUI
import MapboxMaps

struct AirwayInfoPanelDetail: View {
    @ObservedObject var airwayInfoPanelViewModel: AirwayInfoPanelViewModel
    @Binding var mapView: MapView
    @Environment(\.colorScheme) var themeScheme
    let sec1Columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: sec1Columns) {
                    
                    if let airway_name = airwayInfoPanelViewModel.airway.airway_name {
                        Text("Airway Name")
                        Text(airway_name);
                    }
                    if let airway_type = airwayInfoPanelViewModel.airway.airway_type {
                        Text("Airway Type")
                        Text(airway_type);
                    }
                    if let from_waypoint_id = airwayInfoPanelViewModel.airway.from_waypoint_id {
                        Text("From_waypoint_id")
                        Text("\(from_waypoint_id)");
                    }
                    if let to_waypoint_id = airwayInfoPanelViewModel.airway.from_waypoint_id {
                        Text("To_waypoint_id")
                        Text("\(to_waypoint_id)");
                    }
                    if let minimum_altitude = airwayInfoPanelViewModel.airway.minimum_altitude {
                        Text("Minimum_altitude")
                        Text("\(minimum_altitude)");
                    }
                    if let from_lonx = airwayInfoPanelViewModel.airway.from_lonx,
                       let from_laty = airwayInfoPanelViewModel.airway.from_laty {
                        Text("From Coordinate")
                        Text("\(from_lonx), \(from_laty)");
                    }
                    if let to_lonx = airwayInfoPanelViewModel.airway.to_lonx,
                       let to_laty = airwayInfoPanelViewModel.airway.to_laty {
                        Text("To Coordinate")
                        Text("\(to_lonx), \(to_laty)");
                    }
                }
                
            }
            .onAppear {
                if let from_laty: Double = airwayInfoPanelViewModel.airway.from_laty,
                   let from_lonx: Double = airwayInfoPanelViewModel.airway.from_lonx,
                   let to_laty: Double = airwayInfoPanelViewModel.airway.to_laty,
                   let to_lonx: Double = airwayInfoPanelViewModel.airway.to_lonx{
                    mapView.mapboxMap.setCamera(to: CameraOptions(center: CLLocationCoordinate2D(latitude: (from_laty + to_laty) / 2, longitude: (from_lonx + to_lonx) / 2), zoom: 10.0))
                }
            }

            
        }
        .padding()
    }
}
