//
//  NdbInfoPanelViewModel.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/4/22.
//

import Foundation

class NdbInfoPanelViewModel: ObservableObject {
    @Published var ndb: NDB

    init(ndb: NDB) {
        self.ndb = ndb
    }

}
