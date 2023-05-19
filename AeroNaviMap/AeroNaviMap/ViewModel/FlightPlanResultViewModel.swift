//
//  FlightPlanResultViewModel.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 11/16/22.
//  Refer to willdale's SwiftUICharts https://github.com/willdale/SwiftUICharts

import Foundation
import SwiftUI
import SwiftUICharts
import MapboxMaps
class FlightPlanResultViewModel:ObservableObject {
    @Published var flightPlanWayPoints:[FlightPlanWayPoint]
    @Published var minAltitudeLineChartDataPoint: LineChartData?
    @Published var flightPlanWayPointsStr:String
    @Published var speedStrHr:String = ""
    @Published var estTimeHr:String = ""
    var flightRoute: LineString?
    init(flightPlanWayPoints: [FlightPlanWayPoint], flightRoute: LineString?) {
        self.flightPlanWayPoints = flightPlanWayPoints
        self.flightRoute = flightRoute
        var str = ""
        for item in flightPlanWayPoints {
            str += (item.ident + " ")
        }
        flightPlanWayPointsStr = str
        fetchMinimumAltitude()
    }
    func calculateEstTime() {
        if let speedHr = Double(self.speedStrHr) {
            let estTimeHrVal = Double((flightRoute?.distance() ?? 0) / 1000) / speedHr
            let min = (estTimeHrVal - Double(Int(estTimeHrVal))) * 60
            estTimeHr = "\(Int(estTimeHrVal)):\(Int(min))"
        } else {
            estTimeHr = "N/A"
        }
    }
    func fetchMinimumAltitude() {
        for flightPlanWayPoint in flightPlanWayPoints {
            if flightPlanWayPoint.type == FlightPlanWayPoint.FlightPlanWayPointType.airway {
                DBReader.shared.asyncFetchFlightPlanAirway(flightPlanWayPoints: flightPlanWayPoints) { mainList in
                    DispatchQueue.main.async {
                        var minVal = mainList.first?.value
                        var maxVal = mainList.first?.value
                        for eachVal in mainList {
                            if let minValUnwarp = minVal, eachVal.value < minValUnwarp {
                                minVal = eachVal.value
                            }
                            if let maxValUnwarp = maxVal, eachVal.value > maxValUnwarp {
                                maxVal = eachVal.value
                            }
                        }
                        
                        let data = LineDataSet(dataPoints: mainList, legendTitle: "Altitude", pointStyle: PointStyle(),style: LineStyle(lineColour: ColourStyle(colour: .red), lineType: .curvedLine))
                        
                        let metadata   = ChartMetadata(title: "Minimum Altitude (ft)", subtitle: "on Airway")
                        
                        let gridStyle  = GridStyle(numberOfLines: 7,
                                                   lineColour   : Color(.lightGray).opacity(0.5),
                                                   lineWidth    : 1,
                                                   dash         : [8],
                                                   dashPhase    : 0)
                        
                        let chartStyle = LineChartStyle(infoBoxPlacement    : .infoBox(isStatic: false),
                                                        infoBoxBorderColour : Color.primary,
                                                        infoBoxBorderStyle  : StrokeStyle(lineWidth: 1),
                                                        
                                                        markerType          : .vertical(attachment: .line(dot: .style(DotStyle()))),
                                                        
                                                        xAxisGridStyle      : gridStyle,
                                                        xAxisLabelPosition  : .bottom,
                                                        xAxisLabelColour    : Color.primary,
                                                        xAxisLabelsFrom     : .dataPoint(rotation: .degrees(0)),
                                                        
                                                        yAxisGridStyle      : gridStyle,
                                                        yAxisLabelPosition  : .leading,
                                                        yAxisLabelColour    : Color.primary,
                                                        yAxisNumberOfLabels : 7,
                                                        
                                                        baseline            : .zero,
                                                        topLine             : .maximum(of: maxVal ?? 0),
                                                        
                                                        globalAnimation     : .easeOut(duration: 1))
                        
                        self.minAltitudeLineChartDataPoint = LineChartData(dataSets       : data,
                                                        metadata       : metadata,
                                                        chartStyle     : chartStyle)
                        
                    }
                }
            }
        }
    }
}
