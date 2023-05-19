//
//  AirportInfoPanelViewModel.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 10/25/22.

import Foundation
import WikipediaKit

class AirportInfoPanelViewModel: ObservableObject {
    @Published var airport: Airport
    @Published var facilitiesInfo: String = ""
    @Published var runWayBasicInfo: String = ""
    @Published var runwayEnds:[RunwayEnd]?
    @Published var runwayDetailFacilities: [String:String] = [:]
    @Published var wikiUrl:URL?
    @Published var isResultReturned:Bool = false

    init(airport: Airport) {
        self.airport = airport
        getFacilitiesInfo()
        getRunWayBasicInfo()
        fetchRunwayInfo(airport: airport)
        fetchWikiUrl()
    }
    
    func fetchWikiUrl() {
        guard let airportName = airport.title else {return}
        let language = WikipediaLanguage("en")
        self.isResultReturned = false
        self.wikiUrl = nil
        if let city = airport.city {
//            DBReader().asyncFetchAirportCount(city: city) { count in
            DBReader.shared.asyncFetchAirportCount(city: city) { count in
                DispatchQueue.main.async {
                    var searchName = ""
                    if count == 1 {
                        searchName = "\(city) airport"
                    } else {
                        searchName = "\(airportName) airport"
                    }
                    let _ = Wikipedia.shared.requestOptimizedSearchResults(language: language, term: searchName) { (searchResults, error) in
                        guard error == nil else {
                            self.isResultReturned = true
                            return
                        }
                        guard let searchResults = searchResults else {
                            self.isResultReturned = true
                            return
                        }
                        self.isResultReturned = true
                        if let title = searchResults.items.first?.title {
                            let substr = title.components(separatedBy: " ")
                            if let lastStr = substr.last {
                                if lastStr == "Airport" || lastStr == "Airbase" || lastStr == "Airfield" {
                                    let orgUrl = searchResults.items.first?.url
                                    if let orgUrl = orgUrl {
                                        var part1 = orgUrl.absoluteString[0...10]
                                        part1 += "m."
                                        part1 += orgUrl.absoluteString[11..<orgUrl.absoluteString.count]
                                        self.wikiUrl = URL(string: part1)
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private func getRunWayBasicInfo() {
        if let hardRunwayNum = airport.num_runway_hard, hardRunwayNum > 0 {
            runWayBasicInfo += "Hard Runway; "
        }
        if let lightedRunwayNum = airport.num_runway_light, lightedRunwayNum > 0 {
            runWayBasicInfo += "Lighted Runway; "
        }
        if let softRunwayNum = airport.num_runway_soft, softRunwayNum > 0 {
            runWayBasicInfo += "Soft Runway; "
        }
        if let waterRunway = airport.num_runway_water, waterRunway > 0 {
            runWayBasicInfo += "Water Runway"
        }

    }

    private func getFacilitiesInfo() {
        if let apronsNum = airport.num_apron, apronsNum > 0 {
            facilitiesInfo += "Apron; "
        }
        if let taxiwaysNum = airport.num_taxi_path, taxiwaysNum > 0 {
            facilitiesInfo += "Taxiways; "
        }
        if airport.has_tower_object != nil {
            facilitiesInfo += "Tower; "
        }
        if let parkingGateNum = airport.num_parking_gate, parkingGateNum > 0 {
            facilitiesInfo += "Parking Gate; "
        }
        if airport.has_avgas != nil {
            facilitiesInfo += "Avgas; "
        }
        if let endIlsNum = airport.num_runway_end_ils, endIlsNum > 0 {
            facilitiesInfo += "ILS; "
        }
        if let endVasiNum = airport.num_runway_end_vasi, endVasiNum > 0 {
            facilitiesInfo += "VASI; "
        }
        if let endAlsNum = airport.num_runway_end_als, endAlsNum > 0 {
            facilitiesInfo += "ALS; "
        }
        if facilitiesInfo == "" {
            facilitiesInfo = "N/A"
        }
    }
    
    private func fetchRunwayInfo(airport:Airport) {
        if let icao = airport.ident {
            DBReader.shared.asyncSearchRunwayOfAirport(icao: icao) { mainList in
                DispatchQueue.main.async {
                    self.runwayEnds = mainList
                    for runwayEnd in mainList {
                        self.fetchRunwayDetailFacilities(runwayEnd: runwayEnd)
                    }
                }
            }
        }
    }
    
    func fetchRunwayDetailFacilities(runwayEnd:RunwayEnd) {
        var desc = ""
        if let has_closed_markings = runwayEnd.has_closed_markings, has_closed_markings == 1 {
            desc += "Closed Markings; "
        }
        if let has_stol_markings = runwayEnd.has_stol_markings, has_stol_markings == 1 {
            desc += "Stol Markings; "
        }
        if let has_end_lights = runwayEnd.has_end_lights, has_end_lights == 1 {
            desc += "End Lights; "
        }
        if let has_reils = runwayEnd.has_reils, has_reils == 1 {
            desc += "Reils; "
        }
        if let has_touchdown_lights = runwayEnd.has_touchdown_lights, has_touchdown_lights == 1 {
            desc += "Touchdown Lights; "
        }
        if let has_touchdown_lights = runwayEnd.has_touchdown_lights, has_touchdown_lights == 1 {
            desc += "Touchdown Lights; "
        }
        if let has_center_red = runwayEnd.has_center_red, has_center_red == 1 {
            desc += "Center Red; "
        }
        if let name = runwayEnd.name {
            self.runwayDetailFacilities[name] = desc
        }
    }
}
