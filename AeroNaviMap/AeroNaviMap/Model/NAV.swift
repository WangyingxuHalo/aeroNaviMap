//
//  Nav.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/19/22.
//

import Foundation
import MapKit

class NAV: NSObject, Identifiable, MKAnnotation {

    var title: String?
    var subtitle: String? = ""
    var nav_search_id: Int?
    var ident: String?
    var lonx: Double?
    var laty: Double?
    var region: String?
    var mag_var: Double?

    init(nav_search_id: Int?, ident: String?, lonx: Double?, laty: Double?) {
        self.title = ident
        self.nav_search_id = nav_search_id
        self.ident = ident
        self.lonx = lonx
        self.laty = laty
    }
    
    init(nav_search_id: Int?, ident: String?, lonx: Double?, laty: Double?, region: String?, mag_var: Double?) {
        self.title = ident
        self.nav_search_id = nav_search_id
        self.ident = ident
        self.lonx = lonx
        self.laty = laty
        self.region = region
        self.mag_var = mag_var
    }

    @objc dynamic var coordinate: CLLocationCoordinate2D {
        if let latitude = laty, let longitude = lonx {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
}
