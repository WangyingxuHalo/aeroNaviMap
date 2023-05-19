//
//  ContentView.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/18/22.
//

import SwiftUI
import MapboxMaps
import MapKit
import MapboxMaps

struct HomeView: View {
    @State var selectedPointAnnotation: MKAnnotation?
    @State var isFinishRender: Bool = false
    @State var mapView: MapView
    @StateObject var homeViewViewModel = HomeViewViewModel()
    @State var wayPointsFeatureList: [Feature] = []
    @State var wayEdgeFeatureList: [Feature] = []

    var body: some View {
        GeometryReader { geometryReader in
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            homeViewViewModel.showRibbonView.toggle()
                        } label: {
                            Text(homeViewViewModel.showRibbonView ? "-" : "+")
                                .font(.title)
                                .bold()
                        }
                        .padding()
                    }.frame(height: 8)
                    if homeViewViewModel.showRibbonView {
                        RibbonView(mapView: $mapView, showSearchView: $homeViewViewModel.showSearchView, showFlightPlanView: $homeViewViewModel.showFlightPlanView, ribbonViewViewModel: RibbonViewViewModel(), ribbonViewTabViewModel: RibbonViewTabViewModel(mapView: mapView), ribbonFunctionTabViewViewModel: RibbonFunctionTabViewViewModel(mapView: mapView, showSearchView: homeViewViewModel.showSearchView))
                                .frame(height: (geometryReader.size.height) / 5)
                    }
                    HStack {
                        if let selectedPointAnnotation = selectedPointAnnotation {
                            InfoPanelView(selectedPointAnnotation: selectedPointAnnotation, mapView: $mapView).frame(width: (geometryReader.size.width) / 3)
                        }
                        AeroNaviMapView(selectedPointAnnotation: $selectedPointAnnotation, isFinishRender: $isFinishRender, mapView: $mapView, wayPointsFeatureList: $wayPointsFeatureList, wayEdgeFeatureList: $wayEdgeFeatureList)
                            .ignoresSafeArea()
                        if homeViewViewModel.showSearchView {
                            SearchView(searchViewViewModel: SearchViewViewModel(), mapView: $mapView)
                                .frame(width: geometryReader.size.width / 3)
                        }
                        if homeViewViewModel.showFlightPlanView {
                            WaypointView(mapView: $mapView, waypointViewModel: WaypointViewModel(mapView: mapView, waypointFeatureList: wayPointsFeatureList, wayedgeFeatureList: wayEdgeFeatureList),
                                         selectedPointAnnotation: $selectedPointAnnotation)
                                .frame(width: geometryReader.size.width / 4)
                                .onAppear {
                                    homeViewViewModel.showRibbonView = false
                                }
                        }
                    }
                }
                if !isFinishRender {
                    HomeLoadingView()
                            .frame(width: geometryReader.size.width, height: geometryReader.size.height)
                            .background(Color(uiColor: UIColor.theme.darkBlue))
                }
            }
        }
    }
}
