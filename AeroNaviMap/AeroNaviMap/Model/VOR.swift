//
//  VOR.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/19/22.
//

import Foundation
import MapKit

class VOR: NSObject, Identifiable, MKAnnotation {

    var title: String?
    var subtitle: String? = ""
    var vor_id: Int?
    var ident: String?
    var lonx: Double?
    var laty: Double?
    
    var name: String?
    var region: String?
    var frequency: Int?
    var range: Int?
    var mag_var: Double?
    var dme_only: Int?
    var dme_altitude: Int?
    var dme_lonx: Double?
    var dme_laty: Double?
    var altitude: Int?
    
    init(vor_id: Int?, ident: String?, lonx: Double?, laty: Double?) {
        self.title = ident
        self.vor_id = vor_id
        self.ident = ident
        self.lonx = lonx
        self.laty = laty
    }

    init(vor_id: Int?, ident: String?, lonx: Double?, laty: Double?, name: String?, region: String?, frequency: Int?, range: Int?, mag_var: Double?, dme_only: Int?, dme_altitude: Int?, dme_lonx: Double?, dme_laty: Double?, altitude: Int?) {
        self.title = ident
        self.vor_id = vor_id
        self.ident = ident
        self.lonx = lonx
        self.laty = laty
        self.name = name
        self.region = region
        self.frequency = frequency
        self.range = range
        self.mag_var = mag_var
        self.dme_only = dme_only
        self.dme_altitude = dme_altitude
        self.dme_lonx = dme_lonx
        self.dme_laty = dme_laty
        self.altitude = altitude
    }

    @objc dynamic var coordinate: CLLocationCoordinate2D {
        if let latitude = laty, let longitude = lonx {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
}
