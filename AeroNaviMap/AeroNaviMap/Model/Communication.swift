//
//  Communication.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/19/22.
//

import Foundation

class Communication: Identifiable {
    var com_id: Int?
    var airport_id: Int?
    var type: String?
    var frequency: Int?
    var name: String?

    init(com_id: Int?, airport_id: Int?, type: String?, frequency: Int?, name: String?) {
        self.airport_id = airport_id
        self.com_id = com_id
        self.type = type
        self.frequency = frequency
        self.name = name
    }
}
