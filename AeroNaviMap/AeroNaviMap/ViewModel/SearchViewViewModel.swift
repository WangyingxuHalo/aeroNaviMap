//
//  SearchViewViewModel.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/25/22.
//

import Foundation

class SearchViewViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    @Published var selectedTab: Int

    init() {
        if defaults.object(forKey: "selectedSearchTab") != nil {
            selectedTab = defaults.integer(forKey: "selectedSearchTab")
        } else {
            selectedTab = 0
        }
    }

    func writePerferenceIntoDisk() {
        defaults.set(selectedTab, forKey: "selectedSearchTab")
    }
}
