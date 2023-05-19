//
//  RibbonFunctionTabView.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/25/22.
//

import SwiftUI
import MapboxMaps

struct RibbonFunctionTabView: View {
    @Binding var showSearchView: Bool
    @Binding var showFlightPlanView: Bool
    @ObservedObject var ribbonFunctionTabViewViewModel: RibbonFunctionTabViewViewModel
    @ObservedObject var ribbonViewTabViewModel: RibbonViewTabViewModel
    var body: some View {
        VStack {
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "map")
                        Text("Map Type:")
                        Picker(selection: $ribbonFunctionTabViewViewModel.mapStyleSelection) {
                            HStack {
                                Text("Topographic")
                            }
                            .tag(0)
                            
                            HStack {
                                Text("Street")
                            }
                            .tag(1)
                            
                            HStack {
                                Text("Satellite")
                            }
                            .tag(2)
                            
                            HStack {
                                Text("Satellite Streets")
                            }
                            .tag(3)
                        } label: {
                        }
                        .onChange(of: ribbonFunctionTabViewViewModel.mapStyleSelection) { newStyle in
                            ribbonFunctionTabViewViewModel.changeMapStyle(newStyle: newStyle)
                            FetchUserDefaults.shared.resetLayerDefault()
                            ribbonViewTabViewModel.setSwitch()
                            
                        }
                    }
                    
                }
            }
            Button {
                showSearchView.toggle()
            } label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                        .frame(width: 300)
                }
                .padding()
            }
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
            
            Button {
                showFlightPlanView.toggle()
            } label: {
                HStack {
                    Image(systemName: "location.north.line")
                    Text("Flight Plan")
                        .frame(width: 300)
                }
                .padding()
            }
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
            
        }
    }
}
