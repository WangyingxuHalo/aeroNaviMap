//
//  MediumAirport.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/19/22.
//

import Foundation
import CoreLocation
import SQLite3
import MapKit

class MediumAirport: Airport {


    init(title: String?, subtitle: String?, airport_id: Int?, lonx: Double?, laty: Double?) {
        super.init(title: title, subtitle: subtitle, airport_id: airport_id, lonx: lonx, laty: laty, imageName: "mediumAirport")
    }

    init(title: String?, subtitle: String?, airport_id: Int?, file_id: Int?, ident: String?, icao: String?, iata: String?, xpident: String?, name: String?, city: String?, state: String?, country: String?, region: String?, flatten: Int?, fuel_flags: Int?, has_avgas: Int?, has_jetfuel: Int?, has_tower_object: Int?, tower_frequency: Int?, atis_frequency: Int?, awos_frequency: Int?, asos_frequency: Int?, unicom_frequency: Int?, is_closed: Int?, is_military: Int?, is_addon: Int?, num_com: Int?, num_parking_gate: Int?, num_parking_ga_ramp: Int?, num_parking_cargo: Int?, num_parking_mil_cargo: Int?, num_parking_mil_combat: Int?, num_approach: Int?, num_runway_hard: Int?, num_runway_soft: Int?, num_runway_water: Int?, num_runway_light: Int?, num_runway_end_closed: Int?, num_runway_end_vasi: Int?, num_runway_end_als: Int?, num_runway_end_ils: Int?, num_apron: Int?, num_taxi_path: Int?, num_helipad: Int?, num_jetway: Int?, num_starts: Int?, longest_runway_length: Int?, longest_runway_width: Int?, longest_runway_heading: Double?, longest_runway_surface: String?, num_runways: Int?, largest_parking_ramp: String?, largest_parking_gate: String?, rating: Int?, is_3d: Int?, scenery_local_path: String?, bgl_filename: String?, left_lonx: Double?, top_laty: Double?, right_lonx: Double?, bottom_laty: Double?, mag_var: Double?, tower_altitude: Int?, tower_lonx: Double?, tower_laty: Double?, transition_altitude: Int?, altitude: Int?, lonx: Double?, laty: Double?) {

        super.init(title: title, subtitle: subtitle, airport_id: airport_id, file_id: file_id, ident: ident, icao: icao, iata: iata, xpident: xpident, name: name, city: city, state: state, country: country, region: region, flatten: flatten, fuel_flags: fuel_flags, has_avgas: has_avgas, has_jetfuel: has_jetfuel, has_tower_object: has_tower_object, tower_frequency: tower_frequency, atis_frequency: atis_frequency, awos_frequency: awos_frequency, asos_frequency: asos_frequency, unicom_frequency: unicom_frequency, is_closed: is_closed, is_military: is_military, is_addon: is_addon, num_com: num_com, num_parking_gate: num_parking_gate, num_parking_ga_ramp: num_parking_ga_ramp, num_parking_cargo: num_parking_cargo, num_parking_mil_cargo: num_parking_mil_cargo, num_parking_mil_combat: num_parking_mil_combat, num_approach: num_approach, num_runway_hard: num_runway_hard, num_runway_soft: num_runway_soft, num_runway_water: num_runway_water, num_runway_light: num_runway_light, num_runway_end_closed: num_runway_end_closed, num_runway_end_vasi: num_runway_end_vasi, num_runway_end_als: num_runway_end_als, num_runway_end_ils: num_runway_end_ils, num_apron: num_apron, num_taxi_path: num_taxi_path, num_helipad: num_helipad, num_jetway: num_jetway, num_starts: num_starts, longest_runway_length: longest_runway_length, longest_runway_width: longest_runway_width, longest_runway_heading: longest_runway_heading, longest_runway_surface: longest_runway_surface, num_runways: num_runways, largest_parking_ramp: largest_parking_ramp, largest_parking_gate: largest_parking_gate, rating: rating, is_3d: is_3d, scenery_local_path: scenery_local_path, bgl_filename: bgl_filename, left_lonx: left_lonx, top_laty: top_laty, right_lonx: right_lonx, bottom_laty: bottom_laty, mag_var: mag_var, tower_altitude: tower_altitude, tower_lonx: tower_lonx, tower_laty: tower_laty, transition_altitude: transition_altitude, altitude: altitude, lonx: lonx, laty: laty, imageName: "mediumAirport")

    }
}
