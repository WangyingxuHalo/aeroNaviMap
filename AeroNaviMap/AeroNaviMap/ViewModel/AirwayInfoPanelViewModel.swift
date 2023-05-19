//
//  AirwayInfoPanelViewModel.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/12/22.
//

import Foundation

class AirwayInfoPanelViewModel: ObservableObject {
    @Published var airway: Airway

    init(airway: Airway) {
        self.airway = airway
    }

}
