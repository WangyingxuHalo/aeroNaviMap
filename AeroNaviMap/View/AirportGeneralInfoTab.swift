//
//  AirportGeneralInfoTab.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 10/25/22.
//

import SwiftUI

struct AirportGeneralInfoTab: View {
    @ObservedObject var airportInfoPanelViewModel: AirportInfoPanelViewModel
    @Environment(\.colorScheme) var themeScheme
    @State var viewTabBackgroundColor = UIColor.theme.grayBackground
    let sec1Columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        ScrollView {
            if let title = airportInfoPanelViewModel.airport.title,
               let icao = airportInfoPanelViewModel.airport.ident {
                HStack {
                    if let iconName = airportInfoPanelViewModel.airport.imageName {
                        Image(iconName)
                    }
                    Spacer()
                    Text("\(title) (\(icao))").font(.title)
                    Spacer()
                }
                .padding()
                .background(Rectangle()
                    .cornerRadius(5.0)
                    .onAppear {
                        viewTabBackgroundColor = themeScheme == .dark ? UIColor.theme.blackBackground : UIColor.theme.grayBackground
                    }
                    .foregroundColor(Color(uiColor: viewTabBackgroundColor))
                )
                VStack {
                    LazyVGrid(columns: sec1Columns) {
                        if let region = airportInfoPanelViewModel.airport.region {
                            Text("Region")
                            Text(region)
                        }
                        if let city = airportInfoPanelViewModel.airport.city {
                            Text("City")
                            Text(city)
                        }
                        if let state = airportInfoPanelViewModel.airport.state {
                            Text("State/Province")
                            Text(state)
                        }
                        if let magneticDeclination = airportInfoPanelViewModel.airport.mag_var {
                            Text("Magnetic Declination")
                            Text("\(magneticDeclination)")
                        }
                        if let laty = airportInfoPanelViewModel.airport.laty, let lonx = airportInfoPanelViewModel.airport.lonx {
                            Text("Coordinate")
                            Text("\(laty), \(lonx)")
                        }
                        Spacer()
                    }
                    .border(themeScheme == .dark ? .white : .black)
                    .padding()
                    .background(Rectangle()
                        .cornerRadius(5.0)
                        .onAppear {
                            viewTabBackgroundColor = themeScheme == .dark ? UIColor.theme.blackBackground : UIColor.theme.grayBackground
                        }
                        .foregroundColor(Color(uiColor: viewTabBackgroundColor))
                    )
                    HStack {
                        Spacer()
                        VStack {
                            Text("Facilities").bold()
                            Text(airportInfoPanelViewModel.facilitiesInfo)
                            Spacer()
                            Text("Runways").bold()
                            Text(airportInfoPanelViewModel.runWayBasicInfo)
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Rectangle()
                        .cornerRadius(5.0)
                        .onAppear {
                            viewTabBackgroundColor = themeScheme == .dark ? UIColor.theme.blackBackground : UIColor.theme.grayBackground
                        }
                        .foregroundColor(Color(uiColor: viewTabBackgroundColor))
                    )
                    VStack {
                        Text("Longest Runway").bold()
                        LazyVGrid(columns: sec1Columns) {
                            if let longestRunwayLength = airportInfoPanelViewModel.airport.longest_runway_length {
                                Text("Length")
                                Text("\(longestRunwayLength) ft")
                            }
                            if let longestRunwayWidth = airportInfoPanelViewModel.airport.longest_runway_width {
                                Text("Width")
                                Text("\(longestRunwayWidth) ft")
                            }
                            if let longestRunwayHeading = airportInfoPanelViewModel.airport.longest_runway_heading {
                                Text("Heading")
                                Text("\(longestRunwayHeading)")
                            }
                            if let longestRunwaySurface = airportInfoPanelViewModel.airport.longest_runway_surface {
                                Text("Surface")
                                Text(longestRunwaySurface)
                            }
                        }
                        .border(themeScheme == .dark ? .white : .black)
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
                VStack {
                    Text("Parking").bold()
                    LazyVGrid(columns: sec1Columns) {
                        if let gatesNum = airportInfoPanelViewModel.airport.num_parking_gate {
                            Text("Gates")
                            Text("\(gatesNum)")
                        }
                        if let rampNum = airportInfoPanelViewModel.airport.num_parking_ga_ramp {
                            Text("Ramp")
                            Text("\(rampNum)")
                        }
                        if let largestGate = airportInfoPanelViewModel.airport.largest_parking_gate {
                            Text("Largest Gate")
                            Text("\(largestGate)")
                        }
                        if let largestRamp = airportInfoPanelViewModel.airport.largest_parking_ramp {
                            Text("Largest Ramp")
                            Text("\(largestRamp)")
                        }
                    }
                    .border(themeScheme == .dark ? .white : .black)
                }
                .padding()
                .background(Rectangle()
                    .cornerRadius(5.0)
                    .onAppear {
                        viewTabBackgroundColor = themeScheme == .dark ? UIColor.theme.blackBackground : UIColor.theme.grayBackground
                    }
                    .foregroundColor(Color(uiColor: viewTabBackgroundColor))
                )
                VStack{
                    if let towerFrequency = airportInfoPanelViewModel.airport.tower_frequency , towerFrequency > 0 {
                        Text("Communication Frequency").bold()
                    } else if let atisFrequency = airportInfoPanelViewModel.airport.atis_frequency ,  atisFrequency > 0 {
                        Text("Communication Frequency").bold()
                    } else if let awosFrequency = airportInfoPanelViewModel.airport.awos_frequency , awosFrequency > 0 {
                        Text("Communication Frequency").bold()
                    } else if let asosFrequency = airportInfoPanelViewModel.airport.asos_frequency , asosFrequency > 0 {
                        Text("Communication Frequency").bold()
                    } else if let unicomFrequency = airportInfoPanelViewModel.airport.unicom_frequency , unicomFrequency > 0 {
                        Text("Communication Frequency").bold()
                    }
                    LazyVGrid(columns: sec1Columns) {
                        if let towerFrequency = airportInfoPanelViewModel.airport.tower_frequency, towerFrequency > 0 {
                            Text("Tower")
                            Text("\(towerFrequency)")
                        }
                        if let atisFrequency = airportInfoPanelViewModel.airport.atis_frequency, atisFrequency > 0 {
                            Text("ATIS")
                            Text("\(atisFrequency)")
                        }
                        if let awosFrequency = airportInfoPanelViewModel.airport.awos_frequency, awosFrequency > 0 {
                            Text("AWOS")
                            Text("\(awosFrequency)")
                        }
                        if let asosFrequency = airportInfoPanelViewModel.airport.asos_frequency, asosFrequency > 0 {
                            Text("ASOS")
                            Text("\(asosFrequency)")
                        }
                        if let unicomFrequency = airportInfoPanelViewModel.airport.unicom_frequency, unicomFrequency > 0 {
                            Text("Uincom")
                            Text("\(unicomFrequency)")
                        }
                    }
                    .border(themeScheme == .dark ? .white : .black)
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
        .padding()
    }
}
