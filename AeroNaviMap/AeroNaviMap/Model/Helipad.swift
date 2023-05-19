//
//  Helipad.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/19/22.
//

import Foundation
import CoreLocation
import SQLite3
import MapKit

class Helipad: NSObject, Identifiable, MKAnnotation {

    var title: String?
    var subtitle: String?
    var helipad_id: Int?
    var airport_id: Int?
    var start_id: Int?
    var surface: String?
    var type: String?
    var length: Double?
    var width: Double?
    var heading: Double?
    var is_transparent: Int?
    var is_closed: Int?
    var altitude: Int?
    var lonx: Double?
    var laty: Double?

    init(title: String?, subtitle: String?, helipad_id: Int?, airport_id: Int?, start_id: Int?, surface: String?, type: String?, length: Double?, width: Double?, heading: Double?, is_transparent: Int?, is_closed: Int?, altitude: Int?, lonx: Double?, laty: Double?) {

        self.title = title
        self.subtitle = subtitle
        self.helipad_id = helipad_id
        self.airport_id = airport_id
        self.start_id = start_id
        self.surface = surface
        self.type = type
        self.length = length
        self.width = width
        self.heading = heading
        self.is_transparent = is_transparent
        self.is_closed = is_closed
        self.altitude = altitude
        self.lonx = lonx
        self.laty = laty
    }

    @objc dynamic var coordinate: CLLocationCoordinate2D {
        if let latitude = laty, let longitude = lonx {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
}
