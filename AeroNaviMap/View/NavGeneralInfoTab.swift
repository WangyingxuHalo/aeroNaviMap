//
//  NavGeneralInfoTab.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/4/22.
//

import SwiftUI

struct NavGeneralInfoTab: View {
    @ObservedObject var navInfoPanelViewModel: NavInfoPanelViewModel
    @Environment(\.colorScheme) var themeScheme
    let sec1Columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        ScrollView {
            if let ident = navInfoPanelViewModel.nav.ident {
                HStack {
                    Image("nav")
                    Text(ident)
                        .font(.title)
                }
            }
            VStack {
                LazyVGrid(columns: sec1Columns) {
                    
                    if let region = navInfoPanelViewModel.nav.region {
                        Text("Region")
                        Text(region);
                    }
                    if let mag_var = navInfoPanelViewModel.nav.mag_var {
                        Text("Magnetic Declination")
                        Text("\(mag_var)");
                    }
                    if let laty = navInfoPanelViewModel.nav.laty,
                       let lonx = navInfoPanelViewModel.nav.lonx {
                        Text("Coordinate")
                        Text("\(laty), \(lonx)");
                    }
                }
                
            }
        }
        .padding()
    }
}
