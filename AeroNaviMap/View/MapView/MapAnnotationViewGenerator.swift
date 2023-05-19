//
//  MapAnnotationViewGenerator.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 10/20/22.
//

import Foundation
import MapKit
import MapboxMaps

class MapAnnotationViewGenerator {

    static var viewAdded = ["helipad": false, "largeAirport": false, "mediumAirport": false, "otherAirport": false, "runwayEnd": false, "nav": false, "vor": false, "ndb": false]
    static var annotationIsShowed = ["largeAirportAnnotation": true, "mediumAirportAnnotation": false, "otherAirportAnnotation": false, "runwayEndAnnotation": false, "navAnnotation": false, "vorAnnotation": false, "ndbAnnotation": false, "helipadAnnotation": false, "runwayAnnotation": false, "ILSAnnotation": false, "vectorAirwayAnnotation": false, "jetAirwayAnnotation": false]

    static func addAnnotationViews(aeroObjectClass: String, mapAnnotationViewController: MapAnnotationViewController, northBound: Double?, southBound: Double?, westBound: Double?, eastBound: Double?) {
        switch aeroObjectClass {
        case "helipad":
            if viewAdded["helipad"] == false {
                DBReader.shared.asyncReadHelipadForAnnotation { mainList in
                    DispatchQueue.main.async {
                        mapAnnotationViewController.addAllAnnotations(currAnnotations: mainList)
                        viewAdded["helipad"] = true
                    }
                }
            }
        case "largeAirport":
            if viewAdded["largeAirport"] == false {
                DBReader.shared.asyncReadLargeAirportForAnnotation(northBound: northBound, southBound: southBound, westBound: westBound, eastBound: eastBound) { mainList in
                    DispatchQueue.main.async {
                        mapAnnotationViewController.addAllAnnotations(currAnnotations: mainList)
                        viewAdded["largeAirport"] = true
                    }
                }
            }
        case "mediumAirport":
            if viewAdded["mediumAirport"] == false {
                DBReader.shared.asyncReadMediumAirportForAnnotation(northBound: northBound, southBound: southBound, westBound: westBound, eastBound: eastBound) { mainList in
                    DispatchQueue.main.async {
                        mapAnnotationViewController.addAllAnnotations(currAnnotations: mainList)
                        viewAdded["mediumAirport"] = true
                    }
                }
            }
        case "otherAirport":
            if viewAdded["otherAirport"] == false {
                DBReader.shared.asyncReadOtherAirportForAnnotation(northBound: northBound, southBound: southBound, westBound: westBound, eastBound: eastBound) { mainList in
                    DispatchQueue.main.async {
                        mapAnnotationViewController.addAllAnnotations(currAnnotations: mainList)
                        viewAdded["otherAirport"] = true
                    }
                }
            }
        case "runwayEnd":
            if viewAdded["runwayEnd"] == false {
                DBReader.shared.asyncReadRunwayEndForAnnotation { mainList in
                    DispatchQueue.main.async {
                        mapAnnotationViewController.addAllAnnotations(currAnnotations: mainList)
                        viewAdded["runwayEnd"] = true
                    }
                }
            }
        case "nav":
            if viewAdded["nav"] == false {
                DBReader.shared.asyncReadNavForAnnotation { mainList in
                    DispatchQueue.main.async {
                        mapAnnotationViewController.addAllAnnotations(currAnnotations: mainList)
                        viewAdded["nav"] = true
                    }
                }
            }
        case "vor":
            if viewAdded["vor"] == false {
                DBReader.shared.asyncReadVorForAnnotation { mainList in
                    DispatchQueue.main.async {
                        mapAnnotationViewController.addAllAnnotations(currAnnotations: mainList)
                        viewAdded["vor"] = true
                    }
                }
            }
        case "ndb":
            if viewAdded["ndb"] == false {
                DBReader.shared.asyncReadNdbForAnnotation { mainList in
                    DispatchQueue.main.async {
                        mapAnnotationViewController.addAllAnnotations(currAnnotations: mainList)
                        viewAdded["ndb"] = true
                    }
                }
            }
        case "jetAirwayAnnotation":
            DBReader.shared.asyncReadJetAirwayForAnnotation(centerLonx: nil, centerLaty: nil) { mainList, annotationList in
                DispatchQueue.main.async {
                    mapAnnotationViewController.addAllPolyline(currPolylines: mainList)
                    mapAnnotationViewController.addAllAnnotations(currAnnotations: annotationList)
                }
            }
        case "vectorAirwayAnnotation":
            DBReader.shared.asyncReadVectorAirwayForAnnotation(centerLonx: nil, centerLaty: nil) { mainList, annotationList in
                DispatchQueue.main.async {
                    mapAnnotationViewController.addAllPolyline(currPolylines: mainList)
                    mapAnnotationViewController.addAllAnnotations(currAnnotations: annotationList)
                }
            }
        case "runwayAnnotation":
            DBReader.shared.asyncReadRunwayForAnnotation(centerLonx: nil, centerLaty: nil) { mainList in
                DispatchQueue.main.async {
                    mapAnnotationViewController.addAllPolyline(currPolylines: mainList)
                }
            }
        case "ilsAnnotation":
            DBReader.shared.asyncReadILSForAnnotation(centerLonx: nil, centerLaty: nil) { mainList in
                DispatchQueue.main.async {
                    mapAnnotationViewController.addAllPolygon(currPolygons: mainList)
                }
            }
        default:
            print("Invaild class or class is alread added")
        }
    }
}
