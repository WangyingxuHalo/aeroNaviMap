//
//  RibbonView.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/25/22.
//

import SwiftUI
import MapboxMaps

struct RibbonView: View {
    @Binding var mapView: MapView
    @Binding var showSearchView: Bool
    @Binding var showFlightPlanView: Bool
    @StateObject var ribbonViewViewModel: RibbonViewViewModel
    @StateObject var ribbonViewTabViewModel: RibbonViewTabViewModel
    @StateObject var ribbonFunctionTabViewViewModel: RibbonFunctionTabViewViewModel
    @Environment(\.colorScheme) var themeScheme
    @State var viewTabBackgroundColor = UIColor.theme.grayBackground
    var body: some View {
        HStack {
            RibbonFunctionTabView(showSearchView: $showSearchView, showFlightPlanView: $showFlightPlanView, ribbonFunctionTabViewViewModel: ribbonFunctionTabViewViewModel, ribbonViewTabViewModel: ribbonViewTabViewModel)
                .padding()
                .background(Rectangle()
                    .cornerRadius(5.0)
                    .onAppear {
                        viewTabBackgroundColor = themeScheme == .dark ? UIColor.theme.blackBackground : UIColor.theme.grayBackground
                    }
                    .foregroundColor(Color(uiColor: viewTabBackgroundColor))
                )
            Spacer()
            RibbonViewTabView(ribbonViewTabViewModel: ribbonViewTabViewModel)
                .padding()
                .background(Rectangle()
                    .cornerRadius(5.0)
                    .onAppear {
                        viewTabBackgroundColor = themeScheme == .dark ? UIColor.theme.blackBackground : UIColor.theme.grayBackground
                    }
                    .foregroundColor(Color(uiColor: viewTabBackgroundColor))
                )
        }.padding()
    }
}
