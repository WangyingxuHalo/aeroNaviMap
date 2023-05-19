//
//  ILSInfoPanelDetail.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/12/22.
//

import SwiftUI
import MapboxMaps

struct ILSInfoPanelDetail: View {
    @ObservedObject var ilsInfoPanelViewModel: ILSInfoPanelViewModel
    @Binding var mapView: MapView
    @Environment(\.colorScheme) var themeScheme
    let sec1Columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        ScrollView {
            VStack {
                if let name = ilsInfoPanelViewModel.ils.name {
                    Text(name)
                        .bold()
                        .font(.title)
                }
                LazyVGrid(columns: sec1Columns) {
                    if let ident = ilsInfoPanelViewModel.ils.ident {
                        Text("ID")
                        Text(ident);
                    }
                    if let frequency = ilsInfoPanelViewModel.ils.frequency {
                        Text("Frequency")
                        Text("\(frequency)");
                    }
                    if let range = ilsInfoPanelViewModel.ils.range {
                        Text("Range")
                        Text("\(range)");
                    }
                    if let mag_var = ilsInfoPanelViewModel.ils.mag_var {
                        Text("Magnetic Declination")
                        Text("\(mag_var)");
                    }
                    if let altitude = ilsInfoPanelViewModel.ils.altitude {
                        Text("Altitude")
                        Text("\(altitude)");
                    }
                    if let has_backcourse = ilsInfoPanelViewModel.ils.has_backcourse {
                        Text("Has Backcourse")
                        Text(has_backcourse == 1 ? "True" : "False");
                    }
                    
                }
                
            }
            
            VStack {
                        Text("DME Info")
                    .bold()
                        LazyVGrid(columns: sec1Columns) {
                            if let dme_range = ilsInfoPanelViewModel.ils.dme_range {
                                Text("DME Range")
                                Text("\(dme_range)");
                            }
                            if let dme_altitude = ilsInfoPanelViewModel.ils.dme_altitude {
                                Text("DME Altitude")
                                Text("\(dme_altitude)");
                            }
                            if let dme_lonx = ilsInfoPanelViewModel.ils.dme_lonx,
                               let dme_laty = ilsInfoPanelViewModel.ils.dme_laty{
                                Text("DME Coordinate")
                                Text("\(dme_laty), \(dme_lonx)");
                            }
                        }
                        
                    }
                VStack {
                        Text("GS Info")
                        .bold()
                        LazyVGrid(columns: sec1Columns) {
                            if let gs_range = ilsInfoPanelViewModel.ils.gs_range {
                                Text("GS Range")
                                Text("\(gs_range)");
                            }
                            if let gs_pitch = ilsInfoPanelViewModel.ils.gs_pitch {
                                Text("GS Pitch")
                                Text("\(gs_pitch)");
                            }
                            
                            if let gs_altitude = ilsInfoPanelViewModel.ils.gs_altitude {
                                Text("GS Altitude")
                                Text("\(gs_altitude)");
                            }
                        }
                    }
            VStack {
                Text("LOC Info")
                    .bold()
                LazyVGrid(columns: sec1Columns) {
                    if let loc_runway_name = ilsInfoPanelViewModel.ils.loc_runway_name {
                        Text("LOC Runway Name")
                        Text("\(loc_runway_name)");
                    }
                    if let loc_airport_ident = ilsInfoPanelViewModel.ils.loc_airport_ident {
                        Text("LOC Airport ID")
                        Text("\(loc_airport_ident)");
                    }
                    if let loc_heading = ilsInfoPanelViewModel.ils.loc_heading {
                        Text("LOC Heading")
                        Text("\(loc_heading)");
                    }
                    if let loc_width = ilsInfoPanelViewModel.ils.loc_width {
                        Text("LOC Width")
                        Text("\(loc_width)");
                    }
                }
            }


            
        }
        .padding()
        .onAppear {
            if let laty = ilsInfoPanelViewModel.ils.laty,
               let lonx = ilsInfoPanelViewModel.ils.lonx {
                mapView.mapboxMap.setCamera(to: CameraOptions(center: CLLocationCoordinate2D(latitude: laty, longitude: lonx), zoom: 10.0))
            }
        }
    }
}
