//
//  NavInfoPanelViewModel.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/2/22.
//

import Foundation

class NavInfoPanelViewModel: ObservableObject {
    @Published var nav: NAV

    init(nav: NAV) {
        self.nav = nav
    }

}
