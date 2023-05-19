//
//  Runway.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/19/22.
//

import Foundation
import Foundation
import CoreLocation
import SQLite3
import MapKit

class Runway: CustomPolyline, Identifiable {

    var runway_id: Int?
    var imageName: String? = "runway"
    var primary_lonx: Double?
    var primary_laty: Double?
    var secondary_lonx: Double?
    var secondary_laty: Double?
    var lonx: Double?
    var laty: Double?

    var name: String?
    var surface: String?
    var length: Int?
    var width: Int?
    var altitude: Int?
    var app_light_system_type: String?
    var ils_ident: String?
    var end_type: String?
    var has_end_lights: Int?
    var has_touchdown_lights: Int?
    var blast_pad: Int?

    init(runway_id: Int?, primary_lonx: Double?, primary_laty: Double?, secondary_lonx: Double?, secondary_laty: Double?, lonx: Double?, laty: Double?) {
        self.primary_lonx = primary_lonx
        self.primary_laty = primary_laty
        self.runway_id = runway_id
        self.secondary_lonx = secondary_lonx
        self.secondary_laty = secondary_laty
        self.lonx = lonx
        self.laty = laty
        super.init(from_lonx: primary_lonx, from_laty: primary_laty, to_lonx: secondary_lonx, to_laty: secondary_laty)
    }

    init(runway_id: Int?, primary_lonx: Double?, primary_laty: Double?, secondary_lonx: Double?, secondary_laty: Double?, lonx: Double?, laty: Double?, name: String?, surface: String?, length: Int?, width: Int?, altitude: Int?, app_light_system_type: String?, ils_ident: String?, end_type: String?, has_end_lights: Int?, has_touchdown_lights: Int?, blast_pad: Int?) {
        self.runway_id = runway_id
        self.primary_lonx = primary_lonx
        self.primary_laty = primary_laty
        self.secondary_lonx = secondary_lonx
        self.secondary_laty = secondary_laty
        self.lonx = lonx
        self.laty = laty
        self.name = name
        self.surface = surface
        self.length = length
        self.width = width
        self.altitude = altitude
        self.app_light_system_type = app_light_system_type
        self.ils_ident = ils_ident
        self.end_type = end_type
        self.has_end_lights = has_end_lights
        self.has_touchdown_lights = has_touchdown_lights
        self.blast_pad = blast_pad
        super.init(from_lonx: primary_lonx, from_laty: primary_laty, to_lonx: secondary_lonx, to_laty: secondary_laty)
    }
}

