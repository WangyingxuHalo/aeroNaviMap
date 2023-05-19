//
//  WaypointViewModel.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/28/22.
//

import MapKit
import MapboxMaps

class WaypointViewModel:ObservableObject {
    
    @Published var mapView:MapView
    
    @Published var waypointFeatureList: [Feature]
    @Published var wayedgeFeatureList: [Feature]
    
    @Published var textFieldStr:String = ""
    @Published var routesStr: [FlightPlanWayPoint] = []
    @Published var foundAirport: [Airport] = []
    @Published var foundWaypoint: [Waypoint] = []
    @Published var foundNextAirway: [Airway] = []
    @Published var foundNextWaypoint: [Waypoint] = []
    @Published var flightRoute: LineString?
    
    let localDataURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("flightPlanWaypoints")
    
    init(mapView:MapView, waypointFeatureList: [Feature], wayedgeFeatureList: [Feature]) {
        self.mapView = mapView
        self.waypointFeatureList = waypointFeatureList
        self.wayedgeFeatureList = wayedgeFeatureList
    }
    
    func addWaypoints() {
        guard let iconImg = UIImage(systemName: "circle.circle") else {return}
        DBReader.shared.asyncReadWaypointForAnnotation(waypointsStrList: routesStr) { mainList in
            DispatchQueue.main.async {
                var wayedges: [CLLocationCoordinate2D] = []
                for (idx,waypoint) in mainList.enumerated() {
                   self.addAnnotationMarker(id: idx, at: waypoint, constantsProperty: MapElementId.WAYPOINT_PROPERTY, constantSourceId: MapElementId.WAYPOINT_SOURCE_ID)
                    wayedges.append(CLLocationCoordinate2D(latitude: waypoint.laty, longitude: waypoint.lonx))
                }
                let pointAnnotationStyle = self.mapView.mapboxMap.style
                try? pointAnnotationStyle.addImage(iconImg, id: MapElementId.WAYPOINT_ID)
                self.flightRoute = LineString(wayedges)
                if let flightRoute = self.flightRoute {
                    self.addPolyMarker(geometry: Geometry(flightRoute), constantsProperty: MapElementId.WAYEDGE_PROPERTY, constantSourceId: MapElementId.WAYEDGE_SOURCE_ID, needAppend: true)
                }
            }
        }
    }
    
    func removeLastWaypoint() {
        if self.routesStr.count > 0 {
            self.routesStr.removeLast()
        }
    }
    
    func clearWaypoints() {
        self.waypointFeatureList = []
        self.wayedgeFeatureList = []
        if (try? self.mapView.mapboxMap.style.source(withId: MapElementId.WAYPOINT_SOURCE_ID)) != nil {
            try? self.mapView.mapboxMap.style.updateGeoJSONSource(withId: MapElementId.WAYPOINT_SOURCE_ID, geoJSON: .featureCollection(FeatureCollection(features: self.waypointFeatureList)))
        }
        self.addPolyMarker(geometry: Geometry(LineString([])), constantsProperty: MapElementId.WAYEDGE_PROPERTY, constantSourceId: MapElementId.WAYEDGE_SOURCE_ID, needAppend: false)
    }
    
    func searchRoute() {
        DBReader.shared.asyncSearchAirport(name: "", icao: textFieldStr, city: "", state: "", region: "") { mainList in
            DispatchQueue.main.async {
                self.foundAirport = mainList
            }
        }
        
        DBReader.shared.asyncSearchWaypoint(ident: textFieldStr) { mainList in
            DispatchQueue.main.async {
                self.foundWaypoint = mainList
            }
        }
    }
    
    func searchNext() {
        DBReader.shared.asyncSearchNextAirway(lastIdent: routesStr.last?.ident ?? "") { mainList in
            DispatchQueue.main.async {
                self.foundNextAirway = mainList
            }
        }
        
        if routesStr.count > 1 {
            DBReader.shared.asyncSearchNextWaypoint(lastAirwayName: routesStr.last?.ident ?? "", lastWaypointIdent: routesStr[routesStr.count - 2].ident) { mainList in
                DispatchQueue.main.async {
                    self.foundNextWaypoint = mainList
                }
            }
        }
        
    }
    
    
    private func addPolyMarker(geometry: Geometry, constantsProperty: String, constantSourceId: String, needAppend:Bool) {
        var feature = Feature(geometry: geometry)
        feature.identifier = .string("wayedge")
        feature.properties = [MapElementId.ICON_PROPERTY: .string(constantsProperty)]
        var testWayEdgeFeature:[Feature] = []
        if needAppend {
            testWayEdgeFeature.append(feature)
        }
        if (try? mapView.mapboxMap.style.source(withId: constantSourceId)) != nil {
            try? mapView.mapboxMap.style.updateGeoJSONSource(withId: constantSourceId, geoJSON: .featureCollection(FeatureCollection(features: testWayEdgeFeature)))
        }
    }
    
    private func addAnnotationMarker(id: Int, at flightPlanWayPoint: FlightPlanWayPoint, constantsProperty: String, constantSourceId: String){
        let point = Point(CLLocationCoordinate2D(latitude: flightPlanWayPoint.laty, longitude: flightPlanWayPoint.lonx))
        var feature = Feature(geometry: point)
        feature.identifier = .string("waypoint_\(flightPlanWayPoint.type)_\(flightPlanWayPoint.ident)")
        feature.properties = [MapElementId.ICON_ICAO: .string(flightPlanWayPoint.ident), MapElementId.ICON_PROPERTY: .string(constantsProperty)]
        self.waypointFeatureList.append(feature)
        if (try? self.mapView.mapboxMap.style.source(withId: constantSourceId)) != nil {
            try? self.mapView.mapboxMap.style.updateGeoJSONSource(withId: constantSourceId, geoJSON: .featureCollection(FeatureCollection(features: self.waypointFeatureList)))
        }
    }
    
    func writeRouteToDisk() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(routesStr) {
            try? encodedData.write(to: localDataURL)
        }
    }
    
    func readRouteFromDisk() {
        if let jsonData = try? Data(contentsOf: localDataURL){
            let decoder = JSONDecoder()
            let flightPlanWayPoint = try? decoder.decode([FlightPlanWayPoint].self, from: jsonData)
            self.routesStr = flightPlanWayPoint ?? [FlightPlanWayPoint]()
        }
    }
}
