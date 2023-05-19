//
//  VorInfoPanel.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/4/22.
//

import SwiftUI

struct VorInfoPanel: View {
    @ObservedObject var vorInfoPanelViewModel: VorInfoPanelViewModel

    var body: some View {
            VorGeneralInfoTab(vorInfoPanelViewModel: vorInfoPanelViewModel)
    }
}
