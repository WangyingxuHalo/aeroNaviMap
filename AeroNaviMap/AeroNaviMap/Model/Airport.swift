//
//  Airport.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/19/22.
//

import MapKit

class Airport: NSObject, Identifiable, MKAnnotation {
    var title: String?
    var subtitle: String?
    var airport_id: Int?
    var lonx: Double?
    var laty: Double?

    var imageName: String?

    var file_id: Int?
    var ident: String?
    var icao: String?
    var iata: String?
    var xpident: String?
    var name: String?
    var city: String?
    var state: String?
    var country: String?
    var region: String?
    var flatten: Int?
    var fuel_flags: Int?
    var has_avgas: Int?
    var has_jetfuel: Int?
    var has_tower_object: Int?

    var tower_frequency: Int?
    var atis_frequency: Int?
    var awos_frequency: Int?
    var asos_frequency: Int?
    var unicom_frequency: Int?

    var is_closed: Int?
    var is_military: Int?
    var is_addon: Int?

    var num_com: Int?

    var num_parking_gate: Int?
    var num_parking_ga_ramp: Int?
    var num_parking_cargo: Int?
    var num_parking_mil_cargo: Int?
    var num_parking_mil_combat: Int?

    var num_approach: Int?
    var num_runway_hard: Int?
    var num_runway_soft: Int?
    var num_runway_water: Int?
    var num_runway_light: Int?
    var num_runway_end_closed: Int?
    var num_runway_end_vasi: Int?
    var num_runway_end_als: Int?
    var num_runway_end_ils: Int?

    var num_apron: Int?
    var num_taxi_path: Int?
    var num_helipad: Int?
    var num_jetway: Int?
    var num_starts: Int?

    var longest_runway_length: Int?
    var longest_runway_width: Int?
    var longest_runway_heading: Double?
    var longest_runway_surface: String?


    var num_runways: Int?
    var largest_parking_ramp: String?
    var largest_parking_gate: String?
    var rating: Int?


    var is_3d: Int?

    var scenery_local_path: String?
    var bgl_filename: String?

    var left_lonx: Double?
    var top_laty: Double?
    var right_lonx: Double?
    var bottom_laty: Double?

    var mag_var: Double?
    var tower_altitude: Int?
    var tower_lonx: Double?
    var tower_laty: Double?
    var transition_altitude: Int?
    var altitude: Int?

    init(title: String?, subtitle: String?, airport_id: Int?, lonx: Double?, laty: Double?, imageName: String?) {

        self.title = title
        self.subtitle = subtitle
        self.airport_id = airport_id
        self.lonx = lonx
        self.laty = laty
        self.imageName = imageName
    }

    init(title: String?, subtitle: String?, airport_id: Int?, file_id: Int?, ident: String?, icao: String?, iata: String?, xpident: String?, name: String?, city: String?, state: String?, country: String?, region: String?, flatten: Int?, fuel_flags: Int?, has_avgas: Int?, has_jetfuel: Int?, has_tower_object: Int?, tower_frequency: Int?, atis_frequency: Int?, awos_frequency: Int?, asos_frequency: Int?, unicom_frequency: Int?, is_closed: Int?, is_military: Int?, is_addon: Int?, num_com: Int?, num_parking_gate: Int?, num_parking_ga_ramp: Int?, num_parking_cargo: Int?, num_parking_mil_cargo: Int?, num_parking_mil_combat: Int?, num_approach: Int?, num_runway_hard: Int?, num_runway_soft: Int?, num_runway_water: Int?, num_runway_light: Int?, num_runway_end_closed: Int?, num_runway_end_vasi: Int?, num_runway_end_als: Int?, num_runway_end_ils: Int?, num_apron: Int?, num_taxi_path: Int?, num_helipad: Int?, num_jetway: Int?, num_starts: Int?, longest_runway_length: Int?, longest_runway_width: Int?, longest_runway_heading: Double?, longest_runway_surface: String?, num_runways: Int?, largest_parking_ramp: String?, largest_parking_gate: String?, rating: Int?, is_3d: Int?, scenery_local_path: String?, bgl_filename: String?, left_lonx: Double?, top_laty: Double?, right_lonx: Double?, bottom_laty: Double?, mag_var: Double?, tower_altitude: Int?, tower_lonx: Double?, tower_laty: Double?, transition_altitude: Int?, altitude: Int?, lonx: Double?, laty: Double?, imageName: String?) {

        self.title = title
        self.subtitle = subtitle
        self.airport_id = airport_id
        self.file_id = file_id
        self.ident = ident
        self.icao = icao
        self.iata = iata
        self.xpident = xpident
        self.name = name
        self.city = city
        self.state = state
        self.country = country
        self.region = region
        self.flatten = flatten
        self.fuel_flags = fuel_flags
        self.has_avgas = has_avgas
        self.has_jetfuel = has_jetfuel
        self.has_tower_object = has_tower_object
        self.tower_frequency = tower_frequency
        self.atis_frequency = atis_frequency
        self.awos_frequency = awos_frequency
        self.asos_frequency = asos_frequency
        self.unicom_frequency = unicom_frequency
        self.is_closed = is_closed
        self.is_military = is_military
        self.is_addon = is_addon
        self.num_com = num_com
        self.num_parking_gate = num_parking_gate
        self.num_parking_ga_ramp = num_parking_ga_ramp
        self.num_parking_cargo = num_parking_cargo
        self.num_parking_mil_cargo = num_parking_mil_cargo
        self.num_parking_mil_combat = num_parking_mil_combat
        self.num_approach = num_approach
        self.num_runway_hard = num_runway_hard
        self.num_runway_soft = num_runway_soft
        self.num_runway_water = num_runway_water
        self.num_runway_light = num_runway_light
        self.num_runway_end_closed = num_runway_end_closed
        self.num_runway_end_vasi = num_runway_end_vasi
        self.num_runway_end_als = num_runway_end_als
        self.num_runway_end_ils = num_runway_end_ils
        self.num_apron = num_apron
        self.num_taxi_path = num_taxi_path
        self.num_helipad = num_helipad
        self.num_jetway = num_jetway
        self.num_starts = num_starts
        self.longest_runway_length = longest_runway_length
        self.longest_runway_width = longest_runway_width
        self.longest_runway_heading = longest_runway_heading
        self.longest_runway_surface = longest_runway_surface
        self.num_runways = num_runways
        self.largest_parking_ramp = largest_parking_ramp
        self.largest_parking_gate = largest_parking_gate
        self.rating = rating
        self.is_3d = is_3d
        self.scenery_local_path = scenery_local_path
        self.bgl_filename = bgl_filename
        self.left_lonx = left_lonx
        self.top_laty = top_laty
        self.right_lonx = right_lonx
        self.bottom_laty = bottom_laty
        self.mag_var = mag_var
        self.tower_altitude = tower_altitude
        self.tower_lonx = tower_lonx
        self.tower_laty = tower_laty
        self.transition_altitude = transition_altitude
        self.altitude = altitude
        self.lonx = lonx
        self.laty = laty
        self.imageName = imageName
    }

    @objc dynamic var coordinate: CLLocationCoordinate2D {
        if let latitude = laty, let longitude = lonx {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
}

