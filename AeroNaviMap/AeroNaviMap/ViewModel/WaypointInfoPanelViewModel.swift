//
//  WaypointInfoPanelViewModel.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 11/14/22.
//

import Foundation
class WaypointInfoPanelViewModel: ObservableObject {
    @Published var waypoint: Waypoint

    init(waypoint: Waypoint) {
        self.waypoint = waypoint
    }

}
