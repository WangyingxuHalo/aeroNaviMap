//
//  CustomPolygon.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/19/22.
//

import Foundation
import CoreLocation

class CustomPolygon {
    var coordinates: [CLLocationCoordinate2D]?

    init(coordinates: [CLLocationCoordinate2D]) {
        self.coordinates = coordinates
    }
}
