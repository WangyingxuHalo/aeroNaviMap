//
//  WaypointView.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/28/22.
//

import SwiftUI
import SwiftUIFlowLayout
import MapKit
import MapboxMaps

struct WaypointView: View {
    @Binding var mapView:MapView
    @StateObject var waypointViewModel: WaypointViewModel
    @FocusState private var focusedField: String?
    @Binding var selectedPointAnnotation: MKAnnotation?
    @Environment(\.colorScheme) private var themeScheme
    @State var showFlightPlanResultView: Bool = false
    var body: some View {
        VStack {
            HStack {
                Button {
                    showFlightPlanResultView.toggle()
                } label: {
                    Text("Done")
                }
                .padding(.trailing)
                .padding(.leading)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                .sheet(isPresented: $showFlightPlanResultView) {
                    FlightPlanResultView(flightPlanResultViewModel: FlightPlanResultViewModel(flightPlanWayPoints: waypointViewModel.routesStr, flightRoute:waypointViewModel.flightRoute))
                }
                
                Spacer()
                
                TextField(text: $waypointViewModel.textFieldStr, prompt: waypointViewModel.routesStr.isEmpty ? Text("Depart Airport ID").foregroundColor(Color.white) : Text("Any ID").foregroundColor(Color.white)) {
                    Text("")
                }
                .textInputAutocapitalization(.characters)
                .focused($focusedField, equals: "textField")
                .onChange(of: waypointViewModel.textFieldStr) { _ in
                    if waypointViewModel.textFieldStr.count > 1 {
                        waypointViewModel.searchRoute()
                    }
                }
                .autocorrectionDisabled()
                
                Spacer()
                
                Button {
                    waypointViewModel.removeLastWaypoint()
                } label: {
                    Text("Delete")
                }
                .padding(.trailing)
                .padding(.leading)
                .foregroundColor(Color.white)
                .background(Color.red)
                .cornerRadius(10)
            }
            
            ScrollView {
                Text("Route")
                    .bold()
                ScrollViewReader { scrollViewReader in
                    FlowLayout(mode: .scrollable,
                               items: waypointViewModel.routesStr,
                               itemSpacing: 4) { route in
                        Text(route.ident)
                            .padding(.top, 2)
                            .padding(.bottom, 2)
                            .padding(.leading)
                            .padding(.trailing)
                            .foregroundColor(.black)
                            .background(setRouteLabelColor(route: route))
                            .cornerRadius(5)
                            .onTapGesture {
                                showOnMap(route:route)
                            }
                    }
                               .onChange(of: waypointViewModel.routesStr.count) { _ in
                                   scrollViewReader.scrollTo(waypointViewModel.routesStr.count - 1)
                               }
                }
            }
            .background(themeScheme == .dark ? Color(uiColor: .darkGray) : Color(uiColor: UIColor.theme.grayBackground))
            
            Group {
                if !waypointViewModel.foundNextWaypoint.isEmpty {
                    VStack {
                        Text("Suggest Next Waypoint")
                            .bold()
                        List {
                            ForEach(waypointViewModel.foundNextWaypoint) { nextWaypoint in
                                if let nextWaypointCoor = nextWaypoint.coordinate,
                                   let nextWaypointIdent = nextWaypoint.ident {
                                    Button {
                                        waypointViewModel.routesStr.append(FlightPlanWayPoint(laty: nextWaypointCoor.latitude, lonx: nextWaypointCoor.longitude, ident: nextWaypointIdent, type: FlightPlanWayPoint.FlightPlanWayPointType.waypoint))
                                        mapView.mapboxMap.setCamera(to: CameraOptions(center: CLLocationCoordinate2D(latitude: nextWaypointCoor.latitude, longitude: nextWaypointCoor.longitude), zoom: mapView.mapboxMap.cameraState.zoom))
                                    } label: {
                                        Text("\(nextWaypointIdent): \(nextWaypointCoor.latitude), \(nextWaypointCoor.longitude)")
                                            .foregroundColor(Color(uiColor: .systemBlue))
                                    }
                                    .listRowBackground(themeScheme == .dark ? Color(uiColor: .darkGray) : Color(uiColor: UIColor.theme.grayBackground))
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                    .background(themeScheme == .dark ? Color(uiColor: .darkGray) : Color(uiColor: UIColor.theme.grayBackground))
                }
                
                if !waypointViewModel.foundNextAirway.isEmpty {
                    VStack {
                        Text("Suggest Next Airway")
                            .bold()
                        List {
                            ForEach(waypointViewModel.foundNextAirway) { nextAirway in
                                if let nextAirwayFromLonx = nextAirway.from_lonx,
                                   let nextAirwayFromLaty = nextAirway.from_laty,
                                   let nextAirwayName = nextAirway.airway_name,
                                   let nextAirwayDigitID = nextAirway.airway_id {
                                    Button {
                                        waypointViewModel.routesStr.append(FlightPlanWayPoint(laty: nextAirwayFromLaty, lonx: nextAirwayFromLonx, ident: nextAirwayName, type: FlightPlanWayPoint.FlightPlanWayPointType.airway, digitID: nextAirwayDigitID))
                                    } label: {
                                        Text(nextAirwayName)
                                            .foregroundColor(Color(uiColor: .systemBlue))
                                    }
                                    .listRowBackground(themeScheme == .dark ? Color(uiColor: .darkGray) : Color(uiColor: UIColor.theme.grayBackground))
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                    .background(themeScheme == .dark ? Color(uiColor: .darkGray) : Color(uiColor: UIColor.theme.grayBackground))
                }
                
                if waypointViewModel.textFieldStr.count > 1, waypointViewModel.foundAirport.isEmpty {
                    Text("No related airport")
                        .bold()
                } else if waypointViewModel.textFieldStr.count > 1, !waypointViewModel.foundAirport.isEmpty{
                    VStack {
                        Text("Found Airport")
                            .bold()
                        List {
                            ForEach(waypointViewModel.foundAirport) { airport in
                                Button {
                                    if let icao = airport.ident {
                                        mapView.mapboxMap.setCamera(to: CameraOptions(center: airport.coordinate, zoom: mapView.mapboxMap.cameraState.zoom))
                                        if waypointViewModel.routesStr.count > 0 {
                                            waypointViewModel.routesStr.append(FlightPlanWayPoint(laty: airport.coordinate.latitude, lonx: airport.coordinate.longitude, ident: "DIRECT", type: FlightPlanWayPoint.FlightPlanWayPointType.direct))
                                        }
                                        waypointViewModel.routesStr.append(FlightPlanWayPoint(laty: airport.coordinate.latitude, lonx: airport.coordinate.longitude, ident: icao, type: FlightPlanWayPoint.FlightPlanWayPointType.airport))
                                        focusedField = nil
                                    }
                                } label: {
                                    if  let icao = airport.ident,
                                        let airportName = airport.title {
                                        Text("\(icao): \(airportName)")
                                            .foregroundColor(Color(uiColor: .systemBlue))
                                    }
                                }
                                .listRowBackground(themeScheme == .dark ? Color(uiColor: .darkGray) : Color(uiColor: UIColor.theme.grayBackground))
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                    .background(themeScheme == .dark ? Color(uiColor: .darkGray) : Color(uiColor: UIColor.theme.grayBackground))
                }
                
                if waypointViewModel.textFieldStr.count > 1, waypointViewModel.foundWaypoint.isEmpty {
                    Text("No related waypoint")
                } else if waypointViewModel.textFieldStr.count > 1, !waypointViewModel.foundWaypoint.isEmpty {
                    VStack {
                        Text("Found Waypoint")
                            .bold()
                        List {
                            ForEach(waypointViewModel.foundWaypoint) { waypoint in
                                if let coordinate = waypoint.coordinate,
                                   let waypointIdent = waypoint.ident {
                                    Button {
                                        mapView.mapboxMap.setCamera(to: CameraOptions(center: waypoint.coordinate, zoom: mapView.mapboxMap.cameraState.zoom))
                                        waypointViewModel.routesStr.append(FlightPlanWayPoint(laty: coordinate.latitude, lonx: coordinate.longitude, ident: "DIRECT", type: FlightPlanWayPoint.FlightPlanWayPointType.direct))
                                        waypointViewModel.routesStr.append(FlightPlanWayPoint(laty: coordinate.latitude, lonx: coordinate.longitude, ident: waypointIdent, type: FlightPlanWayPoint.FlightPlanWayPointType.waypoint))
                                        focusedField = nil
                                    } label: {
                                        Text("\(waypointIdent): \(coordinate.latitude), \(coordinate.longitude)")
                                            .foregroundColor(Color(uiColor: .systemBlue))
                                    }
                                    .listRowBackground(themeScheme == .dark ? Color(uiColor: .darkGray) : Color(uiColor: UIColor.theme.grayBackground))
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                    .background(themeScheme == .dark ? Color(uiColor: .darkGray) : Color(uiColor: UIColor.theme.grayBackground))
                }
            }
        }
        .padding()
        .alignmentGuide(.top, computeValue: { d in d[.bottom] })
        .onAppear {
            waypointViewModel.readRouteFromDisk()
        }
        .onChange(of: waypointViewModel.routesStr.map {$0.ident}) { _ in
            waypointViewModel.textFieldStr = ""
            waypointViewModel.foundAirport = []
            waypointViewModel.foundWaypoint = []
            waypointViewModel.foundNextAirway = []
            waypointViewModel.foundNextWaypoint = []
            waypointViewModel.searchNext()
            waypointViewModel.clearWaypoints()
            waypointViewModel.addWaypoints()
            waypointViewModel.writeRouteToDisk()
        }
        .background(Color(uiColor: UIColor.lightGray))
    }
    
    func setRouteLabelColor(route: FlightPlanWayPoint) -> Color
    {
        switch route.type{
        case .airway:
            return .green
        case .waypoint:
            return .orange
        case .airport:
            return .blue
        case .direct:
            return .mint
        }
    }
    
    func showOnMap(route:FlightPlanWayPoint) {
        if route.type != FlightPlanWayPoint.FlightPlanWayPointType.direct {
            mapView.mapboxMap.setCamera(to: CameraOptions(center: CLLocationCoordinate2D(latitude: route.laty, longitude: route.lonx), zoom: 11.0))
        }
    }
}
