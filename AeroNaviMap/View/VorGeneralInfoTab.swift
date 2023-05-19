//
//  VorGeneralInfoTab.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/4/22.
//

import SwiftUI

struct VorGeneralInfoTab: View {
    @ObservedObject var vorInfoPanelViewModel: VorInfoPanelViewModel
    @Environment(\.colorScheme) var themeScheme
    let sec1Columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        ScrollView {
            if let ident = vorInfoPanelViewModel.vor.ident {
                HStack {
                    Image("vor")
                    Text(ident)
                        .font(.title)
                }
            }
            VStack {
                LazyVGrid(columns: sec1Columns) {
                    
                    if let name = vorInfoPanelViewModel.vor.name {
                        Text("Name")
                        Text(name);
                    }
                    if let region = vorInfoPanelViewModel.vor.region {
                        Text("Region")
                        Text(region);
                    }
                    if let frequency = vorInfoPanelViewModel.vor.frequency {
                        Text("Frequency")
                        Text("\(frequency)");
                    }
                    if let range = vorInfoPanelViewModel.vor.range {
                        Text("Range")
                        Text("\(range)");
                    }
                    if let laty = vorInfoPanelViewModel.vor.laty,
                       let lonx = vorInfoPanelViewModel.vor.lonx {
                        Text("Coordinate")
                        Text("\(laty), \(lonx)");
                    }
                    if let mag_var = vorInfoPanelViewModel.vor.mag_var {
                        Text("Magnetic Declination")
                        Text("\(mag_var)");
                    }
                    if let altitude = vorInfoPanelViewModel.vor.altitude {
                        Text("Altitude")
                        Text("\(altitude)");
                    }
                    if let laty = vorInfoPanelViewModel.vor.laty,
                       let lonx = vorInfoPanelViewModel.vor.lonx {
                        Text("Coordinate")
                        Text("\(laty), \(lonx)");
                    }
                }
                
            }
            VStack {
                Text("DME")
                if let dme_only = vorInfoPanelViewModel.vor.dme_only, dme_only == 1 {
                    Text("DME Only")
                }
                LazyVGrid(columns: sec1Columns) {
                    if let dme_altitude = vorInfoPanelViewModel.vor.dme_altitude {
                        Text("Altitude")
                        Text("\(dme_altitude)");
                    }
                    if let dme_laty = vorInfoPanelViewModel.vor.dme_laty,
                       let dme_lonx = vorInfoPanelViewModel.vor.dme_lonx {
                        Text("DME Coordinate")
                        Text("\(dme_laty), \(dme_lonx)");
                    }
                }
            }
            
        }
        .padding()
    }
}
