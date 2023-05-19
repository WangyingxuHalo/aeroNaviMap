//
//  NdbInfoPanel.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/4/22.
//

import SwiftUI

struct NdbInfoPanel: View {
    @ObservedObject var ndbInfoPanelViewModel: NdbInfoPanelViewModel

    var body: some View {
            NdbGeneralInfoTab(ndbInfoPanelViewModel: ndbInfoPanelViewModel)
    }
}
