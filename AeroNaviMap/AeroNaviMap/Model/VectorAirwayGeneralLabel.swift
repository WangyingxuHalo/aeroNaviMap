//
//  VectorAirwayGeneralLabel.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 11/10/22.
//

import MapKit
class VectorAirwayGeneralLabel: NSObject, Identifiable, MKAnnotation {

    var title: String?
    var subtitle: String? = ""
    var ident: String?
    var lonx: Double?
    var laty: Double?
    var left_lonx: Double?
    var right_lonx: Double?
    var top_laty: Double?
    var bottom_laty: Double?

    init(ident: String?, lonx: Double?, laty: Double?, left_lonx: Double?, right_lonx: Double?, top_laty: Double?, bottom_laty: Double?) {
        self.title = ident
        self.ident = ident
        self.lonx = lonx
        self.laty = laty
        self.left_lonx = left_lonx
        self.right_lonx = right_lonx
        self.top_laty = top_laty
        self.bottom_laty = bottom_laty
    }

    @objc dynamic var coordinate: CLLocationCoordinate2D {
        if let left_lonx = left_lonx, let right_lonx = right_lonx, let top_laty = top_laty, let bottom_laty = bottom_laty {
            return CLLocationCoordinate2D(latitude: (top_laty + bottom_laty) / 2.0, longitude: (left_lonx + right_lonx) / 2.0 )
        }
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
}
