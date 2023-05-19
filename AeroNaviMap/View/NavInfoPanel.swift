//
//  NavInfoPanel.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/2/22.
//

import SwiftUI

struct NavInfoPanel: View {
    @ObservedObject var navInfoPanelViewModel: NavInfoPanelViewModel

    var body: some View {
            NavGeneralInfoTab(navInfoPanelViewModel: navInfoPanelViewModel)
    }
}

