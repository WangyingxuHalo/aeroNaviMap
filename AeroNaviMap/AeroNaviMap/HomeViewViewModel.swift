//
//  HomeViewViewModel.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/25/22.
//

import Foundation

class HomeViewViewModel: ObservableObject {
    @Published var showRibbonView = true
    @Published var showSearchView = false
    @Published var showFlightPlanView = false

    init() {
        FetchUserDefaults.shared.resetAll()
    }
}
