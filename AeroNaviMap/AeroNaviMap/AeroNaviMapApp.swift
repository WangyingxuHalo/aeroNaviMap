//
//  AeroNaviMapApp.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/18/22.
//

import SwiftUI
import MapboxMaps

@main
struct AeroNaviMapApp: App {
    var body: some Scene {
        WindowGroup {
            GeometryReader { geometryReader in
                let frame = geometryReader.frame(in: CoordinateSpace.local)
                HomeView(mapView: MapView(frame: frame))
            }
                    .edgesIgnoringSafeArea(.leading)
                    .edgesIgnoringSafeArea(.trailing)
        }
    }
}
