//
//  Waypoint.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/28/22.
//

import Foundation
import MapKit

class Waypoint: NSObject, Identifiable, MKAnnotation {

    var title: String?
    var subtitle: String? = ""
    var waypoint_id: Int?
    var ident: String?
    var lonx: Double?
    var laty: Double?
    var region:String?
    var type:String?
    var num_vector_airway:Int?
    var num_jet_airway: Int?
    var mag_var:Double?

    init(title: String? = nil, subtitle: String? = nil, waypoint_id: Int? = nil, ident: String? = nil, lonx: Double? = nil, laty: Double? = nil, region: String? = nil, type: String? = nil, num_vector_airway: Int? = nil, num_jet_airway: Int? = nil, mag_var: Double? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.waypoint_id = waypoint_id
        self.ident = ident
        self.lonx = lonx
        self.laty = laty
        self.region = region
        self.type = type
        self.num_vector_airway = num_vector_airway
        self.num_jet_airway = num_jet_airway
        self.mag_var = mag_var
    }

    @objc dynamic var coordinate: CLLocationCoordinate2D {
        if let latitude = laty, let longitude = lonx {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
}

struct FlightPlanWayPoint: Codable, Hashable {
    enum FlightPlanWayPointType:String, Codable {
        case airport = "airport"
        case waypoint = "waypoint"
        case airway = "airway"
        case direct = "direct"
    }
    var laty:Double
    var lonx:Double
    var ident:String
    var type: FlightPlanWayPointType
    var digitID: Int?
}
