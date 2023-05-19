//
//  MapAnnotationViewController.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/20/22.
// Refer to Mapbox Maps SDK for iOS Doc https://docs.mapbox.com/ios/maps/guides/

import UIKit
import MapboxMaps
import CoreLocation
import MapKit
import SwiftUI

enum MapElementId {
    static let ICON_PROPERTY = "icon_property"
    static let ICON_TYPE = "icon_type"
    static let ICON_ICAO = "icon_icao"
    static let LARGE_AIRPORT_PROPERTY = "icon_large_airport_property"
    static let MEDIUM_AIRPORT_PROPERTY = "icon_medium_airport_property"
    static let OTHER_AIRPORT_PROPERTY = "icon_other_airport_property"
    static let NAV_PROPERTY = "nav_property"
    static let VOR_PROPERTY = "vor_property"
    static let NDB_PROPERTY = "ndb_property"
    static let JET_AIRWAY_PROPERTY = "jet_airway_property"
    static let VECTOR_AIRWAY_PROPERTY = "vector_airway_property"
    static let RUNWAY_PROPERTY = "runway_property"
    static let ILS_PROPERTY = "ils_property"
    static let WAYPOINT_PROPERTY = "waypoint_property"
    static let WAYEDGE_PROPERTY = "wayedge_property"
    static let HELIPAD_PROPERTY = "helipad_property"
    static let RUNWAY_END_PROPERTY = "runway_end_property"
    static let JET_AIRWAY_LABEL_PROPERTY = "jet_airway_label_property"
    static let VECTOR_AIRWAY_LABEL_PROPERTY = "vector_airway_label_property"
    static let LARGE_AIRPORT_ID = "large_airport"
    static let MEDIUM_AIRPORT_ID = "medium_airport"
    static let OTHER_AIRPORT_ID = "other_airport"
    static let NAV_ID = "nav_airport"
    static let VOR_ID = "vor_airport"
    static let NDB_ID = "ndb_airport"
    static let JET_AIRWAY_ID = "jet_airway"
    static let VECTOR_AIRWAY_ID = "vector_airway"
    static let RUNWAY_ID = "runway"
    static let ILS_ID = "ils"
    static let HELIPAD_ID = "helipad"
    static let WAYPOINT_ID = "waypoint"
    static let WAYEDGE_ID = "wayedge"
    static let RUNWAY_END_ID = "runway_end"
    static let JET_AIRWAY_LABEL_ID = "jet_airway_label"
    static let VECTOR_AIRWAY_LABEL_ID = "vector_airway_label"
    static let LARGE_AIRPORT_SOURCE_ID = "large_airport_source_id"
    static let MEDIUM_AIRPORT_SOURCE_ID = "medium_airport_source_id"
    static let OTHER_AIRPORT_SOURCE_ID = "other_airport_source_id"
    static let NAV_SOURCE_ID = "nav_source_id"
    static let VOR_SOURCE_ID = "vor_source_id"
    static let NDB_SOURCE_ID = "ndb_source_id"
    static let JET_AIRWAY_SOURCE_ID = "jet_airway_source_id"
    static let VECTOR_AIRWAY_SOURCE_ID = "vector_airway_source_id"
    static let RUNWAY_SOURCE_ID = "runway_source_id"
    static let ILS_SOURCE_ID = "ils_source_id"
    static let HELIPAD_SOURCE_ID = "helipad_source_id"
    static let WAYPOINT_SOURCE_ID = "waypoint_source_id"
    static let WAYEDGE_SOURCE_ID = "wayedge_source_id"
    static let RUNWAY_END_SOURCE_ID = "runway_end_source_id"
    static let JET_AIRWAY_LABEL_SOURCE_ID = "jet_airway_label_source_id"
    static let VECTOR_AIRWAY_LABEL_SOURCE_ID = "vector_airway_label_source_id"
    static let LARGE_AIRPORT_LAYER_ID = "large_airport_layer_id"
    static let MEDIUM_AIRPORT_LAYER_ID = "medium_airport_layer_id"
    static let OTHER_AIRPORT_LAYER_ID = "other_airport_layer_id"
    static let NAV_LAYER_ID = "nav_layer_id"
    static let VOR_LAYER_ID = "vor_layer_id"
    static let NDB_LAYER_ID = "ndb_layer_id"
    static let JET_AIRWAY_LAYER_ID = "jet_airway_layer_id"
    static let VECTOR_AIRWAY_LAYER_ID = "vector_airway_layer_id"
    static let RUNWAY_LAYER_ID = "runway_layer_id"
    static let HELIPAD_LAYER_ID = "helipad_layer_id"
    static let ILS_LAYER_ID = "ils_layer_id"
    static let WAYPOINT_LAYER_ID = "waypoint_layer_id"
    static let WAYEDGE_LAYER_ID = "wayedge_layer_id"
    static let RUNWAY_END_LAYER_ID = "runway_end_layer_id"
    static let JET_AIRWAY_LABEL_LAYER_ID = "jet_airway_label_layer_id"
    static let VECTOR_AIRWAY_LABEL_LAYER_ID = "vector_airway_label_layer_id"
    static let DME_SOURCE_ID = "DME_SOURCE"
    static let DME_SOURCE_URL = "mapbox://mapbox.mapbox-terrain-dem-v1"
    static let MARKER_ID_PREFIX = "mark_id_"
}

