//
//  Airway.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/28/22.
//

import Foundation

class Airway: CustomPolyline, Identifiable {
    var airway_id: Int?
    var airway_name: String?
    var airway_type: String?
    var from_waypoint_id: Int?
    var to_waypoint_id: Int?
    var minimum_altitude: Int?

    init(airway_id: Int?, airway_name: String?, from_lonx: Double?, from_laty: Double?, to_lonx: Double?, to_laty: Double?) {
        self.airway_id = airway_id
        self.airway_name = airway_name
        super.init(from_lonx: from_lonx, from_laty: from_laty, to_lonx: to_lonx, to_laty: to_laty)
    }
    
    init(airway_id: Int?, airway_name: String?, from_lonx: Double?, from_laty: Double?, to_lonx: Double?, to_laty: Double?, airway_type: String?, from_waypoint_id: Int?, to_waypoint_id: Int?, minimum_altitude: Int?) {
        self.airway_id = airway_id
        self.airway_name = airway_name
        self.airway_type = airway_type
        self.from_waypoint_id = from_waypoint_id
        self.to_waypoint_id = to_waypoint_id
        self.minimum_altitude = minimum_altitude
        super.init(from_lonx: from_lonx, from_laty: from_laty, to_lonx: to_lonx, to_laty: to_laty)
    }
    
    
}
