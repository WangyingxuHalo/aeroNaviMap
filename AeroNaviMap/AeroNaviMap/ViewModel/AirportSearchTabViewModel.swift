//
//  AirportSearchTabViewModel.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/25/22.
//

import Foundation

class AirportSearchTabViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var icao: String = ""
    @Published var city: String = ""
    @Published var state: String = ""
    @Published var region: String = ""
    @Published var searchResults: [Airport] = []
    @Published var isSearchInvalid = true
    var timer: Timer?

    func searchAirport() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false, block: { (_) in
            if self.name.count < 4, self.icao.count < 2, self.city.count < 3, self.state.count < 3, self.region.count < 2 {
                self.isSearchInvalid = true
                self.searchResults = []
            } else {
                DBReader.shared.asyncSearchAirport(name: self.name, icao: self.icao, city: self.city, state: self.state, region: self.region) { mainList in
                    DispatchQueue.main.async {
                        self.isSearchInvalid = false
                        self.searchResults = mainList
                    }
                }
            }
        })
    }
}