final class MapAnnotationViewController: UIViewController {

    @Binding private var mapView: MapView
    private var largeAirportPointList: [Feature] = []
    private var mediumAirportPointList: [Feature] = []
    private var otherAirportPointList: [Feature] = []
    private var navPointList: [Feature] = []
    private var vorPointList: [Feature] = []
    private var ndbPointList: [Feature] = []
    private var helipadPointList: [Feature] = []
    private var runwayEndPointList: [Feature] = []
    private var jetAirwayLabelPointList: [Feature] = []
    private var vectorAirwayLabelPointList: [Feature] = []

    private var jetAirwayPolylineList: [Feature] = []
    private var vectorAirwayLinesList: [Feature] = []
    private var runwayLinesList: [Feature] = []

    private var ilsPolygonList: [Feature] = []

    private var featureIdToMKAnnotation: [String: MKAnnotation] = [:]

    private var markerId = 0

    private let mediumAirportMinZoom = 4.5
    private let otherAirportMinZoom = 6.0
    private let navMinZoom = 7.0
    private let vorMinZoom = 7.0
    private let ndbMinZoom = 7.0
    private let jetAirwayMinZoom = 7.0
    private let vectorAirwayMinZoom = 7.0
    private let runwayMinZoom = 10.0
    private let ilsMinZoom = 7.0
    private let helipadMinZoom = 12.0

    @Binding var selectedPointAnnotation: MKAnnotation?
    @Binding var isFinishRender: Bool
    @Binding var wayPointsFeatureList: [Feature]
    @Binding var wayEdgeFeatureList: [Feature]

