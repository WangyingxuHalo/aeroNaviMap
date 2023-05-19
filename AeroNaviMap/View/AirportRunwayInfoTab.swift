//
//  AirportRunwayInfoTab.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 10/25/22.
//

import SwiftUI
import MapboxMaps

struct AirportRunwayInfoTab: View {
    
    @ObservedObject var airportInfoPanelViewModel: AirportInfoPanelViewModel
    @Environment(\.colorScheme) var themeScheme
    @State var viewTabBackgroundColor = UIColor.theme.grayBackground
    let sec1Columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        ScrollView {
            if let runwayEnds = airportInfoPanelViewModel.runwayEnds {
                ForEach(runwayEnds, id: \.self) { runwayEnd in
                    VStack {
                        if let name = runwayEnd.name {
                            Text(name)
                                .bold()
                                .font(.title)
                        }
                        LazyVGrid(columns: sec1Columns) {
                            if let heading = runwayEnd.heading {
                                Text("Heading")
                                Text("\(heading)")
                            }
                            if let length = runwayEnd.length {
                                Text("Length")
                                Text("\(length)")
                            }
                            if let width = runwayEnd.width {
                                Text("Width")
                                Text("\(width)")
                            }
                            if let laty = runwayEnd.laty, let lonx = runwayEnd.lonx {
                                Text("Coordinates")
                                Text("\(laty), \(lonx)")
                            }
                            if let altitude = runwayEnd.altitude {
                                Text("Altitude")
                                Text("\(altitude)")
                            }
                            if let surface = runwayEnd.surface {
                                Text("Surface")
                                Text(surface)
                            }
                            if let ils_ident = runwayEnd.ils_ident {
                                Text("Ils Ident")
                                Text(ils_ident)
                            }
                        }
                        
                        LazyVGrid(columns: sec1Columns) {
                            if let is_takeoff = runwayEnd.is_takeoff {
                                Text("For Takeoff")
                                Text(is_takeoff == 1 ? "True":"False")
                            }
                            if let is_landing = runwayEnd.is_landing {
                                Text("For Landing")
                                Text(is_landing == 1 ? "True":"False")
                            }
                            if let left_vasi_type = runwayEnd.left_vasi_type {
                                Text("Left Vasi Type")
                                Text(left_vasi_type)
                            }
                            if let left_vasi_pitch = runwayEnd.left_vasi_pitch {
                                Text("Left Vasi Pitch")
                                Text("\(left_vasi_pitch)")
                            }
                            if let right_vasi_type = runwayEnd.right_vasi_type {
                                Text("Right Vasi Type")
                                Text(right_vasi_type)
                            }
                            if let right_vasi_pitch = runwayEnd.right_vasi_pitch {
                                Text("Right Vasi Pitch")
                                Text("\(right_vasi_pitch)")
                            }
                        }
                        LazyVGrid (columns: sec1Columns) {
                            if let is_pattern = runwayEnd.is_pattern {
                                Text("Pattern")
                                Text(is_pattern)
                            }
                            if let pattern_altitude = runwayEnd.pattern_altitude {
                                Text("Pattern Altitude")
                                Text("\(pattern_altitude)")
                            }
                            if let marking_flags = runwayEnd.marking_flags {
                                Text("Marking Flags")
                                Text("\(marking_flags)")
                            }
                            if let app_light_system_type = runwayEnd.app_light_system_type {
                                Text("App Light System Type")
                                Text(app_light_system_type)
                            }
                            if let num_strobes = runwayEnd.num_strobes {
                                Text("Strobes Count")
                                Text("\(num_strobes)")
                            }
                            if let blast_pad = runwayEnd.blast_pad {
                                Text("Blast Pad")
                                Text("\(blast_pad)")
                            }
                            if let offset_threshold = runwayEnd.offset_threshold {
                                Text("Offset Threshold")
                                Text("\(offset_threshold)")
                            }
                            if let overrun = runwayEnd.overrun {
                                Text("Overrun")
                                Text("\(overrun)")
                            }
                        }
                        LazyVGrid (columns: sec1Columns) {
                            if let center_light = runwayEnd.center_light {
                                Text("Center Light")
                                Text(center_light)
                            }
                            if let edge_light = runwayEnd.edge_light {
                                Text("Edge Light")
                                Text(edge_light)
                            }
                            if let end_type = runwayEnd.end_type {
                                Text("End Type")
                                Text(end_type)
                            }
                        }
                        if let name = runwayEnd.name ,let desc = airportInfoPanelViewModel.runwayDetailFacilities[name], desc != "" {
                            Text("Facilities")
                                .bold()
                            Text(desc)
                        }
                    }
                    .padding()
                    .background(Rectangle()
                        .cornerRadius(5.0)
                        .onAppear {
                            viewTabBackgroundColor = themeScheme == .dark ? UIColor.theme.blackBackground : UIColor.theme.grayBackground
                        }
                        .foregroundColor(Color(uiColor: viewTabBackgroundColor))
                    )
                    
                }
            }
            
        }
    }
}

