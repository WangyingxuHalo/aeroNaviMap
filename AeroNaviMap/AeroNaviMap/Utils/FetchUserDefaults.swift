//
//  FetchUserDefaults.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/25/22.
//

import Foundation

class FetchUserDefaults {
    private init() {
    }

    static let shared = FetchUserDefaults()
    private let defaults = UserDefaults.standard

    func resetAll() {
        resetLayerDefault()
        resetMapStyleDefault()
    }

    func resetLayerDefault() {
        defaults.set(true, forKey: "isShowLargeAirport")
        defaults.set(true, forKey: "isShowMediumAirport")
        defaults.set(true, forKey: "isShowOtherAirport")
        defaults.set(true, forKey: "isShowNAV")
        defaults.set(true, forKey: "isShowVOR")
        defaults.set(true, forKey: "isShowNDB")
        defaults.set(true, forKey: "isShowJetAirway")
        defaults.set(true, forKey: "isShowVectorAirway")
        defaults.set(true, forKey: "isShowRunway")
        defaults.set(true, forKey: "isShowILS")
        defaults.set(0, forKey: "mapStyle")
    }

    func resetMapStyleDefault() {
        defaults.set(0, forKey: "mapStyle")
    }
}
