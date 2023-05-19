//
//  RibbonFunctionTabViewViewModel.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/25/22.
//

import MapboxMaps

class RibbonFunctionTabViewViewModel: ObservableObject {
    @Published var mapView: MapView
    @Published var mapStyleSelection: Int
    let defaults = UserDefaults.standard

    init(mapView: MapView, showSearchView: Bool) {
        self.mapView = mapView
        if defaults.object(forKey: "mapStyle") != nil {
            mapStyleSelection = defaults.integer(forKey: "mapStyle")
        } else {
            mapStyleSelection = 0
        }
    }

    func changeMapStyle(newStyle: Int) {
        switch mapStyleSelection {
        case 0:
            mapView.mapboxMap.style.uri = .outdoors
        case 1:
            mapView.mapboxMap.style.uri = .streets
        case 2:
            mapView.mapboxMap.style.uri = .satellite
        case 3:
            mapView.mapboxMap.style.uri = .satelliteStreets
        default:
            mapView.mapboxMap.style.uri = .outdoors
        }
        defaults.set(newStyle, forKey: "mapStyle")
    }

}