    init(selectedPointAnnotation: Binding<MKAnnotation?>, isFinishRender: Binding<Bool>, mapView: Binding<MapView>, wayPointsFeatureList: Binding<[Feature]>, wayEdgeFeatureList: Binding<[Feature]>) {
        _selectedPointAnnotation = selectedPointAnnotation
        _mapView = mapView
        _isFinishRender = isFinishRender
        _wayPointsFeatureList = wayPointsFeatureList
        _wayEdgeFeatureList = wayEdgeFeatureList
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addAllAnnotations(currAnnotations: [MKAnnotation]) {
        if currAnnotations is [LargeAirport] {
            for currAnnotation in currAnnotations {
                addPointMarker(at: currAnnotation, constantsProperty: MapElementId.LARGE_AIRPORT_PROPERTY, constantSourceId: MapElementId.LARGE_AIRPORT_SOURCE_ID, pointList: &largeAirportPointList)
            }
        } else if currAnnotations is [MediumAirport] {
            for currAnnotation in currAnnotations {
                addPointMarker(at: currAnnotation, constantsProperty: MapElementId.MEDIUM_AIRPORT_PROPERTY, constantSourceId: MapElementId.MEDIUM_AIRPORT_SOURCE_ID, pointList: &mediumAirportPointList)
            }
        } else if currAnnotations is [OtherAirport] {
            for currAnnotation in currAnnotations {
                addPointMarker(at: currAnnotation, constantsProperty: MapElementId.OTHER_AIRPORT_PROPERTY, constantSourceId: MapElementId.OTHER_AIRPORT_SOURCE_ID, pointList: &otherAirportPointList)
            }
        } else if currAnnotations is [NAV] {
            for currAnnotation in currAnnotations {
                addPointMarker(at: currAnnotation, constantsProperty: MapElementId.NAV_PROPERTY, constantSourceId: MapElementId.NAV_SOURCE_ID, pointList: &navPointList)
            }
        } else if currAnnotations is [VOR] {
            for currAnnotation in currAnnotations {
                addPointMarker(at: currAnnotation, constantsProperty: MapElementId.VOR_PROPERTY, constantSourceId: MapElementId.VOR_SOURCE_ID, pointList: &vorPointList)
            }
        } else if currAnnotations is [NDB] {
            for currAnnotation in currAnnotations {
                addPointMarker(at: currAnnotation, constantsProperty: MapElementId.NDB_PROPERTY, constantSourceId: MapElementId.NDB_SOURCE_ID, pointList: &ndbPointList)
            }
        } else if currAnnotations is [Helipad] {
            for currAnnotation in currAnnotations {
                addPointMarker(at: currAnnotation, constantsProperty: MapElementId.HELIPAD_PROPERTY, constantSourceId: MapElementId.HELIPAD_SOURCE_ID, pointList: &helipadPointList)
            }
        } else if currAnnotations is [RunwayEnd] {
            for currAnnotation in currAnnotations {
                addPointMarker(at: currAnnotation, constantsProperty: MapElementId.RUNWAY_END_PROPERTY, constantSourceId: MapElementId.RUNWAY_SOURCE_ID, pointList: &runwayEndPointList)
            }
        } else if currAnnotations is [JetAirwayGeneralLabel] {
            for currAnnotation in currAnnotations {
                addPointMarker(at: currAnnotation, constantsProperty: MapElementId.JET_AIRWAY_LABEL_PROPERTY, constantSourceId: MapElementId.JET_AIRWAY_LABEL_SOURCE_ID, pointList: &jetAirwayLabelPointList)
            }
        } else if currAnnotations is [VectorAirwayGeneralLabel] {
            for currAnnotation in currAnnotations {
                addPointMarker(at: currAnnotation, constantsProperty: MapElementId.VECTOR_AIRWAY_LABEL_PROPERTY, constantSourceId: MapElementId.VECTOR_AIRWAY_LABEL_SOURCE_ID, pointList: &vectorAirwayLabelPointList)
            }
        }
    }

    func addAllPolyline(currPolylines: [CustomPolyline]) {
        if currPolylines is [JetAirway] {
            for currPolyline in currPolylines {
                if let lineStrng = convertToLineFeature(polyline: currPolyline) {
                    addPolyMarker(geometry: lineStrng, constantsProperty: MapElementId.JET_AIRWAY_PROPERTY, constantSourceId: MapElementId.JET_AIRWAY_SOURCE_ID, featureList: &jetAirwayPolylineList)
                }
            }
        } else if currPolylines is [VectorAirway] {
            for currPolyline in currPolylines {
                if let lineStrng = convertToLineFeature(polyline: currPolyline) {
                    addPolyMarker(geometry: lineStrng, constantsProperty: MapElementId.VECTOR_AIRWAY_PROPERTY, constantSourceId: MapElementId.VECTOR_AIRWAY_SOURCE_ID, featureList: &vectorAirwayLinesList)
                }
            }
        } else if currPolylines is [Runway] {
            for currPolyline in currPolylines {
                if let lineStrng = convertToLineFeature(polyline: currPolyline) {
                    addPolyMarker(geometry: lineStrng, constantsProperty: MapElementId.RUNWAY_PROPERTY, constantSourceId: MapElementId.RUNWAY_SOURCE_ID, featureList: &runwayLinesList)
                }
            }
        }
    }

    func addAllPolygon(currPolygons: [CustomPolygon]) {
        if currPolygons is [ILS] {
            for currPolygon in currPolygons {
                if let coordinates = currPolygon.coordinates {
                    let polygon = Polygon([coordinates])
                    addPolyMarker(geometry: Geometry(polygon), constantsProperty: MapElementId.ILS_PROPERTY, constantSourceId: MapElementId.ILS_SOURCE_ID, featureList: &ilsPolygonList)
                }
            }
        }
    }

    func addPolyMarker(geometry: Geometry, constantsProperty: String, constantSourceId: String, featureList: inout [Feature]) {

        let currentId = "\(MapElementId.MARKER_ID_PREFIX)\(markerId)"
        markerId += 1
        var feature = Feature(geometry: geometry)
        feature.identifier = .string(currentId)
        feature.properties = [MapElementId.ICON_PROPERTY: .string(constantsProperty)]
        featureList.append(feature)
        if (try? mapView.mapboxMap.style.source(withId: constantSourceId)) != nil {
            try? mapView.mapboxMap.style.updateGeoJSONSource(withId: constantSourceId, geoJSON: .featureCollection(FeatureCollection(features: featureList)))
        }
    }

    private func convertToLineFeature(polyline: CustomPolyline) -> Geometry? {
        guard let from_laty = polyline.from_laty,
              let from_lonx = polyline.from_lonx,
              let to_laty = polyline.to_laty,
              let to_lonx = polyline.to_lonx
        else {
            return nil
        }
        let startCoord = CLLocationCoordinate2D(latitude: from_laty, longitude: from_lonx)
        let endCoord = CLLocationCoordinate2D(latitude: to_laty, longitude: to_lonx)
        return Geometry(LineString([startCoord, endCoord]))
    }

    private func loadAnnotation() {
        MapAnnotationViewGenerator.addAnnotationViews(aeroObjectClass: "nav", mapAnnotationViewController: self, northBound: nil, southBound: nil, westBound: nil, eastBound: nil)
        MapAnnotationViewGenerator.addAnnotationViews(aeroObjectClass: "vor", mapAnnotationViewController: self, northBound: nil, southBound: nil, westBound: nil, eastBound: nil)
        MapAnnotationViewGenerator.addAnnotationViews(aeroObjectClass: "ndb", mapAnnotationViewController: self, northBound: nil, southBound: nil, westBound: nil, eastBound: nil)
        MapAnnotationViewGenerator.addAnnotationViews(aeroObjectClass: "otherAirport", mapAnnotationViewController: self, northBound: nil, southBound: nil, westBound: nil, eastBound: nil)
        MapAnnotationViewGenerator.addAnnotationViews(aeroObjectClass: "mediumAirport", mapAnnotationViewController: self, northBound: nil, southBound: nil, westBound: nil, eastBound: nil)
        MapAnnotationViewGenerator.addAnnotationViews(aeroObjectClass: "largeAirport", mapAnnotationViewController: self, northBound: nil, southBound: nil, westBound: nil, eastBound: nil)
        MapAnnotationViewGenerator.addAnnotationViews(aeroObjectClass: "jetAirwayAnnotation", mapAnnotationViewController: self, northBound: nil, southBound: nil, westBound: nil, eastBound: nil)
        MapAnnotationViewGenerator.addAnnotationViews(aeroObjectClass: "vectorAirwayAnnotation", mapAnnotationViewController: self, northBound: nil, southBound: nil, westBound: nil, eastBound: nil)
        MapAnnotationViewGenerator.addAnnotationViews(aeroObjectClass: "runwayAnnotation", mapAnnotationViewController: self, northBound: nil, southBound: nil, westBound: nil, eastBound: nil)
        MapAnnotationViewGenerator.addAnnotationViews(aeroObjectClass: "ilsAnnotation", mapAnnotationViewController: self, northBound: nil, southBound: nil, westBound: nil, eastBound: nil)
        MapAnnotationViewGenerator.addAnnotationViews(aeroObjectClass: "helipad", mapAnnotationViewController: self, northBound: nil, southBound: nil, westBound: nil, eastBound: nil)
        MapAnnotationViewGenerator.addAnnotationViews(aeroObjectClass: "runwayEnd", mapAnnotationViewController: self, northBound: nil, southBound: nil, westBound: nil, eastBound: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mapDidClicked)))
        view.addSubview(mapView)

