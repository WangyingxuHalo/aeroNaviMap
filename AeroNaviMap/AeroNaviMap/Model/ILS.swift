//
//  ILS.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/19/22.
//

import Foundation
import MapKit

class ILS: CustomPolygon, Identifiable {
    var end1_lonx: Double?
    var end1_laty: Double?
    var end_mid_lonx: Double?
    var end_mid_laty: Double?
    var end2_lonx: Double?
    var end2_laty: Double?
    var lonx: Double?
    var laty: Double?
    
    var ident: String?
    var name: String?
    var frequency: Int?
    var range: Int?
    var mag_var: Double?
    var has_backcourse: Int?
    var dme_range: Int?
    var dme_altitude: Int?
    var dme_lonx: Double?
    var dme_laty: Double?
    var gs_range: Int?
    var gs_pitch: Double?
    var gs_altitude: Int?
    var loc_runway_name: String?
    var loc_airport_ident: String?
    var loc_heading: Double?
    var loc_width: Double?
    var altitude: Int?

    init(end1_lonx: Double?, end1_laty: Double?, end_mid_lonx: Double?, end_mid_laty: Double?, end2_lonx: Double?, end2_laty: Double?, lonx: Double?, laty: Double?) {
        let ilsCoordinates = [CLLocationCoordinate2D(latitude: end1_laty ?? 0, longitude: end1_lonx ?? 0), CLLocationCoordinate2D(latitude: end_mid_laty ?? 0, longitude: end_mid_lonx ?? 0), CLLocationCoordinate2D(latitude: end2_laty ?? 0, longitude: end2_lonx ?? 0), CLLocationCoordinate2D(latitude: laty ?? 0, longitude: lonx ?? 0)]
        self.end1_lonx = end1_lonx
        self.end1_laty = end1_laty
        self.end_mid_lonx = end_mid_lonx
        self.end_mid_laty = end_mid_laty
        self.end2_lonx = end2_lonx
        self.end2_laty = end2_laty
        self.lonx = lonx
        self.laty = laty
        super.init(coordinates: ilsCoordinates)
    }
    
    init(ident: String?, name: String?, frequency: Int?, range: Int?, mag_var: Double?, has_backcourse: Int?, dme_range: Int?, dme_altitude: Int?, dme_lonx: Double?, dme_laty: Double?, gs_range: Int?, gs_pitch: Double?, gs_altitude: Int?, loc_runway_name: String?, loc_airport_ident: String?, loc_heading: Double?, loc_width: Double?, altitude: Int?, laty:Double?, lonx:Double?) {
        self.ident = ident
        self.name = name
        self.frequency = frequency
        self.range = range
        self.mag_var = mag_var
        self.has_backcourse = has_backcourse
        self.dme_range = dme_range
        self.dme_altitude = dme_altitude
        self.dme_lonx = dme_lonx
        self.dme_laty = dme_laty
        self.gs_range = gs_range
        self.gs_pitch = gs_pitch
        self.gs_altitude = gs_altitude
        self.loc_runway_name = loc_runway_name
        self.loc_airport_ident = loc_airport_ident
        self.loc_heading = loc_heading
        self.loc_width = loc_width
        self.altitude = altitude
        self.laty = laty
        self.lonx = lonx
        
        let ilsCoordinates = [CLLocationCoordinate2D(latitude: 0, longitude: 0), CLLocationCoordinate2D(latitude: 0, longitude: 0), CLLocationCoordinate2D(latitude: 0, longitude: 0), CLLocationCoordinate2D(latitude: 0, longitude: 0)]
        
        super.init(coordinates: ilsCoordinates)
    }
    
}
