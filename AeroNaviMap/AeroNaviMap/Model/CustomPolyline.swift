//
//  CustomPolyline.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/19/22.
//

import Foundation

class CustomPolyline {
    var from_lonx: Double?
    var from_laty: Double?
    var to_lonx: Double?
    var to_laty: Double?

    init(from_lonx: Double?, from_laty: Double?, to_lonx: Double?, to_laty: Double?) {
        self.from_laty = from_laty
        self.from_lonx = from_lonx
        self.to_lonx = to_lonx
        self.to_laty = to_laty
    }
}