        loadAnnotation()

        mapView.mapboxMap.onEvery(event: .mapLoaded) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.createMapStyle()
            self.isFinishRender = true
        }

        mapView.mapboxMap.style.uri = .outdoors
    }

    @objc private func mapDidClicked(_ sender: UITapGestureRecognizer) {
        let clickPoint = sender.location(in: mapView)
        let renderedQueryOptions = RenderedQueryOptions(layerIds: [MapElementId.LARGE_AIRPORT_LAYER_ID, MapElementId.MEDIUM_AIRPORT_LAYER_ID, MapElementId.OTHER_AIRPORT_LAYER_ID, MapElementId.NAV_LAYER_ID, MapElementId.VOR_LAYER_ID, MapElementId.NDB_LAYER_ID, MapElementId.WAYPOINT_LAYER_ID, MapElementId.WAYEDGE_LAYER_ID], filter: nil)
        mapView.mapboxMap.queryRenderedFeatures(with: clickPoint, options: renderedQueryOptions) { [weak self] result in
            if case let .success(queriedResult) = result,
               let self = self,
               let feature = queriedResult.first?.feature,
               let featureId = feature.identifier,
               case let .string(featureIdString) = featureId {
                let annotationCord: CLLocationCoordinate2D
                if let geometry = feature.geometry,
                   case let Geometry.point(point) = geometry {
                    annotationCord = point.coordinates
                } else {
                    annotationCord = self.mapView.mapboxMap.coordinate(for: clickPoint)
                }
                self.addPointViewAnnotation(at: annotationCord, withMarkerId: featureIdString)
            } else {
                self?.selectedPointAnnotation = nil
            }
        }
    }


    private func createMapStyle() {
        let pointAnnotationStyle = mapView.mapboxMap.style

        if let largeAirportImg = UIImage(named: "largeAirport") {
            try? pointAnnotationStyle.addImage(largeAirportImg, id: MapElementId.LARGE_AIRPORT_ID)
        }
        if let mediumAirportImg = UIImage(named: "mediumAirport") {
            try? pointAnnotationStyle.addImage(mediumAirportImg, id: MapElementId.MEDIUM_AIRPORT_ID)
        }
        if let otherAirportImg = UIImage(named: "otherAirport") {
            try? pointAnnotationStyle.addImage(otherAirportImg, id: MapElementId.OTHER_AIRPORT_ID)
        }
        if let navImg = UIImage(named: "nav") {
            try? pointAnnotationStyle.addImage(navImg, id: MapElementId.NAV_ID)
        }
        if let vorImg = UIImage(named: "vor") {
            try? pointAnnotationStyle.addImage(vorImg, id: MapElementId.VOR_ID)
        }
        if let ndbImg = UIImage(named: "ndb") {
            try? pointAnnotationStyle.addImage(ndbImg, id: MapElementId.NDB_ID)
        }
        if let helipadImg = UIImage(named: "helipad") {
            try? pointAnnotationStyle.addImage(helipadImg, id: MapElementId.HELIPAD_ID)
        }

        setSource(sourceId: MapElementId.LARGE_AIRPORT_SOURCE_ID)
        setSource(sourceId: MapElementId.MEDIUM_AIRPORT_SOURCE_ID)
        setSource(sourceId: MapElementId.OTHER_AIRPORT_SOURCE_ID)
        setSource(sourceId: MapElementId.NAV_SOURCE_ID)
        setSource(sourceId: MapElementId.VOR_SOURCE_ID)
        setSource(sourceId: MapElementId.NDB_SOURCE_ID)
        setSource(sourceId: MapElementId.JET_AIRWAY_SOURCE_ID)
        setSource(sourceId: MapElementId.VECTOR_AIRWAY_SOURCE_ID)
        setSource(sourceId: MapElementId.RUNWAY_SOURCE_ID)
        setSource(sourceId: MapElementId.ILS_SOURCE_ID)
        setSource(sourceId: MapElementId.HELIPAD_SOURCE_ID)
        setSource(sourceId: MapElementId.WAYPOINT_SOURCE_ID)
        setSource(sourceId: MapElementId.WAYEDGE_SOURCE_ID)
        setSource(sourceId: MapElementId.RUNWAY_END_SOURCE_ID)
        setSource(sourceId: MapElementId.JET_AIRWAY_LABEL_SOURCE_ID)
        setSource(sourceId: MapElementId.VECTOR_AIRWAY_LABEL_SOURCE_ID)


        if pointAnnotationStyle.uri == .satelliteStreets {
            var demSource = RasterDemSource()
            demSource.url = MapElementId.DME_SOURCE_URL
            try? mapView.mapboxMap.style.addSource(demSource, id: MapElementId.DME_SOURCE_ID)
            let terrain = Terrain(sourceId: MapElementId.DME_SOURCE_ID)
            try? mapView.mapboxMap.style.setTerrain(terrain)
        }

        addPointAnnotationLayer(layerId: MapElementId.LARGE_AIRPORT_LAYER_ID, sourceId: MapElementId.LARGE_AIRPORT_SOURCE_ID)
        addPointAnnotationLayer(layerId: MapElementId.MEDIUM_AIRPORT_LAYER_ID, sourceId: MapElementId.MEDIUM_AIRPORT_SOURCE_ID)
        addPointAnnotationLayer(layerId: MapElementId.OTHER_AIRPORT_LAYER_ID, sourceId: MapElementId.OTHER_AIRPORT_SOURCE_ID)
        addPointAnnotationLayer(layerId: MapElementId.NAV_LAYER_ID, sourceId: MapElementId.NAV_SOURCE_ID)
        addPointAnnotationLayer(layerId: MapElementId.VOR_LAYER_ID, sourceId: MapElementId.VOR_SOURCE_ID)
        addPointAnnotationLayer(layerId: MapElementId.NDB_LAYER_ID, sourceId: MapElementId.NDB_SOURCE_ID)
        addPointAnnotationLayer(layerId: MapElementId.HELIPAD_LAYER_ID, sourceId: MapElementId.HELIPAD_SOURCE_ID)
        addPointAnnotationLayer(layerId: MapElementId.WAYPOINT_LAYER_ID, sourceId: MapElementId.WAYPOINT_SOURCE_ID)
        addPointAnnotationLayer(layerId: MapElementId.RUNWAY_END_LAYER_ID, sourceId: MapElementId.RUNWAY_END_SOURCE_ID)
        addPointAnnotationLayer(layerId: MapElementId.JET_AIRWAY_LABEL_LAYER_ID, sourceId: MapElementId.JET_AIRWAY_LABEL_SOURCE_ID)
        addPointAnnotationLayer(layerId: MapElementId.VECTOR_AIRWAY_LABEL_LAYER_ID, sourceId: MapElementId.VECTOR_AIRWAY_LABEL_SOURCE_ID)


        addPloylineLayer(layerId: MapElementId.JET_AIRWAY_LAYER_ID, sourceId: MapElementId.JET_AIRWAY_SOURCE_ID, color: .gray, width: 1.0, minZoom: jetAirwayMinZoom)
        addPloylineLayer(layerId: MapElementId.VECTOR_AIRWAY_LAYER_ID, sourceId: MapElementId.VECTOR_AIRWAY_SOURCE_ID, color: .brown, width: 1.0, minZoom: vectorAirwayMinZoom)
        addPloylineLayer(layerId: MapElementId.RUNWAY_LAYER_ID, sourceId: MapElementId.RUNWAY_SOURCE_ID, color: .red, width: 3.0, minZoom: runwayMinZoom)

        addPloygonLayer(layerId: MapElementId.ILS_LAYER_ID, sourceId: MapElementId.ILS_SOURCE_ID, styleColor: StyleColor(red: 13, green: 123, blue: 24, alpha: 1), minZoom: ilsMinZoom)
        
        addPloylineLayer(layerId: MapElementId.WAYEDGE_LAYER_ID, sourceId: MapElementId.WAYEDGE_SOURCE_ID, color: .blue, width: 5.0, minZoom: 0.0)
    }

    private func addPloylineLayer(layerId: String, sourceId: String, color: UIColor, width: Double, minZoom: Double) {
        var lineLayer = LineLayer(id: layerId)
        lineLayer.source = sourceId
        lineLayer.lineColor = .constant(StyleColor(color))
        lineLayer.lineWidth = .constant(width)
        lineLayer.lineCap = .constant(.round)
        lineLayer.minZoom = minZoom
        try? mapView.mapboxMap.style.addLayer(lineLayer)
    }


    private func addPloygonLayer(layerId: String, sourceId: String, styleColor: StyleColor?, minZoom: Double) {
        var polygonLayer = FillLayer(id: layerId)
        polygonLayer.source = sourceId
        if let styleColor = styleColor {
            polygonLayer.fillColor = .constant(styleColor)
        }
        polygonLayer.fillOpacity = .constant(0.3)
        try? mapView.mapboxMap.style.addLayer(polygonLayer)
        polygonLayer.minZoom = minZoom
    }


    private func setSource(sourceId: String) {
        var source = GeoJSONSource()
        if sourceId == MapElementId.LARGE_AIRPORT_SOURCE_ID {
            source.data = .featureCollection(FeatureCollection(features: largeAirportPointList))
        } else if sourceId == MapElementId.MEDIUM_AIRPORT_SOURCE_ID {
            source.data = .featureCollection(FeatureCollection(features: mediumAirportPointList))
        } else if sourceId == MapElementId.OTHER_AIRPORT_SOURCE_ID {
            source.data = .featureCollection(FeatureCollection(features: otherAirportPointList))
        } else if sourceId == MapElementId.NAV_SOURCE_ID {
            source.data = .featureCollection(FeatureCollection(features: navPointList))
        } else if sourceId == MapElementId.VOR_SOURCE_ID {
            source.data = .featureCollection(FeatureCollection(features: vorPointList))
        } else if sourceId == MapElementId.NDB_SOURCE_ID {
            source.data = .featureCollection(FeatureCollection(features: ndbPointList))
        } else if sourceId == MapElementId.JET_AIRWAY_SOURCE_ID {
            source.data = .featureCollection(FeatureCollection(features: jetAirwayPolylineList))
        } else if sourceId == MapElementId.VECTOR_AIRWAY_SOURCE_ID {
            source.data = .featureCollection(FeatureCollection(features: vectorAirwayLinesList))
        } else if sourceId == MapElementId.RUNWAY_SOURCE_ID {
            source.data = .featureCollection(FeatureCollection(features: runwayLinesList))
        } else if sourceId == MapElementId.ILS_SOURCE_ID {
            source.data = .featureCollection(FeatureCollection(features: ilsPolygonList))
        } else if sourceId == MapElementId.HELIPAD_SOURCE_ID {
            source.data = .featureCollection(FeatureCollection(features: helipadPointList))
        } else if sourceId == MapElementId.WAYPOINT_SOURCE_ID {
            source.data = .featureCollection(FeatureCollection(features: wayPointsFeatureList))
        } else if sourceId == MapElementId.WAYEDGE_SOURCE_ID {
            source.data = .featureCollection(FeatureCollection(features: wayEdgeFeatureList))
        } else if sourceId == MapElementId.RUNWAY_END_SOURCE_ID {
            source.data = .featureCollection(FeatureCollection(features: runwayEndPointList))
        } else if sourceId == MapElementId.JET_AIRWAY_LABEL_SOURCE_ID {
            source.data = .featureCollection(FeatureCollection(features: jetAirwayLabelPointList))
        } else if sourceId == MapElementId.VECTOR_AIRWAY_LABEL_SOURCE_ID {
            source.data = .featureCollection(FeatureCollection(features: vectorAirwayLabelPointList))
        }
        try? mapView.mapboxMap.style.addSource(source, id: sourceId)
    }

    private func addPointAnnotationLayer(layerId: String, sourceId: String) {
        let imageExpression = Exp(.switchCase) {
            Exp(.eq) {
                Exp(.get) {
                    MapElementId.ICON_PROPERTY
                }
                MapElementId.LARGE_AIRPORT_PROPERTY
            }
            MapElementId.LARGE_AIRPORT_ID


            Exp(.eq) {
                Exp(.get) {
                    MapElementId.ICON_PROPERTY
                }
                MapElementId.MEDIUM_AIRPORT_PROPERTY
            }
            MapElementId.MEDIUM_AIRPORT_ID


            Exp(.eq) {
                Exp(.get) {
                    MapElementId.ICON_PROPERTY
                }
                MapElementId.OTHER_AIRPORT_PROPERTY
            }
            MapElementId.OTHER_AIRPORT_ID

            Exp(.eq) {
                Exp(.get) {
                    MapElementId.ICON_PROPERTY
                }
                MapElementId.NAV_PROPERTY
            }
            MapElementId.NAV_ID

            Exp(.eq) {
                Exp(.get) {
                    MapElementId.ICON_PROPERTY
                }
                MapElementId.VOR_PROPERTY
            }
            MapElementId.VOR_ID

            Exp(.eq) {
                Exp(.get) {
                    MapElementId.ICON_PROPERTY
                }
                MapElementId.NDB_PROPERTY
            }
            MapElementId.NDB_ID

            Exp(.eq) {
                Exp(.get) {
                    MapElementId.ICON_PROPERTY
                }
                MapElementId.HELIPAD_PROPERTY
            }
            MapElementId.HELIPAD_ID
            
            Exp(.eq) {
                Exp(.get) {
                    MapElementId.ICON_PROPERTY
                }
                MapElementId.WAYPOINT_PROPERTY
            }
            MapElementId.WAYPOINT_ID
            
            Exp(.eq) {
                Exp(.get) {
                    MapElementId.ICON_PROPERTY
                }
                MapElementId.RUNWAY_END_PROPERTY
            }
            MapElementId.RUNWAY_END_ID
            
            Exp(.eq) {
                Exp(.get) {
                    MapElementId.ICON_PROPERTY
                }
                MapElementId.JET_AIRWAY_LABEL_PROPERTY
            }
            MapElementId.JET_AIRWAY_LABEL_ID
            ""
        }
        
        var layer = SymbolLayer(id: layerId)
        layer.source = sourceId
        layer.iconImage = .expression(imageExpression)
        layer.textField = .expression(Exp(.get) { MapElementId.ICON_ICAO })
        layer.textSize = .constant(14)
        layer.textFont = .constant(["Arial Unicode MS Bold"])
        layer.textAllowOverlap = .constant(false)
        layer.textOffset = .expression(Exp(.match) {
            Exp(.get) { MapElementId.ICON_TYPE }
            "runwayEnd"
            [0.0,0.0]
            "jetAirwayLabel"
            [0.0,0.0]
            "vectorAirwayLabel"
            [0.0,0.0]
            [2,0]
        })
        layer.textOffset = .constant([2,0])
        layer.iconAnchor = .constant(.center)
        layer.iconAllowOverlap = .constant(true)
        layer.textColor = .expression(Exp(.match) {
            Exp(.get) { MapElementId.ICON_TYPE }
            "airport"
            UIColor.red
            "nav"
            UIColor.purple
            "vor"
            UIColor.blue
            "ndb"
            UIColor.orange
            "helipad"
            UIColor.gray
            "runwayEnd"
            UIColor.theme.darkGreen
            "jetAirwayLabel"
            UIColor.brown
            "vectorAirwayLabel"
            UIColor.brown
            UIColor.black
        })
        switch layerId {
        case MapElementId.MEDIUM_AIRPORT_LAYER_ID:
            layer.minZoom = mediumAirportMinZoom
        case MapElementId.OTHER_AIRPORT_LAYER_ID:
            layer.minZoom = otherAirportMinZoom
        case MapElementId.NAV_LAYER_ID:
            layer.minZoom = navMinZoom
        case MapElementId.VOR_LAYER_ID:
            layer.minZoom = vorMinZoom
        case MapElementId.NDB_LAYER_ID:
            layer.minZoom = ndbMinZoom
        case MapElementId.HELIPAD_LAYER_ID:
            layer.minZoom = helipadMinZoom
        case MapElementId.RUNWAY_END_LAYER_ID:
            layer.minZoom = runwayMinZoom
        case MapElementId.JET_AIRWAY_LABEL_LAYER_ID:
            layer.minZoom = jetAirwayMinZoom
        case MapElementId.VECTOR_AIRWAY_LABEL_LAYER_ID:
            layer.minZoom = vectorAirwayMinZoom
        default:
            break
        }
        try? mapView.mapboxMap.style.addLayer(layer)
    }

    private func addPointMarker(at mkAnnotation: MKAnnotation, constantsProperty: String, constantSourceId: String, pointList: inout [Feature]) {
        let point = Point(mkAnnotation.coordinate)
        let currentMarkerId = "\(MapElementId.MARKER_ID_PREFIX)\(markerId)"
        markerId += 1
        var feature = Feature(geometry: point)
        feature.identifier = .string(currentMarkerId)
        if let airport = mkAnnotation as? Airport {
            feature.properties = [MapElementId.ICON_PROPERTY: .string(constantsProperty), MapElementId.ICON_TYPE: .string("airport"), MapElementId.ICON_ICAO: .string(airport.subtitle ?? "n/a")]
        } else if let nav = mkAnnotation as? NAV {
            feature.properties = [MapElementId.ICON_PROPERTY: .string(constantsProperty), MapElementId.ICON_TYPE: .string("nav"), MapElementId.ICON_ICAO: .string(nav.ident ?? "n/a")]
        } else if let vor = mkAnnotation as? VOR {
            feature.properties = [MapElementId.ICON_PROPERTY: .string(constantsProperty), MapElementId.ICON_TYPE: .string("vor"), MapElementId.ICON_ICAO: .string(vor.ident ?? "n/a")]
        } else if let ndb = mkAnnotation as? NDB {
            feature.properties = [MapElementId.ICON_PROPERTY: .string(constantsProperty), MapElementId.ICON_TYPE: .string("ndb"), MapElementId.ICON_ICAO: .string(ndb.ident ?? "n/a")]
        } else if let helipad = mkAnnotation as? Helipad {
            feature.properties = [MapElementId.ICON_PROPERTY: .string(constantsProperty), MapElementId.ICON_TYPE: .string("helipad"), MapElementId.ICON_ICAO: .string(helipad.title ?? "n/a")]
        } else if let runwayEnd = mkAnnotation as? RunwayEnd {
            feature.properties = [MapElementId.ICON_PROPERTY: .string(constantsProperty), MapElementId.ICON_TYPE: .string("runwayEnd"), MapElementId.ICON_ICAO: .string(runwayEnd.name ?? "n/a")]
        } else if let jetAirwayLabel = mkAnnotation as? JetAirwayGeneralLabel {
            feature.properties = [MapElementId.ICON_PROPERTY: .string(constantsProperty), MapElementId.ICON_TYPE: .string("jetAirwayLabel"), MapElementId.ICON_ICAO: .string(jetAirwayLabel.ident ?? "n/a")]
        }else if let vectorAirwayLabel = mkAnnotation as? VectorAirwayGeneralLabel {
            feature.properties = [MapElementId.ICON_PROPERTY: .string(constantsProperty), MapElementId.ICON_TYPE: .string("vectorAirwayLabel"), MapElementId.ICON_ICAO: .string(vectorAirwayLabel.ident ?? "n/a")]
        } else {
            feature.properties = [MapElementId.ICON_PROPERTY: .string(constantsProperty), MapElementId.ICON_TYPE: .string("n/a"), MapElementId.ICON_ICAO: .string("n/a")]
        }
        pointList.append(feature)
        if (try? mapView.mapboxMap.style.source(withId: constantSourceId)) != nil {
            try? mapView.mapboxMap.style.updateGeoJSONSource(withId: constantSourceId, geoJSON: .featureCollection(FeatureCollection(features: pointList)))
        }
        featureIdToMKAnnotation[currentMarkerId] = mkAnnotation
    }

    private func addPointViewAnnotation(at coordinate: CLLocationCoordinate2D, withMarkerId markerId: String? = nil) {
        if let markerId = markerId {
            if let annotation = featureIdToMKAnnotation[markerId] as? LargeAirport {
                if let subtitle = annotation.subtitle {
                    DBReader.shared.asyncReadLargeAirportForInfo(icaoCode: subtitle) { largeAirports in
                        DispatchQueue.main.async {
                            if largeAirports.count > 0 {
                                let largeAirport = largeAirports[0]
                                self.selectedPointAnnotation = largeAirport
                            }
                        }
                    }
                }
            } else if let annotation = featureIdToMKAnnotation[markerId] as? MediumAirport {
                if let subtitle = annotation.subtitle {
                    DBReader.shared.asyncReadMediumAirportForInfo(icaoCode: subtitle) { mediumAirport in
                        DispatchQueue.main.async {
                            if mediumAirport.count > 0 {
                                let mediumAirport = mediumAirport[0]
                                self.selectedPointAnnotation = mediumAirport
                            }
                        }
                    }
                }
            } else if let annotation = featureIdToMKAnnotation[markerId] as? OtherAirport {
                if let subtitle = annotation.subtitle {
                    DBReader.shared.asyncReadOtherAirportForInfo(icaoCode: subtitle) { otherAirport in
                        DispatchQueue.main.async {
                            if otherAirport.count > 0 {
                                let otherAirport = otherAirport[0]
                                self.selectedPointAnnotation = otherAirport
                            }
                        }
                    }
                }
            } else if let annotation = featureIdToMKAnnotation[markerId] as? NAV {
                if let title = annotation.ident {
                    DBReader.shared.asyncReadNavForAnnotation(icaoCode: title) { navs in
                        DispatchQueue.main.async {
                            if navs.count > 0 {
                                let nav = navs[0]
                                self.selectedPointAnnotation = nav
                            }
                        }
                    }
                }
            } else if let annotation = featureIdToMKAnnotation[markerId] as? VOR {
                if let title = annotation.ident {
                    DBReader.shared.asyncReadVorForAnnotation(icaoCode: title) { vors in
                        DispatchQueue.main.async {
                            if vors.count > 0 {
                                let vor = vors[0]
                                self.selectedPointAnnotation = vor
                            }
                        }
                    }
                }
            } else if let annotation = featureIdToMKAnnotation[markerId] as? NDB {
                if let title = annotation.ident {
                    DBReader.shared.asyncReadNdbForAnnotation(icaoCode: title) { ndbs in
                        DispatchQueue.main.async {
                            if ndbs.count > 0 {
                                let ndb = ndbs[0]
                                self.selectedPointAnnotation = ndb
                            }
                        }
                    }
                }
            }
            else {
                let markerIdSubStrArr = markerId.components(separatedBy: "_")
                if markerIdSubStrArr.count == 3 {
                    if markerIdSubStrArr[1] == "airport" {
                        DBReader.shared.asyncSearchAirport(name: "", icao: markerIdSubStrArr[2], city: "", state: "", region: "", completionHandler: { mainList in
                            DispatchQueue.main.async {
                                if mainList.count > 0 {
                                    self.selectedPointAnnotation = mainList[0]
                                }
                            }
                        })
                    } else if markerIdSubStrArr[1] == "waypoint" {
                        DBReader.shared.asyncSearchNdbForAnnotation(name: "", icao: markerIdSubStrArr[2], region: "") { mainList in
                            DispatchQueue.main.async {
                                if mainList.count > 0 {
                                    self.selectedPointAnnotation = mainList[0]
                                } else {
                                    DBReader.shared.asyncSearchVorForAnnotation(name: "", icao: markerIdSubStrArr[2], region: "") { mainList in
                                        DispatchQueue.main.async {
                                            if mainList.count > 0 {
                                                self.selectedPointAnnotation = mainList[0]
                                            } else {
                                                DBReader.shared.asyncSearchNavForAnnotation(icao: markerIdSubStrArr[2], region: "") { mainList in
                                                    DispatchQueue.main.async {
                                                        if mainList.count > 0 {
                                                            self.selectedPointAnnotation = mainList[0]
                                                        } else {
                                                            DBReader.shared.asyncSearchWaypoint(ident: markerIdSubStrArr[2]){ mainList in
                                                                DispatchQueue.main.async {
                                                                    if mainList.count > 0 {
                                                                        self.selectedPointAnnotation = mainList[0]
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
}
