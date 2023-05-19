//
//  AirwaySearchTabViewModel.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/12/22.
//

import Foundation

class AirwaySearchTabViewModel: ObservableObject {
    @Published var airway_name: String = ""
    @Published var airway_type: String = ""
    @Published var region: String = ""
    @Published var searchResults: [Airway] = []
    @Published var isSearchInvalid = true
    var timer: Timer?

    func searchAirway() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false, block: { (_) in
            if self.airway_name.count < 2, self.airway_type.count < 1 {
                self.isSearchInvalid = true
                self.searchResults = []
            } else {
                DBReader.shared.asyncSearchAirway(airway_name: self.airway_name, airway_type: self.airway_type) { mainList in
                    DispatchQueue.main.async {
                        self.isSearchInvalid = false
                        self.searchResults = mainList
                    }
                }
            }
        })
    }
}
