//
//  AeroNaviMapView.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 10/20/22.
//

import SwiftUI
import MapKit
import MapboxMaps

struct AeroNaviMapView: UIViewControllerRepresentable {
    @Binding var selectedPointAnnotation: MKAnnotation?
    @Binding var isFinishRender: Bool
    @Binding var mapView: MapView
    @Binding var wayPointsFeatureList: [Feature]
    @Binding var wayEdgeFeatureList: [Feature]

    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = MapAnnotationViewController(selectedPointAnnotation: $selectedPointAnnotation, isFinishRender: $isFinishRender, mapView: $mapView, wayPointsFeatureList: $wayPointsFeatureList, wayEdgeFeatureList: $wayEdgeFeatureList)
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
