//
//  WaypointInfoPannel.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 11/14/22.
//

import SwiftUI

struct WaypointInfoPannel: View {
    @ObservedObject var waypointInfoPanelViewModel: WaypointInfoPanelViewModel
    let sec1Columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        ScrollView {
            VStack {
                if let name = waypointInfoPanelViewModel.waypoint.ident {
                    Text(name)
                        .bold()
                        .font(.title)
                }
                LazyVGrid(columns: sec1Columns) {
                    if let region = waypointInfoPanelViewModel.waypoint.region {
                        Text("Region")
                        Text(region);
                    }
                    if let type = waypointInfoPanelViewModel.waypoint.type{
                        Text("Type")
                        Text("\(type)");
                    }
                    if let laty = waypointInfoPanelViewModel.waypoint.laty,
                       let lonx = waypointInfoPanelViewModel.waypoint.lonx {
                        Text("Coordinate")
                        Text("\(laty), \(lonx)");
                    }
                    if let mag_var = waypointInfoPanelViewModel.waypoint.mag_var {
                        Text("Magnetic Declination")
                        Text("\(mag_var)");
                    }
                }
                
            }
        }
    }
}

