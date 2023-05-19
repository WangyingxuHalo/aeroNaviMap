//
//  RibbonViewTabView.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/25/22.
//

import SwiftUI
import MapboxMaps

struct RibbonViewTabView: View {
    @ObservedObject var ribbonViewTabViewModel: RibbonViewTabViewModel
    var body: some View {
        HStack {
            VStack {
                Toggle(isOn: $ribbonViewTabViewModel.isShowLargeAirport) {
                    HStack {
                        Spacer()
                        Image("largeAirport")
                        Text("Large Airport")
                    }
                }
                        .toggleStyle(SwitchToggleStyle())
                        .onChange(of: ribbonViewTabViewModel.isShowLargeAirport) { isShow in
                            ribbonViewTabViewModel.defaults.set(isShow, forKey: "isShowLargeAirport")
                            ribbonViewTabViewModel.updateLargeAirportLayer(isShow: isShow)
                        }

                Toggle(isOn: $ribbonViewTabViewModel.isShowMediumAirport) {
                    HStack {
                        Spacer()
                        Image("mediumAirport")
                        Text("Medium Airport")
                    }
                }
                        .toggleStyle(SwitchToggleStyle())
                        .onChange(of: ribbonViewTabViewModel.isShowMediumAirport) { isShow in
                            ribbonViewTabViewModel.defaults.set(isShow, forKey: "isShowMediumAirport")
                            ribbonViewTabViewModel.updateMdeiumAirportLayer(isShow: isShow)
                        }

                Toggle(isOn: $ribbonViewTabViewModel.isShowOtherAirport) {
                    HStack {
                        Spacer()
                        Image("otherAirport")
                        Text("Other Airport")
                    }
                    
                }
                        .toggleStyle(SwitchToggleStyle())
                        .onChange(of: ribbonViewTabViewModel.isShowOtherAirport) { isShow in
                            ribbonViewTabViewModel.defaults.set(isShow, forKey: "isShowOtherAirport")
                            ribbonViewTabViewModel.updateOtherAirportLayer(isShow: isShow)
                        }
            }.frame(width: 230)

            VStack {
                Toggle(isOn: $ribbonViewTabViewModel.isShowNAV) {
                    HStack {
                        Spacer()
                        Image("nav")
                        Text("NAV")
                    }
                    
                }
                        .toggleStyle(SwitchToggleStyle())
                        .onChange(of: ribbonViewTabViewModel.isShowNAV) { isShow in
                            ribbonViewTabViewModel.defaults.set(isShow, forKey: "isShowNAV")
                            ribbonViewTabViewModel.updateNAVLayer(isShow: isShow)
                        }

                Toggle(isOn: $ribbonViewTabViewModel.isShowVOR) {
                    HStack {
                        Spacer()
                        Image("vor")
                        Text("VOR")
                    }
                    
                }
                        .toggleStyle(SwitchToggleStyle())
                        .onChange(of: ribbonViewTabViewModel.isShowVOR) { isShow in
                            ribbonViewTabViewModel.defaults.set(isShow, forKey: "isShowVOR")
                            ribbonViewTabViewModel.updateVORLayer(isShow: isShow)
                        }

                Toggle(isOn: $ribbonViewTabViewModel.isShowNDB) {
                    HStack {
                        Spacer()
                        Image("ndb")
                        Text("NDB")
                    }
                }
                        .toggleStyle(SwitchToggleStyle())
                        .onChange(of: ribbonViewTabViewModel.isShowNDB) { isShow in
                            ribbonViewTabViewModel.defaults.set(isShow, forKey: "isShowNDB")
                            ribbonViewTabViewModel.updateNDBLayer(isShow: isShow)
                        }
            }.frame(width: 150)
            VStack {
                Toggle(isOn: $ribbonViewTabViewModel.isShowJetAirway) {
                    HStack {
                        Spacer()
                        Image("jetAirway")
                        Text("Jet Airway")
                    }
                    
                }
                        .toggleStyle(SwitchToggleStyle())
                        .onChange(of: ribbonViewTabViewModel.isShowJetAirway) { isShow in
                            ribbonViewTabViewModel.defaults.set(isShow, forKey: "isShowJetAirway")
                            ribbonViewTabViewModel.updateJetAirwayLayer(isShow: isShow)
                        }

                Toggle(isOn: $ribbonViewTabViewModel.isShowVectorAirway) {
                    HStack {
                        Spacer()
                        Image("vectorAirway")
                        Text("Vector Airway")
                    }
                    
                }
                        .toggleStyle(SwitchToggleStyle())
                        .onChange(of: ribbonViewTabViewModel.isShowVectorAirway) { isShow in
                            ribbonViewTabViewModel.defaults.set(isShow, forKey: "isShowVectorAirway")
                            ribbonViewTabViewModel.updateVectorAirwayLayer(isShow: isShow)
                        }

                Toggle(isOn: $ribbonViewTabViewModel.isShowRunway) {
                    HStack {
                        Spacer()
                        Image("runway")
                        Text("Runway")
                    }
                    
                }
                        .toggleStyle(SwitchToggleStyle())
                        .onChange(of: ribbonViewTabViewModel.isShowRunway) { isShow in
                            ribbonViewTabViewModel.defaults.set(isShow, forKey: "isShowRunway")
                            ribbonViewTabViewModel.updateRunwayLayer(isShow: isShow)
                        }
                
                Toggle(isOn: $ribbonViewTabViewModel.isShowILS) {
                    HStack {
                        Spacer()
                        Image("ils")
                        Text("ILS")
                    }
                }
                        .toggleStyle(SwitchToggleStyle())
                        .onChange(of: ribbonViewTabViewModel.isShowILS) { isShow in
                            ribbonViewTabViewModel.defaults.set(isShow, forKey: "isShowILS")
                            ribbonViewTabViewModel.updateILSLayer(isShow: isShow)

                        }
            }.frame(width: 230)
        }
    }
}

