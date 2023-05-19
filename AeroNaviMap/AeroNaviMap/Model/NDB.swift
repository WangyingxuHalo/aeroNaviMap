//
//  NDB.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/19/22.
//

import Foundation
import MapKit

class NDB: NSObject, Identifiable, MKAnnotation {

    var title: String?
    var subtitle: String? = ""
    var ndb_id: Int?
    var ident: String?
    var lonx: Double?
    var laty: Double?
    
    var name: String?
    var region: String?
    var type: String?
    var frequency: Int?
    var range: Int?
    var mag_var: Double?

    init(ndb_id: Int?, ident: String?, lonx: Double?, laty: Double?) {
        self.title = ident
        self.ndb_id = ndb_id
        self.ident = ident
        self.lonx = lonx
        self.laty = laty
    }
    
    init(ndb_id: Int?, ident: String?, lonx: Double?, laty: Double?, name: String?, region: String?, type: String?, frequency: Int?, range: Int?, mag_var: Double?) {
        self.title = ident
        self.ndb_id = ndb_id
        self.ident = ident
        self.lonx = lonx
        self.laty = laty
        self.name = name
        self.region = region
        self.type = type
        self.frequency = frequency
        self.range = range
        self.mag_var = mag_var
    }

    @objc dynamic var coordinate: CLLocationCoordinate2D {
        if let latitude = laty, let longitude = lonx {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
}
