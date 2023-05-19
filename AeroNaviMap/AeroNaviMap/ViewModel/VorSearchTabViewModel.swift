//
//  VorSearchTabViewModel.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/9/22.
//
import Foundation

class VorSearchTabViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var icao: String = ""
    @Published var region: String = ""
    @Published var searchResults: [VOR] = []
    @Published var isSearchInvalid = true
    var timer: Timer?

    func searchVor() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false, block: { (_) in
            if self.name.count < 4, self.icao.count < 2, self.region.count < 2 {
                self.isSearchInvalid = true
                self.searchResults = []
            } else {
                DBReader.shared.asyncSearchVorForAnnotation(name: self.name, icao: self.icao, region: self.region) { mainList in
                    DispatchQueue.main.async {
                        self.isSearchInvalid = false
                        self.searchResults = mainList
                    }
                }
            }
        })
    }
}
