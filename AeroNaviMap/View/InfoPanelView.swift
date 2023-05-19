//
//  InfoPanelView.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 10/25/22.
//

import SwiftUI
import MapKit
import MapboxMaps

struct InfoPanelView: View {
    var selectedPointAnnotation: MKAnnotation?
    var searchedAirport: Airport?
    var searchedNav: NAV?
    var searchedVor: VOR?
    var searchedNdb: NDB?
    var searchedWaypoint: Waypoint?
    var searchedAirway: Airway?
    @Binding var mapView: MapView
    var body: some View {
        VStack {
            if let airport = (selectedPointAnnotation as? Airport) ?? searchedAirport {
                AirportInfoPanel(airportInfoPanelViewModel: AirportInfoPanelViewModel(airport: airport), mapView: $mapView)
            } else if let nav = (selectedPointAnnotation as? NAV) ??
                    searchedNav {
                NavInfoPanel(navInfoPanelViewModel: NavInfoPanelViewModel(nav: nav))
            } else if let vor = (selectedPointAnnotation as? VOR) ?? searchedVor {
                VorInfoPanel(vorInfoPanelViewModel: VorInfoPanelViewModel(vor: vor))
            } else if let ndb = (selectedPointAnnotation as? NDB) ?? searchedNdb {
                NdbInfoPanel(ndbInfoPanelViewModel: NdbInfoPanelViewModel(ndb: ndb))
            } else if let waypoint = (selectedPointAnnotation as? Waypoint) ?? searchedWaypoint {
                WaypointInfoPannel(waypointInfoPanelViewModel: WaypointInfoPanelViewModel(waypoint: waypoint))
            } else {
                Text("Unkown Annotation")
            }
        }
                .onAppear {
                    if let airport = searchedAirport,
                       let laty = airport.laty,
                       let lonx = airport.lonx {
                        mapView.mapboxMap.setCamera(to: CameraOptions(center: CLLocationCoordinate2D(latitude: laty, longitude: lonx), zoom: 10.0))
                    } else if let nav = searchedNav,
                              let laty = nav.laty,
                              let lonx = nav.lonx {
                               mapView.mapboxMap.setCamera(to: CameraOptions(center: CLLocationCoordinate2D(latitude: laty, longitude: lonx), zoom: 10.0))
                    } else if let vor = searchedVor,
                              let laty = vor.laty,
                              let lonx = vor.lonx {
                               mapView.mapboxMap.setCamera(to: CameraOptions(center: CLLocationCoordinate2D(latitude: laty, longitude: lonx), zoom: 10.0))
                    } else if let ndb = searchedNdb,
                              let laty = ndb.laty,
                              let lonx = ndb.lonx {
                               mapView.mapboxMap.setCamera(to: CameraOptions(center: CLLocationCoordinate2D(latitude: laty, longitude: lonx), zoom: 10.0))
                    }
                }
    }
}
