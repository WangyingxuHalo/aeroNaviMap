//
//  MapboxTestViewController.swift
//  aeronavimap
//
//  Created by Yuankai Zhu on 10/18/22.
//

import MapboxMaps
import UIKit

class MapboxTestViewController: UIViewController {
    var mapView: MapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MapView(frame: view.bounds)
        view.addSubview(mapView)
    }
}
