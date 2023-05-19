//
//  RunwayEnd.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/19/22.
//

import Foundation
import MapKit

class RunwayEnd: NSObject, Identifiable, MKAnnotation {
    var title: String? = ""
    var subtitle: String? = ""
    
    var name: String?
    var lonx: Double?
    var laty: Double?
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
    
    var runway_end_id: Int?
    var offset_threshold: Int?
    var overrun: Int?
    var left_vasi_type: String?
    var left_vasi_pitch: Double?
    var right_vasi_type: String?
    var right_vasi_pitch: Double?
    var has_closed_markings: Int?
    var has_stol_markings: Int?
    var is_takeoff: Int?
    var is_landing: Int?
    var is_pattern: String?
    var has_reils: Int?
    var num_strobes: Int?
    var heading: Double?
    var has_center_red: Int?
    var edge_light: String?
    var center_light: String?
    var pattern_altitude: Int?
    var marking_flags: Int?

    init(name: String?, heading: Double?, lonx: Double?, laty: Double?) {
        self.name = name
        self.heading = heading
        self.lonx = lonx
        self.laty = laty
    }
    
    init(lonx: Double?, laty: Double?, name: String?, surface: String?, length: Int?, width: Int?, altitude: Int?, app_light_system_type: String?, ils_ident: String?, end_type: String?, has_end_lights: Int?, has_touchdown_lights: Int?, blast_pad: Int?, offset_threshold: Int?,overrun: Int?,left_vasi_type: String?,left_vasi_pitch: Double?,right_vasi_type: String?,right_vasi_pitch: Double?,has_closed_markings: Int?,has_stol_markings: Int?,is_takeoff: Int?,is_landing: Int?,is_pattern: String?,has_reils: Int?,num_strobes: Int?,heading: Double?, has_center_red: Int?, edge_light: String?, center_light: String?, pattern_altitude: Int?, marking_flags: Int?) {
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
        self.offset_threshold = offset_threshold
        self.overrun = overrun
        self.left_vasi_type = left_vasi_type
        self.left_vasi_pitch = left_vasi_pitch
        self.right_vasi_type = right_vasi_type
        self.right_vasi_pitch = right_vasi_pitch
        self.has_closed_markings = has_closed_markings
        self.has_stol_markings = has_stol_markings
        self.is_takeoff = is_takeoff
        self.is_landing = is_landing
        self.is_pattern = is_pattern
        self.has_reils = has_reils
        self.num_strobes = num_strobes
        self.heading = heading
        self.has_center_red = has_center_red
        self.edge_light = edge_light
        self.center_light = center_light
        self.pattern_altitude = pattern_altitude
        self.marking_flags = marking_flags
    }

    @objc dynamic var coordinate: CLLocationCoordinate2D {
        if let latitude = laty, let longitude = lonx {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }


}
