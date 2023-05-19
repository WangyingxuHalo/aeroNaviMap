//
//  FlightPlanResultView.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 11/15/22.
//  Refer to willdale's SwiftUICharts https://github.com/willdale/SwiftUICharts

import SwiftUI
import SwiftUICharts
struct FlightPlanResultView: View {
    @StateObject var flightPlanResultViewModel: FlightPlanResultViewModel
    @Environment(\.colorScheme) var themeScheme
    @State var viewTabBackgroundColor = UIColor.theme.grayBackground
    let sec1Columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        ScrollView {
            Spacer(minLength: 20.0)
            Text("Flight Route Summary")
                .bold()
                .font(.title)
            Spacer(minLength: 20.0)
            HStack {
                Spacer()
                Text(flightPlanResultViewModel.flightPlanWayPointsStr)
                Spacer()
            }
            Spacer(minLength: 20.0)
            LazyVGrid(columns: sec1Columns) {
                Text("Route Name")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom)
                Text("Coordinate")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom)
                ForEach(flightPlanResultViewModel.flightPlanWayPoints, id: \.self) { point in
                    if point.type != FlightPlanWayPoint.FlightPlanWayPointType.airway, point.type != FlightPlanWayPoint.FlightPlanWayPointType.direct {
                        Text(point.ident)
                            .padding(.bottom)
                        Text("\(point.laty), \(point.lonx)")
                            .padding(.bottom)
                    }
                }
            }
            .padding()
            .background(Rectangle()
                .cornerRadius(5.0)
                .onAppear {
                    viewTabBackgroundColor = themeScheme == .dark ? UIColor.theme.blackBackground : UIColor.theme.grayBackground
                }
                .foregroundColor(Color(uiColor: viewTabBackgroundColor))
            )
            
            Spacer(minLength: 20.0)
            if let flightRoute = flightPlanResultViewModel.flightRoute {
                HStack {
                    Spacer()
                    LazyVGrid(columns: sec1Columns) {
                        Text("Distance")
                            .frame(width: 150, alignment: .leading)
                            .font(.largeTitle)
                        
                        Text(String(format: "%.3f km", Double((flightRoute.distance() ?? 0) / 1000)))
                            .frame(width: 150, alignment: .leading)
//                        TextField(text: $flightPlanResultViewModel.speedStrHr) {
//                            Text("Speed (km/h)")
//                        }.frame(width: 150, alignment: .leading)
//                        Text("\(flightPlanResultViewModel.estTimeHr)")
//                            .frame(width: 150, alignment: .leading)
//                            .onChange(of: flightPlanResultViewModel.speedStrHr) { _ in
//                                flightPlanResultViewModel.calculateEstTime()
//                            }
                    }
                    .padding(.bottom)
                    Spacer()
                }
            }
            Divider()
//            Spacer(minLength: 20.0)
            
            ScrollView(.horizontal) {
                HStack {
                    Spacer()
                    if let data =  flightPlanResultViewModel.minAltitudeLineChartDataPoint {
                        LineChart(chartData: data)
                            .pointMarkers(chartData: data)
                            .touchOverlay(chartData: data, specifier: "%.0f")
                            .averageLine(chartData: data,
                                         strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
                            .xAxisGrid(chartData: data)
                            .yAxisGrid(chartData: data)
                            .xAxisLabels(chartData: data)
                            .yAxisLabels(chartData: data)
                            .infoBox(chartData: data)
                            .headerBox(chartData: data)
                            .legends(chartData: data, columns: [GridItem(.flexible())])
                            .id(data.id)
                            .frame(minWidth: data.dataSets.dataPoints.count <= 3 ? 210 : CGFloat(data.dataSets.dataPoints.count) * 60, maxHeight: 500)
                        Spacer(minLength: 30)
                    }
                }
            }
        }.padding(.top)
        Spacer(minLength: 20.0)
    }
}
