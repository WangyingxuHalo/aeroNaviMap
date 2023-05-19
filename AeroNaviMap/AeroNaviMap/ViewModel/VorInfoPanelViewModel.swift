//
//  VorInfoPanelViewModel.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/4/22.
//

import Foundation

class VorInfoPanelViewModel: ObservableObject {
    @Published var vor: VOR

    init(vor: VOR) {
        self.vor = vor
    }

}
