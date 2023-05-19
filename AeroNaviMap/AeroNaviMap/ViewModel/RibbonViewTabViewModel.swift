//
//  RibbonViewTabViewModel.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/25/22.
//

import MapboxMaps

class RibbonViewTabViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    @Published var mapView: MapView
    @Published var isShowLargeAirport: Bool
    @Published var isShowMediumAirport: Bool
    @Published var isShowOtherAirport: Bool
    @Published var isShowNAV: Bool
    @Published var isShowVOR: Bool
    @Published var isShowNDB: Bool
    @Published var isShowJetAirway: Bool
    @Published var isShowVectorAirway: Bool
    @Published var isShowRunway: Bool
    @Published var isShowILS: Bool

    init(mapView: MapView) {
        self.mapView = mapView
        if defaults.object(forKey: "isShowLargeAirport") != nil {
            isShowLargeAirport = defaults.bool(forKey: "isShowLargeAirport")
        } else {
            isShowLargeAirport = true
        }

        if defaults.object(forKey: "isShowMediumAirport") != nil {
            isShowMediumAirport = defaults.bool(forKey: "isShowMediumAirport")
        } else {
            isShowMediumAirport = true
        }

        if defaults.object(forKey: "isShowOtherAirport") != nil {
            isShowOtherAirport = defaults.bool(forKey: "isShowOtherAirport")
        } else {
            isShowOtherAirport = true
        }

        if defaults.object(forKey: "isShowNAV") != nil {
            isShowNAV = defaults.bool(forKey: "isShowNAV")
        } else {
            isShowNAV = true
        }

        if defaults.object(forKey: "isShowVOR") != nil {
            isShowVOR = defaults.bool(forKey: "isShowVOR")
        } else {
            isShowVOR = true
        }

        if defaults.object(forKey: "isShowNDB") != nil {
            isShowNDB = defaults.bool(forKey: "isShowNDB")
        } else {
            isShowNDB = true
        }

        if defaults.object(forKey: "isShowJetAirway") != nil {
            isShowJetAirway = defaults.bool(forKey: "isShowJetAirway")
        } else {
            isShowJetAirway = true
        }

        if defaults.object(forKey: "isShowVectorAirway") != nil {
            isShowVectorAirway = defaults.bool(forKey: "isShowVectorAirway")
        } else {
            isShowVectorAirway = true
        }

        if defaults.object(forKey: "isShowRunway") != nil {
            isShowRunway = defaults.bool(forKey: "isShowRunway")
        } else {
            isShowRunway = true
        }

        if defaults.object(forKey: "isShowILS") != nil {
            isShowILS = defaults.bool(forKey: "isShowILS")
        } else {
            isShowILS = true
        }
    }

    func setSwitch() {
        if defaults.object(forKey: "isShowLargeAirport") != nil {
            isShowLargeAirport = defaults.bool(forKey: "isShowLargeAirport")
        } else {
            isShowLargeAirport = true
        }

        if defaults.object(forKey: "isShowMediumAirport") != nil {
            isShowMediumAirport = defaults.bool(forKey: "isShowMediumAirport")
        } else {
            isShowMediumAirport = true
        }

        if defaults.object(forKey: "isShowOtherAirport") != nil {
            isShowOtherAirport = defaults.bool(forKey: "isShowOtherAirport")
        } else {
            isShowOtherAirport = true
        }

        if defaults.object(forKey: "isShowNAV") != nil {
            isShowNAV = defaults.bool(forKey: "isShowNAV")
        } else {
            isShowNAV = true
        }

        if defaults.object(forKey: "isShowVOR") != nil {
            isShowVOR = defaults.bool(forKey: "isShowVOR")
        } else {
            isShowVOR = true
        }

        if defaults.object(forKey: "isShowNDB") != nil {
            isShowNDB = defaults.bool(forKey: "isShowNDB")
        } else {
            isShowNDB = true
        }

        if defaults.object(forKey: "isShowJetAirway") != nil {
            isShowJetAirway = defaults.bool(forKey: "isShowJetAirway")
        } else {
            isShowJetAirway = true
        }

        if defaults.object(forKey: "isShowVectorAirway") != nil {
            isShowVectorAirway = defaults.bool(forKey: "isShowVectorAirway")
        } else {
            isShowVectorAirway = true
        }

        if defaults.object(forKey: "isShowRunway") != nil {
            isShowRunway = defaults.bool(forKey: "isShowRunway")
        } else {
            isShowRunway = true
        }

        if defaults.object(forKey: "isShowILS") != nil {
            isShowILS = defaults.bool(forKey: "isShowILS")
        } else {
            isShowILS = true
        }
    }

    func updateLargeAirportLayer(isShow: Bool) {
        let style = mapView.mapboxMap.style
        do {
            try style.updateLayer(withId: MapElementId.LARGE_AIRPORT_LAYER_ID, type: SymbolLayer.self) { layer in
                layer.visibility = .constant(isShow ? .visible : .none)
            }
        } catch {
            print("Failed to update the visibility for layer with id \(MapElementId.LARGE_AIRPORT_LAYER_ID). Error: \(error.localizedDescription)")
        }
    }

    func updateMdeiumAirportLayer(isShow: Bool) {
        let style = mapView.mapboxMap.style
        do {
            try style.updateLayer(withId: MapElementId.MEDIUM_AIRPORT_LAYER_ID, type: SymbolLayer.self) { layer in
                layer.visibility = .constant(isShow ? .visible : .none)
            }
        } catch {
            print("Failed to update the visibility for layer with id \(MapElementId.MEDIUM_AIRPORT_LAYER_ID). Error: \(error.localizedDescription)")
        }
    }

    func updateOtherAirportLayer(isShow: Bool) {
        let style = mapView.mapboxMap.style
        do {
            try style.updateLayer(withId: MapElementId.OTHER_AIRPORT_LAYER_ID, type: SymbolLayer.self) { layer in
                layer.visibility = .constant(isShow ? .visible : .none)
            }
        } catch {
            print("Failed to update the visibility for layer with id \(MapElementId.OTHER_AIRPORT_LAYER_ID). Error: \(error.localizedDescription)")
        }
    }

    func updateNAVLayer(isShow: Bool) {
        let style = mapView.mapboxMap.style
        do {
            try style.updateLayer(withId: MapElementId.NAV_LAYER_ID, type: SymbolLayer.self) { layer in
                layer.visibility = .constant(isShow ? .visible : .none)
            }
        } catch {
            print("Failed to update the visibility for layer with id \(MapElementId.NAV_LAYER_ID). Error: \(error.localizedDescription)")
        }
    }

    func updateVORLayer(isShow: Bool) {
        let style = mapView.mapboxMap.style
        do {
            try style.updateLayer(withId: MapElementId.VOR_LAYER_ID, type: SymbolLayer.self) { layer in
                layer.visibility = .constant(isShow ? .visible : .none)
            }
        } catch {
            print("Failed to update the visibility for layer with id \(MapElementId.VOR_LAYER_ID). Error: \(error.localizedDescription)")
        }
    }

    func updateNDBLayer(isShow: Bool) {
        let style = mapView.mapboxMap.style
        do {
            try style.updateLayer(withId: MapElementId.NDB_LAYER_ID, type: SymbolLayer.self) { layer in
                layer.visibility = .constant(isShow ? .visible : .none)
            }
        } catch {
            print("Failed to update the visibility for layer with id \(MapElementId.NDB_LAYER_ID). Error: \(error.localizedDescription)")
        }
    }

    func updateJetAirwayLayer(isShow: Bool) {
        let style = mapView.mapboxMap.style
        do {
            try style.updateLayer(withId: MapElementId.JET_AIRWAY_LAYER_ID, type: LineLayer.self) { layer in
                layer.visibility = .constant(isShow ? .visible : .none)
            }
            try style.updateLayer(withId: MapElementId.JET_AIRWAY_LABEL_LAYER_ID, type: SymbolLayer.self) { layer in
                layer.visibility = .constant(isShow ? .visible : .none)
            }
        } catch {
            print("Failed to update the visibility for layer with id \(MapElementId.JET_AIRWAY_LAYER_ID). Error: \(error.localizedDescription)")
        }
    }

    func updateVectorAirwayLayer(isShow: Bool) {
        let style = mapView.mapboxMap.style
        do {
            try style.updateLayer(withId: MapElementId.VECTOR_AIRWAY_LAYER_ID, type: LineLayer.self) { layer in
                layer.visibility = .constant(isShow ? .visible : .none)
            }
            try style.updateLayer(withId: MapElementId.VECTOR_AIRWAY_LABEL_LAYER_ID, type: SymbolLayer.self) { layer in
                layer.visibility = .constant(isShow ? .visible : .none)
            }
        } catch {
            print("Failed to update the visibility for layer with id \(MapElementId.VECTOR_AIRWAY_LAYER_ID). Error: \(error.localizedDescription)")
        }
    }

    func updateRunwayLayer(isShow: Bool) {
        let style = mapView.mapboxMap.style
        do {
            try style.updateLayer(withId: MapElementId.RUNWAY_LAYER_ID, type: LineLayer.self) { layer in
                layer.visibility = .constant(isShow ? .visible : .none)
            }
            try style.updateLayer(withId: MapElementId.RUNWAY_END_LAYER_ID, type: SymbolLayer.self) { layer in
                layer.visibility = .constant(isShow ? .visible : .none)
            }
        } catch {
            print("Failed to update the visibility for layer with id \(MapElementId.RUNWAY_LAYER_ID). Error: \(error.localizedDescription)")
        }
    }

    func updateILSLayer(isShow: Bool) {
        let style = mapView.mapboxMap.style
        do {
            try style.updateLayer(withId: MapElementId.ILS_LAYER_ID, type: FillLayer.self) { layer in
                layer.visibility = .constant(isShow ? .visible : .none)
            }
        } catch {
            print("Failed to update the visibility for layer with id \(MapElementId.ILS_LAYER_ID). Error: \(error.localizedDescription)")
        }
    }

}
