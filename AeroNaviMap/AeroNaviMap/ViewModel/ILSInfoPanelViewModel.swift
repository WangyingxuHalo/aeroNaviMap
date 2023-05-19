//
//  ILSInfoPanelViewModel.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/12/22.
//

import Foundation

class ILSInfoPanelViewModel: ObservableObject {
    @Published var ils: ILS

    init(ils: ILS) {
        self.ils = ils
    }

}
