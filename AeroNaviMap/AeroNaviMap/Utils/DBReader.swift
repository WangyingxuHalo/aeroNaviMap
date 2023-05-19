//
//  DBReader.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 10/19/22.
//

import Foundation
import SQLite3
import MapKit
import SwiftUICharts
class DBReader {
    
    static let shared = DBReader()
    
    private init(){}
    
    func asyncReadHelipadForAnnotation(completionHandler: @escaping (_ mianList: [Helipad]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [Helipad]()
            
            let query = "SELECT * FROM helipad;"
            var statement: OpaquePointer? = nil
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let helipad_id = Int(sqlite3_column_int(statement, 0))
                    let airport_id = Int(sqlite3_column_int(statement, 1))
                    let start_id = Int(sqlite3_column_int(statement, 2))
                    let surface = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                    let type = String(describing: String(cString: sqlite3_column_text(statement, 4)))
                    let length = Double(sqlite3_column_double(statement, 5))
                    let width = Double(sqlite3_column_double(statement, 6))
                    let heading = Double(sqlite3_column_double(statement, 7))
                    let is_transparent = Int(sqlite3_column_int(statement, 8))
                    let is_closed = Int(sqlite3_column_int(statement, 9))
                    let altitude = Int(sqlite3_column_int(statement, 10))
                    let lonx = Double(sqlite3_column_double(statement, 11))
                    let laty = Double(sqlite3_column_double(statement, 12))
                    
                    let model = Helipad(title: "Helipad", subtitle: "#\(helipad_id)", helipad_id: helipad_id, airport_id: airport_id, start_id: start_id, surface: surface, type: type, length: length, width: width, heading: heading, is_transparent: is_transparent, is_closed: is_closed, altitude: altitude, lonx: lonx, laty: laty)
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    func asyncReadRunwayEndForAnnotation(completionHandler: @escaping (_ mainList: [RunwayEnd]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [RunwayEnd]()
            let query = "select name,heading,lonx,laty from runway_end;"
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    var name: String? = nil
                    if let cString = sqlite3_column_text(statement, 0) {
                        name = String(describing: String(cString: cString))
                    }
                    let heading = Double(sqlite3_column_double(statement, 1))
                    let lonx = Double(sqlite3_column_double(statement, 2))
                    let laty = Double(sqlite3_column_double(statement, 3))
                    
                    let model = RunwayEnd(name: name, heading: heading, lonx: lonx, laty: laty)
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    
    func asyncReadLargeAirportForAnnotation(northBound: Double?, southBound: Double?, westBound: Double?, eastBound: Double?, completionHandler: @escaping (_ mainList: [LargeAirport]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [LargeAirport]()
            var query: String
            if let northBound = northBound,
               let southBound = southBound,
               let westBound = westBound,
               let eastBound = eastBound {
                query = "select airport_id,lonx,laty,ident,name from airport_large where (laty between \(northBound) and \(southBound)) and (lonx between \(westBound) and \(eastBound));"
            } else {
                query = "select airport_id,lonx,laty,ident,name from airport_large;"
            }
            
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let airport_id = Int(sqlite3_column_int(statement, 0))
                    let lonx = Double(sqlite3_column_double(statement, 1))
                    let laty = Double(sqlite3_column_double(statement, 2))
                    let icao = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                    let name = String(describing: String(cString: sqlite3_column_text(statement, 4)))
                    
                    let model = LargeAirport(title: name, subtitle: icao, airport_id: airport_id, lonx: lonx, laty: laty)
                    mainList.append(model)
                }
            } else {
                print("______")
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
                print("______")
            }
            print("==============DB Large Airport (Annotation) Read===============")
            sqlite3_finalize(statement)
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    
    func asyncReadMediumAirportForAnnotation(northBound: Double?, southBound: Double?, westBound: Double?, eastBound: Double?, completionHandler: @escaping (_ mainList: [MediumAirport]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [MediumAirport]()
            var query: String
            if let northBound = northBound,
               let southBound = southBound,
               let westBound = westBound,
               let eastBound = eastBound {
                query = "select airport_medium.airport_id,airport_medium.lonx,airport_medium.laty,airport_medium.ident,airport_medium.name from  airport_medium where airport_medium.airport_id not in (select airport_large.airport_id from airport_large) and airport_medium.name is not null and (laty between \(northBound) and \(southBound)) and (lonx between \(westBound) and \(eastBound));"
            } else {
                query = "select airport_medium.airport_id,airport_medium.lonx,airport_medium.laty,airport_medium.ident,airport_medium.name from  airport_medium where airport_medium.airport_id not in (select airport_large.airport_id from airport_large) and airport_medium.name is not null;"
            }
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let airport_id = Int(sqlite3_column_int(statement, 0))
                    let lonx = Double(sqlite3_column_double(statement, 1))
                    let laty = Double(sqlite3_column_double(statement, 2))
                    let icao = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                    let name = String(describing: String(cString: sqlite3_column_text(statement, 4)))
                    
                    let model = MediumAirport(title: name, subtitle: icao, airport_id: airport_id, lonx: lonx, laty: laty)
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    func asyncReadOtherAirportForAnnotation(northBound: Double?, southBound: Double?, westBound: Double?, eastBound: Double?, completionHeadler: @escaping (_ mainList: [OtherAirport]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [OtherAirport]()
            var query: String
            if let northBound = northBound,
               let southBound = southBound,
               let westBound = westBound,
               let eastBound = eastBound {
                query = "select airport.airport_id,airport.lonx,airport.laty,airport.ident,airport.name from airport where airport.ident not in (select airport_large.ident from airport_large) and airport.ident not in (select airport_medium.ident from  airport_medium) and (laty between \(southBound) and \(northBound)) and (lonx between \(westBound) and \(eastBound));"
            } else {
                query = "select airport.airport_id,airport.lonx,airport.laty,airport.ident,airport.name from airport where airport.ident not in (select airport_large.ident from airport_large) and airport.ident not in (select airport_medium.ident from  airport_medium);"
            }
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let airport_id = Int(sqlite3_column_int(statement, 0))
                    let lonx = Double(sqlite3_column_double(statement, 1))
                    let laty = Double(sqlite3_column_double(statement, 2))
                    let icao = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                    let name = String(describing: String(cString: sqlite3_column_text(statement, 4)))
                    
                    let model = OtherAirport(title: name, subtitle: icao, airport_id: airport_id, lonx: lonx, laty: laty)
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            sqlite3_close(dbOpaquePointer)
            completionHeadler(mainList)
        }
    }
    
    func asyncReadNavForAnnotation(icaoCode ident: String, completionHandler: @escaping (_ mainList: [NAV]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [NAV]()
            let query = "select nav_search_id,ident,lonx,laty, region, mag_var from nav_search where ident='\(ident)';"
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let nav_search_id = Int(sqlite3_column_int(statement, 0))
                    var ident: String? = nil
                    if let cString = sqlite3_column_text(statement, 1) {
                        ident = String(describing: String(cString: cString))
                    }
                    let lonx = Double(sqlite3_column_double(statement, 2))
                    let laty = Double(sqlite3_column_double(statement, 3))
                    var region: String? = nil
                    if let cString = sqlite3_column_text(statement, 4) {
                        region = String(describing: String(cString: cString))
                    }
                    let mag_var = Double(sqlite3_column_double(statement, 5))
                    
                    let model = NAV(nav_search_id: nav_search_id, ident: ident, lonx: lonx, laty: laty, region: region, mag_var: mag_var)
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            //TODO: Crash
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    func asyncReadVorForAnnotation(icaoCode ident: String, completionHandler: @escaping (_ mainList: [VOR]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [VOR]()
            let query = "select vor_id,ident,lonx,laty, name, region, frequency, range, mag_var, dme_only, dme_altitude, dme_lonx, dme_laty, altitude from vor where ident='\(ident)';"
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let vor_id = Int(sqlite3_column_int(statement, 0))
                    var ident: String? = nil
                    if let cString = sqlite3_column_text(statement, 1) {
                        ident = String(describing: String(cString: cString))
                    }
                    let lonx = Double(sqlite3_column_double(statement, 2))
                    let laty = Double(sqlite3_column_double(statement, 3))
                    var name: String? = nil
                    if let cString = sqlite3_column_text(statement, 4) {
                        name = String(describing: String(cString: cString))
                    }
                    var region: String? = nil
                    if let cString = sqlite3_column_text(statement, 5) {
                        region = String(describing: String(cString: cString))
                    }
                    let frequency = Int(sqlite3_column_double(statement, 6))
                    let range = Int(sqlite3_column_double(statement, 7))
                    let mag_var = Double(sqlite3_column_double(statement, 8))
                    let dme_only = Int(sqlite3_column_double(statement, 9))
                    let dme_altitude = Int(sqlite3_column_double(statement, 10))
                    let dme_lonx = Double(sqlite3_column_double(statement, 11))
                    let dme_laty = Double(sqlite3_column_double(statement, 12))
                    let altitude = Int(sqlite3_column_double(statement, 13))
                    
                    let model = VOR(vor_id: vor_id, ident: ident, lonx: lonx, laty: laty, name: name, region: region, frequency: frequency, range: range, mag_var: mag_var, dme_only: dme_only, dme_altitude: dme_altitude, dme_lonx: dme_lonx, dme_laty: dme_laty, altitude: altitude)
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            // TODO: Crash
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    func asyncReadNdbForAnnotation(icaoCode ident: String, completionHandler: @escaping (_ mainList: [NDB]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [NDB]()
            let query = "select ndb_id,ident,lonx,laty, name, region, type, frequency, range, mag_var from ndb where ident='\(ident)';"
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let ndb_id = Int(sqlite3_column_int(statement, 0))
                    var ident: String? = nil
                    if let cString = sqlite3_column_text(statement, 1) {
                        ident = String(describing: String(cString: cString))
                    }
                    let lonx = Double(sqlite3_column_double(statement, 2))
                    let laty = Double(sqlite3_column_double(statement, 3))
                    var name: String? = nil
                    if let cString = sqlite3_column_text(statement, 4) {
                        name = String(describing: String(cString: cString))
                    }
                    var region: String? = nil
                    if let cString = sqlite3_column_text(statement, 5) {
                        region = String(describing: String(cString: cString))
                    }
                    var type: String? = nil
                    if let cString = sqlite3_column_text(statement, 6) {
                        type = String(describing: String(cString: cString))
                    }
                    let frequency = Int(sqlite3_column_double(statement, 7))
                    let range = Int(sqlite3_column_double(statement, 8))
                    let mag_var = Double(sqlite3_column_double(statement, 9))
                    
                    let model = NDB(ndb_id: ndb_id, ident: ident, lonx: lonx, laty: laty, name: name, region: region, type: type, frequency: frequency, range: range, mag_var: mag_var)
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            // TODO: Crash
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    func asyncReadNavForAnnotation(completionHandler: @escaping (_ mainList: [NAV]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [NAV]()
            let query = "select nav_search_id,ident,lonx,laty from nav_search;"
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let nav_search_id = Int(sqlite3_column_int(statement, 0))
                    var ident: String? = nil
                    if let cString = sqlite3_column_text(statement, 1) {
                        ident = String(describing: String(cString: cString))
                    }
                    let lonx = Double(sqlite3_column_double(statement, 2))
                    let laty = Double(sqlite3_column_double(statement, 3))
                    
                    let model = NAV(nav_search_id: nav_search_id, ident: ident, lonx: lonx, laty: laty)
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            //TODO: Crash
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    func asyncReadVorForAnnotation(completionHandler: @escaping (_ mainList: [VOR]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [VOR]()
            let query = "select vor_id,ident,lonx,laty from vor;"
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let vor_id = Int(sqlite3_column_int(statement, 0))
                    var ident: String? = nil
                    if let cString = sqlite3_column_text(statement, 1) {
                        ident = String(describing: String(cString: cString))
                    }
                    let lonx = Double(sqlite3_column_double(statement, 2))
                    let laty = Double(sqlite3_column_double(statement, 3))
                    
                    let model = VOR(vor_id: vor_id, ident: ident, lonx: lonx, laty: laty)
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            // TODO: Crash
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    
    func asyncReadNdbForAnnotation(completionHandler: @escaping (_ mainList: [NDB]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [NDB]()
            let query = "select ndb_id,ident,lonx,laty from ndb;"
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let ndb_id = Int(sqlite3_column_int(statement, 0))
                    var ident: String? = nil
                    if let cString = sqlite3_column_text(statement, 1) {
                        ident = String(describing: String(cString: cString))
                    }
                    let lonx = Double(sqlite3_column_double(statement, 2))
                    let laty = Double(sqlite3_column_double(statement, 3))
                    
                    let model = NDB(ndb_id: ndb_id, ident: ident, lonx: lonx, laty: laty)
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            // TODO: Crash
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    
    func asyncReadRunwayForAnnotation(centerLonx: Double?, centerLaty: Double?, completionHandler: @escaping (_ mainList: [Runway]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [Runway]()
            var query: String
            if let centerLaty = centerLaty,
               let centerLonx = centerLonx {
                query = "select runway_id,primary_lonx,primary_laty,secondary_lonx,secondary_laty,lonx,laty from runway where (primary_laty between \(centerLaty - 1) and \(centerLaty + 1)) and (primary_lonx between \(centerLonx - 1) and \(centerLonx + 1));"
            } else {
                query = "select runway_id,primary_lonx,primary_laty,secondary_lonx,secondary_laty,lonx,laty from runway;"
            }
            
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let runway_id = Int(sqlite3_column_int(statement, 0))
                    let primary_lonx = Double(sqlite3_column_double(statement, 1))
                    let primary_laty = Double(sqlite3_column_double(statement, 2))
                    let secondary_lonx = Double(sqlite3_column_double(statement, 3))
                    let secondary_laty = Double(sqlite3_column_double(statement, 4))
                    let lonx = Double(sqlite3_column_double(statement, 5))
                    let laty = Double(sqlite3_column_double(statement, 6))
                    
                    let model = Runway(runway_id: runway_id, primary_lonx: primary_lonx, primary_laty: primary_laty, secondary_lonx: secondary_lonx, secondary_laty: secondary_laty, lonx: lonx, laty: laty)
                    
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            DBManager.closeDB()
            sqlite3_finalize(statement)
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    
    func asyncReadVectorAirwayForAnnotation(centerLonx: Double?, centerLaty: Double?, completionHandler: @escaping (_ mainList: [VectorAirway], _ annotationList:[VectorAirwayGeneralLabel]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [VectorAirway]()
            var annotationList = [VectorAirwayGeneralLabel]()
            var query: String
            if let centerLaty = centerLaty,
               let centerLonx = centerLonx {
                query = "select airway_id,airway_name,from_lonx,from_laty,to_lonx,to_laty from airway where (airway_type='V' or airway_type='B') and (((from_laty between \(centerLaty - 2) and \(centerLaty + 2)) and (from_lonx between \(centerLonx - 2) and \(centerLonx + 2))) or ((to_laty between \(centerLaty - 2) and \(centerLaty + 2)) and (to_lonx between \(centerLonx - 2) and \(centerLonx + 2))));"
            } else {
                query = "select airway_id,airway_name,from_lonx,from_laty,to_lonx,to_laty,left_lonx,right_lonx,top_laty,bottom_laty from airway where (airway_type='V' or airway_type='B');"
            }
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let airway_id = Int(sqlite3_column_int(statement, 0))
                    var airway_name: String? = nil
                    if let cString = sqlite3_column_text(statement, 1) {
                        airway_name = String(describing: String(cString: cString))
                    }
                    let from_lonx = Double(sqlite3_column_double(statement, 2))
                    let from_laty = Double(sqlite3_column_double(statement, 3))
                    let to_lonx = Double(sqlite3_column_double(statement, 4))
                    let to_laty = Double(sqlite3_column_double(statement, 5))
                    let left_lonx = Double(sqlite3_column_double(statement, 6))
                    let right_lonx = Double(sqlite3_column_double(statement, 7))
                    let top_laty = Double(sqlite3_column_double(statement, 8))
                    let bottom_laty = Double(sqlite3_column_double(statement, 9))
                    
                    let model = VectorAirway(airway_id: airway_id, airway_name: airway_name, from_lonx: from_lonx, from_laty: from_laty, to_lonx: to_lonx, to_laty: to_laty)
                    let annotation = VectorAirwayGeneralLabel(ident: airway_name, lonx: from_lonx, laty: from_laty, left_lonx: left_lonx, right_lonx: right_lonx, top_laty: top_laty,bottom_laty: bottom_laty)
                    
                    mainList.append(model)
                    annotationList.append(annotation)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            DBManager.closeDB()
            sqlite3_finalize(statement)
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList,annotationList)
        }
    }
    
    
    func asyncReadJetAirwayForAnnotation(centerLonx: Double?, centerLaty: Double?, completionHandler: @escaping (_ mainList: [JetAirway], _ annotationList:[JetAirwayGeneralLabel]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [JetAirway]()
            var annotationList = [JetAirwayGeneralLabel]()
            var query: String
            if let centerLaty = centerLaty,
               let centerLonx = centerLonx {
                query = "select airway_id,airway_name,from_lonx,from_laty,to_lonx,to_laty from airway where (airway_type='J' or airway_type='B') and (((from_laty between \(centerLaty - 1.5) and \(centerLaty + 1.5)) and (from_lonx between \(centerLonx - 1.5) and \(centerLonx + 1.5))) or ((to_laty between \(centerLaty - 1.5) and \(centerLaty + 1.5)) and (to_lonx between \(centerLonx - 1.5) and \(centerLonx + 1.5))));"
            } else {
                query = "select airway_id,airway_name,from_lonx,from_laty,to_lonx,to_laty, left_lonx,right_lonx,top_laty,bottom_laty from airway where (airway_type='J' or airway_type='B');"
            }
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let airway_id = Int(sqlite3_column_int(statement, 0))
                    var airway_name: String? = nil
                    if let cString = sqlite3_column_text(statement, 1) {
                        airway_name = String(describing: String(cString: cString))
                    }
                    let from_lonx = Double(sqlite3_column_double(statement, 2))
                    let from_laty = Double(sqlite3_column_double(statement, 3))
                    let to_lonx = Double(sqlite3_column_double(statement, 4))
                    let to_laty = Double(sqlite3_column_double(statement, 5))
                    let left_lonx = Double(sqlite3_column_double(statement, 6))
                    let right_lonx = Double(sqlite3_column_double(statement, 7))
                    let top_laty = Double(sqlite3_column_double(statement, 8))
                    let bottom_laty = Double(sqlite3_column_double(statement, 9))
                    
                    let model = JetAirway(airway_id: airway_id, airway_name: airway_name, from_lonx: from_lonx, from_laty: from_laty, to_lonx: to_lonx, to_laty: to_laty)
                    let annotation = JetAirwayGeneralLabel(ident: airway_name, lonx: from_lonx, laty: from_laty, left_lonx: left_lonx, right_lonx: right_lonx, top_laty: top_laty,bottom_laty: bottom_laty)
                    
                    mainList.append(model)
                    annotationList.append(annotation)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            DBManager.closeDB()
            sqlite3_finalize(statement)
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList,annotationList)
        }
    }
    
    func asyncReadILSForAnnotation(centerLonx: Double?, centerLaty: Double?, completionHandler: @escaping (_ mainList: [ILS]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [ILS]()
            var query: String
            if let centerLaty = centerLaty,
               let centerLonx = centerLonx {
                query = "select end1_lonx,end1_laty,end_mid_lonx,end_mid_laty,end2_lonx,end2_laty,runway_end.lonx,runway_end.laty from ils,runway_end,runway,airport where ils.ident=runway_end.ils_ident and ils.loc_airport_ident=airport.ident and (runway_end.runway_end_id = runway.primary_end_id or runway_end.runway_end_id=runway.secondary_end_id) and airport.airport_id=runway.airport_id and (runway_end.laty between \(centerLaty - 4) and \(centerLaty + 4)) and (runway_end.lonx between \(centerLonx - 4) and \(centerLonx + 4));"
            } else {
                query = "select end1_lonx,end1_laty,end_mid_lonx,end_mid_laty,end2_lonx,end2_laty,runway_end.lonx,runway_end.laty from ils,runway_end,runway,airport where ils.ident=runway_end.ils_ident and ils.loc_airport_ident=airport.ident and (runway_end.runway_end_id = runway.primary_end_id or runway_end.runway_end_id=runway.secondary_end_id) and airport.airport_id=runway.airport_id;"
            }
            
            var statement: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let end1_lonx = Double(sqlite3_column_double(statement, 0))
                    let end1_laty = Double(sqlite3_column_double(statement, 1))
                    let end_mid_lonx = Double(sqlite3_column_double(statement, 2))
                    let end_mid_laty = Double(sqlite3_column_double(statement, 3))
                    let end2_lonx = Double(sqlite3_column_double(statement, 4))
                    let end2_laty = Double(sqlite3_column_double(statement, 5))
                    let lonx = Double(sqlite3_column_double(statement, 6))
                    let laty = Double(sqlite3_column_double(statement, 7))
                    
                    let model = ILS(end1_lonx: end1_lonx, end1_laty: end1_laty, end_mid_lonx: end_mid_lonx, end_mid_laty: end_mid_laty, end2_lonx: end2_lonx, end2_laty: end2_laty, lonx: lonx, laty: laty)
                    
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            DBManager.closeDB()
            sqlite3_finalize(statement)
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    func readCommunicationForInfo(icaoCode ident: String) -> [Communication] {
        let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
        var mainList = [Communication]()
        let query = "select * from com where airport_id= (select airport_id from airport where ident='\(ident)');"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                var type: String? = nil
                var name: String? = nil
                
                let com_id = Int(sqlite3_column_int(statement, 0))
                let airport_id = Int(sqlite3_column_int(statement, 1))
                if let cString = sqlite3_column_text(statement, 2) {
                    type = String(describing: String(cString: cString))
                }
                let frequency = Int(sqlite3_column_int(statement, 3))
                if let cString = sqlite3_column_text(statement, 4) {
                    name = String(describing: String(cString: cString))
                }
                
                let model = Communication(com_id: com_id, airport_id: airport_id, type: type, frequency: frequency, name: name)
                
                mainList.append(model)
            }
        } else {
            print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
        }
        sqlite3_finalize(statement)
        sqlite3_close(dbOpaquePointer)
        return mainList
    }
    
    func asyncReadLargeAirportForInfo(icaoCode ident: String, completionHandler: @escaping (_ largeAirports: [LargeAirport]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [LargeAirport]()
            let query = "select * from airport where ident='\(ident)';"
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    
                    var ident: String? = nil
                    var icao: String? = nil
                    var iata: String? = nil
                    var xpident: String? = nil
                    var name: String? = nil
                    var city: String? = nil
                    var state: String? = nil
                    var country: String? = nil
                    var region: String? = nil
                    var longest_runway_surface: String? = nil
                    var largest_parking_ramp: String? = nil
                    var largest_parking_gate: String? = nil
                    var scenery_local_path: String? = nil
                    var bgl_filename: String? = nil
                    
                    
                    let airport_id = Int(sqlite3_column_int(statement, 0))
                    let file_id = Int(sqlite3_column_int(statement, 1))
                    if let cString = sqlite3_column_text(statement, 2) {
                        ident = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 3) {
                        icao = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 4) {
                        iata = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 5) {
                        xpident = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 6) {
                        name = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 7) {
                        city = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 8) {
                        state = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 9) {
                        country = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 10) {
                        region = String(describing: String(cString: cString))
                    }
                    let flatten = Int(sqlite3_column_int(statement, 11))
                    let fuel_flags = Int(sqlite3_column_int(statement, 12))
                    let has_avgas = Int(sqlite3_column_int(statement, 13))
                    let has_jetfuel = Int(sqlite3_column_int(statement, 14))
                    let has_tower_object = Int(sqlite3_column_int(statement, 15))
                    let tower_frequency = Int(sqlite3_column_int(statement, 16))
                    let atis_frequency = Int(sqlite3_column_int(statement, 17))
                    let awos_frequency = Int(sqlite3_column_int(statement, 18))
                    let asos_frequency = Int(sqlite3_column_int(statement, 19))
                    let unicom_frequency = Int(sqlite3_column_int(statement, 20))
                    let is_closed = Int(sqlite3_column_int(statement, 21))
                    let is_military = Int(sqlite3_column_int(statement, 22))
                    let is_addon = Int(sqlite3_column_int(statement, 23))
                    let num_com = Int(sqlite3_column_int(statement, 24))
                    let num_parking_gate = Int(sqlite3_column_int(statement, 25))
                    let num_parking_ga_ramp = Int(sqlite3_column_int(statement, 26))
                    let num_parking_cargo = Int(sqlite3_column_int(statement, 27))
                    let num_parking_mil_cargo = Int(sqlite3_column_int(statement, 28))
                    let num_parking_mil_combat = Int(sqlite3_column_int(statement, 29))
                    let num_approach = Int(sqlite3_column_int(statement, 30))
                    let num_runway_hard = Int(sqlite3_column_int(statement, 31))
                    let num_runway_soft = Int(sqlite3_column_int(statement, 32))
                    let num_runway_water = Int(sqlite3_column_int(statement, 33))
                    let num_runway_light = Int(sqlite3_column_int(statement, 34))
                    let num_runway_end_closed = Int(sqlite3_column_int(statement, 35))
                    let num_runway_end_vasi = Int(sqlite3_column_int(statement, 36))
                    let num_runway_end_als = Int(sqlite3_column_int(statement, 37))
                    let num_runway_end_ils = Int(sqlite3_column_int(statement, 38))
                    let num_apron = Int(sqlite3_column_int(statement, 39))
                    let num_taxi_path = Int(sqlite3_column_int(statement, 40))
                    let num_helipad = Int(sqlite3_column_int(statement, 41))
                    let num_jetway = Int(sqlite3_column_int(statement, 42))
                    let num_starts = Int(sqlite3_column_int(statement, 43))
                    let longest_runway_length = Int(sqlite3_column_int(statement, 44))
                    let longest_runway_width = Int(sqlite3_column_int(statement, 45))
                    let longest_runway_heading = Double(sqlite3_column_double(statement, 46))
                    if let cString = sqlite3_column_text(statement, 47) {
                        longest_runway_surface = String(describing: String(cString: cString))
                    }
                    let num_runways = Int(sqlite3_column_int(statement, 48))
                    if let cString = sqlite3_column_text(statement, 49) {
                        largest_parking_ramp = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 50) {
                        largest_parking_gate = String(describing: String(cString: cString))
                    }
                    let rating = Int(sqlite3_column_int(statement, 51))
                    let is_3d = Int(sqlite3_column_int(statement, 52))
                    if let cString = sqlite3_column_text(statement, 53) {
                        scenery_local_path = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 54) {
                        bgl_filename = String(describing: String(cString: cString))
                    }
                    let left_lonx = Double(sqlite3_column_double(statement, 55))
                    let top_laty = Double(sqlite3_column_double(statement, 56))
                    let right_lonx = Double(sqlite3_column_double(statement, 57))
                    let bottom_laty = Double(sqlite3_column_double(statement, 58))
                    let mag_var = Double(sqlite3_column_double(statement, 59))
                    let tower_altitude = Int(sqlite3_column_int(statement, 60))
                    let tower_lonx = Double(sqlite3_column_double(statement, 61))
                    let tower_laty = Double(sqlite3_column_double(statement, 62))
                    let transition_altitude = Int(sqlite3_column_int(statement, 63))
                    let altitude = Int(sqlite3_column_int(statement, 64))
                    let lonx = Double(sqlite3_column_double(statement, 65))
                    let laty = Double(sqlite3_column_double(statement, 66))
                    
                    
                    let model = LargeAirport(title: name, subtitle: icao, airport_id: airport_id, file_id: file_id, ident: ident, icao: icao, iata: iata, xpident: xpident, name: name, city: city, state: state, country: country, region: region, flatten: flatten, fuel_flags: fuel_flags, has_avgas: has_avgas, has_jetfuel: has_jetfuel, has_tower_object: has_tower_object, tower_frequency: tower_frequency, atis_frequency: atis_frequency, awos_frequency: awos_frequency, asos_frequency: asos_frequency, unicom_frequency: unicom_frequency, is_closed: is_closed, is_military: is_military, is_addon: is_addon, num_com: num_com, num_parking_gate: num_parking_gate, num_parking_ga_ramp: num_parking_ga_ramp, num_parking_cargo: num_parking_cargo, num_parking_mil_cargo: num_parking_mil_cargo, num_parking_mil_combat: num_parking_mil_combat, num_approach: num_approach, num_runway_hard: num_runway_hard, num_runway_soft: num_runway_soft, num_runway_water: num_runway_water, num_runway_light: num_runway_light, num_runway_end_closed: num_runway_end_closed, num_runway_end_vasi: num_runway_end_vasi, num_runway_end_als: num_runway_end_als, num_runway_end_ils: num_runway_end_ils, num_apron: num_apron, num_taxi_path: num_taxi_path, num_helipad: num_helipad, num_jetway: num_jetway, num_starts: num_starts, longest_runway_length: longest_runway_length, longest_runway_width: longest_runway_width, longest_runway_heading: longest_runway_heading, longest_runway_surface: longest_runway_surface, num_runways: num_runways, largest_parking_ramp: largest_parking_ramp, largest_parking_gate: largest_parking_gate, rating: rating, is_3d: is_3d, scenery_local_path: scenery_local_path, bgl_filename: bgl_filename, left_lonx: left_lonx, top_laty: top_laty, right_lonx: right_lonx, bottom_laty: bottom_laty, mag_var: mag_var, tower_altitude: tower_altitude, tower_lonx: tower_lonx, tower_laty: tower_laty, transition_altitude: transition_altitude, altitude: altitude, lonx: lonx, laty: laty)
                    
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    
    func asyncReadMediumAirportForInfo(icaoCode ident: String, completionHandler: @escaping (_ mainList: [MediumAirport]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [MediumAirport]()
            let query = "select * from airport where ident='\(ident)';"
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    
                    var ident: String? = nil
                    var icao: String? = nil
                    var iata: String? = nil
                    var xpident: String? = nil
                    var name: String? = nil
                    var city: String? = nil
                    var state: String? = nil
                    var country: String? = nil
                    var region: String? = nil
                    var longest_runway_surface: String? = nil
                    var largest_parking_ramp: String? = nil
                    var largest_parking_gate: String? = nil
                    var scenery_local_path: String? = nil
                    var bgl_filename: String? = nil
                    
                    
                    let airport_id = Int(sqlite3_column_int(statement, 0))
                    let file_id = Int(sqlite3_column_int(statement, 1))
                    if let cString = sqlite3_column_text(statement, 2) {
                        ident = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 3) {
                        icao = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 4) {
                        iata = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 5) {
                        xpident = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 6) {
                        name = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 7) {
                        city = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 8) {
                        state = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 9) {
                        country = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 10) {
                        region = String(describing: String(cString: cString))
                    }
                    let flatten = Int(sqlite3_column_int(statement, 11))
                    let fuel_flags = Int(sqlite3_column_int(statement, 12))
                    let has_avgas = Int(sqlite3_column_int(statement, 13))
                    let has_jetfuel = Int(sqlite3_column_int(statement, 14))
                    let has_tower_object = Int(sqlite3_column_int(statement, 15))
                    let tower_frequency = Int(sqlite3_column_int(statement, 16))
                    let atis_frequency = Int(sqlite3_column_int(statement, 17))
                    let awos_frequency = Int(sqlite3_column_int(statement, 18))
                    let asos_frequency = Int(sqlite3_column_int(statement, 19))
                    let unicom_frequency = Int(sqlite3_column_int(statement, 20))
                    let is_closed = Int(sqlite3_column_int(statement, 21))
                    let is_military = Int(sqlite3_column_int(statement, 22))
                    let is_addon = Int(sqlite3_column_int(statement, 23))
                    let num_com = Int(sqlite3_column_int(statement, 24))
                    let num_parking_gate = Int(sqlite3_column_int(statement, 25))
                    let num_parking_ga_ramp = Int(sqlite3_column_int(statement, 26))
                    let num_parking_cargo = Int(sqlite3_column_int(statement, 27))
                    let num_parking_mil_cargo = Int(sqlite3_column_int(statement, 28))
                    let num_parking_mil_combat = Int(sqlite3_column_int(statement, 29))
                    let num_approach = Int(sqlite3_column_int(statement, 30))
                    let num_runway_hard = Int(sqlite3_column_int(statement, 31))
                    let num_runway_soft = Int(sqlite3_column_int(statement, 32))
                    let num_runway_water = Int(sqlite3_column_int(statement, 33))
                    let num_runway_light = Int(sqlite3_column_int(statement, 34))
                    let num_runway_end_closed = Int(sqlite3_column_int(statement, 35))
                    let num_runway_end_vasi = Int(sqlite3_column_int(statement, 36))
                    let num_runway_end_als = Int(sqlite3_column_int(statement, 37))
                    let num_runway_end_ils = Int(sqlite3_column_int(statement, 38))
                    let num_apron = Int(sqlite3_column_int(statement, 39))
                    let num_taxi_path = Int(sqlite3_column_int(statement, 40))
                    let num_helipad = Int(sqlite3_column_int(statement, 41))
                    let num_jetway = Int(sqlite3_column_int(statement, 42))
                    let num_starts = Int(sqlite3_column_int(statement, 43))
                    let longest_runway_length = Int(sqlite3_column_int(statement, 44))
                    let longest_runway_width = Int(sqlite3_column_int(statement, 45))
                    let longest_runway_heading = Double(sqlite3_column_double(statement, 46))
                    if let cString = sqlite3_column_text(statement, 47) {
                        longest_runway_surface = String(describing: String(cString: cString))
                    }
                    let num_runways = Int(sqlite3_column_int(statement, 48))
                    if let cString = sqlite3_column_text(statement, 49) {
                        largest_parking_ramp = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 50) {
                        largest_parking_gate = String(describing: String(cString: cString))
                    }
                    let rating = Int(sqlite3_column_int(statement, 51))
                    let is_3d = Int(sqlite3_column_int(statement, 52))
                    if let cString = sqlite3_column_text(statement, 53) {
                        scenery_local_path = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 54) {
                        bgl_filename = String(describing: String(cString: cString))
                    }
                    let left_lonx = Double(sqlite3_column_double(statement, 55))
                    let top_laty = Double(sqlite3_column_double(statement, 56))
                    let right_lonx = Double(sqlite3_column_double(statement, 57))
                    let bottom_laty = Double(sqlite3_column_double(statement, 58))
                    let mag_var = Double(sqlite3_column_double(statement, 59))
                    let tower_altitude = Int(sqlite3_column_int(statement, 60))
                    let tower_lonx = Double(sqlite3_column_double(statement, 61))
                    let tower_laty = Double(sqlite3_column_double(statement, 62))
                    let transition_altitude = Int(sqlite3_column_int(statement, 63))
                    let altitude = Int(sqlite3_column_int(statement, 64))
                    let lonx = Double(sqlite3_column_double(statement, 65))
                    let laty = Double(sqlite3_column_double(statement, 66))
                    
                    
                    let model = MediumAirport(title: name, subtitle: icao, airport_id: airport_id, file_id: file_id, ident: ident, icao: icao, iata: iata, xpident: xpident, name: name, city: city, state: state, country: country, region: region, flatten: flatten, fuel_flags: fuel_flags, has_avgas: has_avgas, has_jetfuel: has_jetfuel, has_tower_object: has_tower_object, tower_frequency: tower_frequency, atis_frequency: atis_frequency, awos_frequency: awos_frequency, asos_frequency: asos_frequency, unicom_frequency: unicom_frequency, is_closed: is_closed, is_military: is_military, is_addon: is_addon, num_com: num_com, num_parking_gate: num_parking_gate, num_parking_ga_ramp: num_parking_ga_ramp, num_parking_cargo: num_parking_cargo, num_parking_mil_cargo: num_parking_mil_cargo, num_parking_mil_combat: num_parking_mil_combat, num_approach: num_approach, num_runway_hard: num_runway_hard, num_runway_soft: num_runway_soft, num_runway_water: num_runway_water, num_runway_light: num_runway_light, num_runway_end_closed: num_runway_end_closed, num_runway_end_vasi: num_runway_end_vasi, num_runway_end_als: num_runway_end_als, num_runway_end_ils: num_runway_end_ils, num_apron: num_apron, num_taxi_path: num_taxi_path, num_helipad: num_helipad, num_jetway: num_jetway, num_starts: num_starts, longest_runway_length: longest_runway_length, longest_runway_width: longest_runway_width, longest_runway_heading: longest_runway_heading, longest_runway_surface: longest_runway_surface, num_runways: num_runways, largest_parking_ramp: largest_parking_ramp, largest_parking_gate: largest_parking_gate, rating: rating, is_3d: is_3d, scenery_local_path: scenery_local_path, bgl_filename: bgl_filename, left_lonx: left_lonx, top_laty: top_laty, right_lonx: right_lonx, bottom_laty: bottom_laty, mag_var: mag_var, tower_altitude: tower_altitude, tower_lonx: tower_lonx, tower_laty: tower_laty, transition_altitude: transition_altitude, altitude: altitude, lonx: lonx, laty: laty)
                    
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    
    func asyncReadOtherAirportForInfo(icaoCode ident: String, completionHandler: @escaping ([OtherAirport]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [OtherAirport]()
            let query = "select * from airport where ident='\(ident)';"
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    
                    var ident: String? = nil
                    var icao: String? = nil
                    var iata: String? = nil
                    var xpident: String? = nil
                    var name: String? = nil
                    var city: String? = nil
                    var state: String? = nil
                    var country: String? = nil
                    var region: String? = nil
                    var longest_runway_surface: String? = nil
                    var largest_parking_ramp: String? = nil
                    var largest_parking_gate: String? = nil
                    var scenery_local_path: String? = nil
                    var bgl_filename: String? = nil
                    
                    
                    let airport_id = Int(sqlite3_column_int(statement, 0))
                    let file_id = Int(sqlite3_column_int(statement, 1))
                    if let cString = sqlite3_column_text(statement, 2) {
                        ident = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 3) {
                        icao = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 4) {
                        iata = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 5) {
                        xpident = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 6) {
                        name = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 7) {
                        city = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 8) {
                        state = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 9) {
                        country = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 10) {
                        region = String(describing: String(cString: cString))
                    }
                    let flatten = Int(sqlite3_column_int(statement, 11))
                    let fuel_flags = Int(sqlite3_column_int(statement, 12))
                    let has_avgas = Int(sqlite3_column_int(statement, 13))
                    let has_jetfuel = Int(sqlite3_column_int(statement, 14))
                    let has_tower_object = Int(sqlite3_column_int(statement, 15))
                    let tower_frequency = Int(sqlite3_column_int(statement, 16))
                    let atis_frequency = Int(sqlite3_column_int(statement, 17))
                    let awos_frequency = Int(sqlite3_column_int(statement, 18))
                    let asos_frequency = Int(sqlite3_column_int(statement, 19))
                    let unicom_frequency = Int(sqlite3_column_int(statement, 20))
                    let is_closed = Int(sqlite3_column_int(statement, 21))
                    let is_military = Int(sqlite3_column_int(statement, 22))
                    let is_addon = Int(sqlite3_column_int(statement, 23))
                    let num_com = Int(sqlite3_column_int(statement, 24))
                    let num_parking_gate = Int(sqlite3_column_int(statement, 25))
                    let num_parking_ga_ramp = Int(sqlite3_column_int(statement, 26))
                    let num_parking_cargo = Int(sqlite3_column_int(statement, 27))
                    let num_parking_mil_cargo = Int(sqlite3_column_int(statement, 28))
                    let num_parking_mil_combat = Int(sqlite3_column_int(statement, 29))
                    let num_approach = Int(sqlite3_column_int(statement, 30))
                    let num_runway_hard = Int(sqlite3_column_int(statement, 31))
                    let num_runway_soft = Int(sqlite3_column_int(statement, 32))
                    let num_runway_water = Int(sqlite3_column_int(statement, 33))
                    let num_runway_light = Int(sqlite3_column_int(statement, 34))
                    let num_runway_end_closed = Int(sqlite3_column_int(statement, 35))
                    let num_runway_end_vasi = Int(sqlite3_column_int(statement, 36))
                    let num_runway_end_als = Int(sqlite3_column_int(statement, 37))
                    let num_runway_end_ils = Int(sqlite3_column_int(statement, 38))
                    let num_apron = Int(sqlite3_column_int(statement, 39))
                    let num_taxi_path = Int(sqlite3_column_int(statement, 40))
                    let num_helipad = Int(sqlite3_column_int(statement, 41))
                    let num_jetway = Int(sqlite3_column_int(statement, 42))
                    let num_starts = Int(sqlite3_column_int(statement, 43))
                    let longest_runway_length = Int(sqlite3_column_int(statement, 44))
                    let longest_runway_width = Int(sqlite3_column_int(statement, 45))
                    let longest_runway_heading = Double(sqlite3_column_double(statement, 46))
                    if let cString = sqlite3_column_text(statement, 47) {
                        longest_runway_surface = String(describing: String(cString: cString))
                    }
                    let num_runways = Int(sqlite3_column_int(statement, 48))
                    if let cString = sqlite3_column_text(statement, 49) {
                        largest_parking_ramp = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 50) {
                        largest_parking_gate = String(describing: String(cString: cString))
                    }
                    let rating = Int(sqlite3_column_int(statement, 51))
                    let is_3d = Int(sqlite3_column_int(statement, 52))
                    if let cString = sqlite3_column_text(statement, 53) {
                        scenery_local_path = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 54) {
                        bgl_filename = String(describing: String(cString: cString))
                    }
                    let left_lonx = Double(sqlite3_column_double(statement, 55))
                    let top_laty = Double(sqlite3_column_double(statement, 56))
                    let right_lonx = Double(sqlite3_column_double(statement, 57))
                    let bottom_laty = Double(sqlite3_column_double(statement, 58))
                    let mag_var = Double(sqlite3_column_double(statement, 59))
                    let tower_altitude = Int(sqlite3_column_int(statement, 60))
                    let tower_lonx = Double(sqlite3_column_double(statement, 61))
                    let tower_laty = Double(sqlite3_column_double(statement, 62))
                    let transition_altitude = Int(sqlite3_column_int(statement, 63))
                    let altitude = Int(sqlite3_column_int(statement, 64))
                    let lonx = Double(sqlite3_column_double(statement, 65))
                    let laty = Double(sqlite3_column_double(statement, 66))
                    
                    
                    let model = OtherAirport(title: name, subtitle: icao, airport_id: airport_id, file_id: file_id, ident: ident, icao: icao, iata: iata, xpident: xpident, name: name, city: city, state: state, country: country, region: region, flatten: flatten, fuel_flags: fuel_flags, has_avgas: has_avgas, has_jetfuel: has_jetfuel, has_tower_object: has_tower_object, tower_frequency: tower_frequency, atis_frequency: atis_frequency, awos_frequency: awos_frequency, asos_frequency: asos_frequency, unicom_frequency: unicom_frequency, is_closed: is_closed, is_military: is_military, is_addon: is_addon, num_com: num_com, num_parking_gate: num_parking_gate, num_parking_ga_ramp: num_parking_ga_ramp, num_parking_cargo: num_parking_cargo, num_parking_mil_cargo: num_parking_mil_cargo, num_parking_mil_combat: num_parking_mil_combat, num_approach: num_approach, num_runway_hard: num_runway_hard, num_runway_soft: num_runway_soft, num_runway_water: num_runway_water, num_runway_light: num_runway_light, num_runway_end_closed: num_runway_end_closed, num_runway_end_vasi: num_runway_end_vasi, num_runway_end_als: num_runway_end_als, num_runway_end_ils: num_runway_end_ils, num_apron: num_apron, num_taxi_path: num_taxi_path, num_helipad: num_helipad, num_jetway: num_jetway, num_starts: num_starts, longest_runway_length: longest_runway_length, longest_runway_width: longest_runway_width, longest_runway_heading: longest_runway_heading, longest_runway_surface: longest_runway_surface, num_runways: num_runways, largest_parking_ramp: largest_parking_ramp, largest_parking_gate: largest_parking_gate, rating: rating, is_3d: is_3d, scenery_local_path: scenery_local_path, bgl_filename: bgl_filename, left_lonx: left_lonx, top_laty: top_laty, right_lonx: right_lonx, bottom_laty: bottom_laty, mag_var: mag_var, tower_altitude: tower_altitude, tower_lonx: tower_lonx, tower_laty: tower_laty, transition_altitude: transition_altitude, altitude: altitude, lonx: lonx, laty: laty)
                    
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    func readRunwayForInfo(icaoCode ident: String) -> [Runway] {
        let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
        var mainList = [Runway]()
        let query = "select runway_id,primary_lonx,primary_laty,secondary_lonx,secondary_laty,runway.lonx,runway.laty,name,surface,length,width,runway.altitude,app_light_system_type,ils_ident,end_type,has_end_lights,has_touchdown_lights,blast_pad from runway,runway_end where (runway.primary_end_id = runway_end.runway_end_id or runway.secondary_end_id = runway_end.runway_end_id) and runway.airport_id = (select airport_id from airport where ident='\(ident)') order by name;"
        var statement: OpaquePointer? = nil
        
        
        if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                
                var name: String? = nil
                var surface: String? = nil
                var app_light_system_type: String? = nil
                var ils_ident: String? = nil
                var end_type: String? = nil
                
                
                let runway_id = Int(sqlite3_column_int(statement, 0))
                let primary_lonx = Double(sqlite3_column_double(statement, 1))
                let primary_laty = Double(sqlite3_column_double(statement, 2))
                let secondary_lonx = Double(sqlite3_column_double(statement, 3))
                let secondary_laty = Double(sqlite3_column_double(statement, 4))
                let lonx = Double(sqlite3_column_double(statement, 5))
                let laty = Double(sqlite3_column_double(statement, 6))
                if let cString = sqlite3_column_text(statement, 7) {
                    name = String(describing: String(cString: cString))
                }
                if let cString = sqlite3_column_text(statement, 8) {
                    surface = String(describing: String(cString: cString))
                }
                let length = Int(sqlite3_column_int(statement, 9))
                let width = Int(sqlite3_column_int(statement, 10))
                let altitude = Int(sqlite3_column_int(statement, 11))
                if let cString = sqlite3_column_text(statement, 12) {
                    app_light_system_type = String(describing: String(cString: cString))
                }
                if let cString = sqlite3_column_text(statement, 13) {
                    ils_ident = String(describing: String(cString: cString))
                }
                if let cString = sqlite3_column_text(statement, 14) {
                    end_type = String(describing: String(cString: cString))
                }
                let has_end_lights = Int(sqlite3_column_int(statement, 15))
                let has_touchdown_lights = Int(sqlite3_column_int(statement, 16))
                let blast_pad = Int(sqlite3_column_int(statement, 17))
                
                
                let model = Runway(runway_id: runway_id, primary_lonx: primary_lonx, primary_laty: primary_laty, secondary_lonx: secondary_lonx, secondary_laty: secondary_laty, lonx: lonx, laty: laty, name: name, surface: surface, length: length, width: width, altitude: altitude, app_light_system_type: app_light_system_type, ils_ident: ils_ident, end_type: end_type, has_end_lights: has_end_lights, has_touchdown_lights: has_touchdown_lights, blast_pad: blast_pad)
                
                mainList.append(model)
            }
        } else {
            print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
        }
        sqlite3_finalize(statement)
        sqlite3_close(dbOpaquePointer)
        return mainList
        
    }
    
    func asyncSearchAirport(name: String, icao: String, city: String, state: String, region: String, completionHandler: @escaping (_ mainList: [Airport]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [Airport]()
            var query: String = "select * from airport where "
            if !name.isEmpty {
                query += "airport.name like '\(name)%' and "
            }
            if !icao.isEmpty {
                query += "airport.ident like '\(icao)%' and "
            }
            if !city.isEmpty {
                query += "airport.city like '\(city)%' and "
            }
            if !state.isEmpty {
                query += "airport.state like '\(state)%' and "
            }
            if !region.isEmpty {
                query += "airport.region like '\(region)%' and "
            }
            query = query[0..<query.count - 5]
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    
                    var ident: String? = nil
                    var icao: String? = nil
                    var iata: String? = nil
                    var xpident: String? = nil
                    var name: String? = nil
                    var city: String? = nil
                    var state: String? = nil
                    var country: String? = nil
                    var region: String? = nil
                    var longest_runway_surface: String? = nil
                    var largest_parking_ramp: String? = nil
                    var largest_parking_gate: String? = nil
                    var scenery_local_path: String? = nil
                    var bgl_filename: String? = nil
                    
                    
                    let airport_id = Int(sqlite3_column_int(statement, 0))
                    let file_id = Int(sqlite3_column_int(statement, 1))
                    if let cString = sqlite3_column_text(statement, 2) {
                        ident = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 3) {
                        icao = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 4) {
                        iata = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 5) {
                        xpident = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 6) {
                        name = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 7) {
                        city = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 8) {
                        state = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 9) {
                        country = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 10) {
                        region = String(describing: String(cString: cString))
                    }
                    let flatten = Int(sqlite3_column_int(statement, 11))
                    let fuel_flags = Int(sqlite3_column_int(statement, 12))
                    let has_avgas = Int(sqlite3_column_int(statement, 13))
                    let has_jetfuel = Int(sqlite3_column_int(statement, 14))
                    let has_tower_object = Int(sqlite3_column_int(statement, 15))
                    let tower_frequency = Int(sqlite3_column_int(statement, 16))
                    let atis_frequency = Int(sqlite3_column_int(statement, 17))
                    let awos_frequency = Int(sqlite3_column_int(statement, 18))
                    let asos_frequency = Int(sqlite3_column_int(statement, 19))
                    let unicom_frequency = Int(sqlite3_column_int(statement, 20))
                    let is_closed = Int(sqlite3_column_int(statement, 21))
                    let is_military = Int(sqlite3_column_int(statement, 22))
                    let is_addon = Int(sqlite3_column_int(statement, 23))
                    let num_com = Int(sqlite3_column_int(statement, 24))
                    let num_parking_gate = Int(sqlite3_column_int(statement, 25))
                    let num_parking_ga_ramp = Int(sqlite3_column_int(statement, 26))
                    let num_parking_cargo = Int(sqlite3_column_int(statement, 27))
                    let num_parking_mil_cargo = Int(sqlite3_column_int(statement, 28))
                    let num_parking_mil_combat = Int(sqlite3_column_int(statement, 29))
                    let num_approach = Int(sqlite3_column_int(statement, 30))
                    let num_runway_hard = Int(sqlite3_column_int(statement, 31))
                    let num_runway_soft = Int(sqlite3_column_int(statement, 32))
                    let num_runway_water = Int(sqlite3_column_int(statement, 33))
                    let num_runway_light = Int(sqlite3_column_int(statement, 34))
                    let num_runway_end_closed = Int(sqlite3_column_int(statement, 35))
                    let num_runway_end_vasi = Int(sqlite3_column_int(statement, 36))
                    let num_runway_end_als = Int(sqlite3_column_int(statement, 37))
                    let num_runway_end_ils = Int(sqlite3_column_int(statement, 38))
                    let num_apron = Int(sqlite3_column_int(statement, 39))
                    let num_taxi_path = Int(sqlite3_column_int(statement, 40))
                    let num_helipad = Int(sqlite3_column_int(statement, 41))
                    let num_jetway = Int(sqlite3_column_int(statement, 42))
                    let num_starts = Int(sqlite3_column_int(statement, 43))
                    let longest_runway_length = Int(sqlite3_column_int(statement, 44))
                    let longest_runway_width = Int(sqlite3_column_int(statement, 45))
                    let longest_runway_heading = Double(sqlite3_column_double(statement, 46))
                    if let cString = sqlite3_column_text(statement, 47) {
                        longest_runway_surface = String(describing: String(cString: cString))
                    }
                    let num_runways = Int(sqlite3_column_int(statement, 48))
                    if let cString = sqlite3_column_text(statement, 49) {
                        largest_parking_ramp = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 50) {
                        largest_parking_gate = String(describing: String(cString: cString))
                    }
                    let rating = Int(sqlite3_column_int(statement, 51))
                    let is_3d = Int(sqlite3_column_int(statement, 52))
                    if let cString = sqlite3_column_text(statement, 53) {
                        scenery_local_path = String(describing: String(cString: cString))
                    }
                    if let cString = sqlite3_column_text(statement, 54) {
                        bgl_filename = String(describing: String(cString: cString))
                    }
                    let left_lonx = Double(sqlite3_column_double(statement, 55))
                    let top_laty = Double(sqlite3_column_double(statement, 56))
                    let right_lonx = Double(sqlite3_column_double(statement, 57))
                    let bottom_laty = Double(sqlite3_column_double(statement, 58))
                    let mag_var = Double(sqlite3_column_double(statement, 59))
                    let tower_altitude = Int(sqlite3_column_int(statement, 60))
                    let tower_lonx = Double(sqlite3_column_double(statement, 61))
                    let tower_laty = Double(sqlite3_column_double(statement, 62))
                    let transition_altitude = Int(sqlite3_column_int(statement, 63))
                    let altitude = Int(sqlite3_column_int(statement, 64))
                    let lonx = Double(sqlite3_column_double(statement, 65))
                    let laty = Double(sqlite3_column_double(statement, 66))
                    
                    
                    let model = Airport(title: name, subtitle: icao, airport_id: airport_id, file_id: file_id, ident: ident, icao: icao, iata: iata, xpident: xpident, name: name, city: city, state: state, country: country, region: region, flatten: flatten, fuel_flags: fuel_flags, has_avgas: has_avgas, has_jetfuel: has_jetfuel, has_tower_object: has_tower_object, tower_frequency: tower_frequency, atis_frequency: atis_frequency, awos_frequency: awos_frequency, asos_frequency: asos_frequency, unicom_frequency: unicom_frequency, is_closed: is_closed, is_military: is_military, is_addon: is_addon, num_com: num_com, num_parking_gate: num_parking_gate, num_parking_ga_ramp: num_parking_ga_ramp, num_parking_cargo: num_parking_cargo, num_parking_mil_cargo: num_parking_mil_cargo, num_parking_mil_combat: num_parking_mil_combat, num_approach: num_approach, num_runway_hard: num_runway_hard, num_runway_soft: num_runway_soft, num_runway_water: num_runway_water, num_runway_light: num_runway_light, num_runway_end_closed: num_runway_end_closed, num_runway_end_vasi: num_runway_end_vasi, num_runway_end_als: num_runway_end_als, num_runway_end_ils: num_runway_end_ils, num_apron: num_apron, num_taxi_path: num_taxi_path, num_helipad: num_helipad, num_jetway: num_jetway, num_starts: num_starts, longest_runway_length: longest_runway_length, longest_runway_width: longest_runway_width, longest_runway_heading: longest_runway_heading, longest_runway_surface: longest_runway_surface, num_runways: num_runways, largest_parking_ramp: largest_parking_ramp, largest_parking_gate: largest_parking_gate, rating: rating, is_3d: is_3d, scenery_local_path: scenery_local_path, bgl_filename: bgl_filename, left_lonx: left_lonx, top_laty: top_laty, right_lonx: right_lonx, bottom_laty: bottom_laty, mag_var: mag_var, tower_altitude: tower_altitude, tower_lonx: tower_lonx, tower_laty: tower_laty, transition_altitude: transition_altitude, altitude: altitude, lonx: lonx, laty: laty, imageName: nil)
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    func asyncSearchNavForAnnotation(icao: String, region: String, completionHandler: @escaping (_ mainList: [NAV]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [NAV]()
            
            var query = "select nav_search_id,ident,lonx,laty, region, mag_var from nav_search where "
            if !icao.isEmpty {
                query += "nav_search.ident like '\(icao)%' and "
            }
            if !region.isEmpty {
                query += "nav_search.region like '\(region)%' and "
            }
            query = query[0..<query.count - 5]
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let nav_search_id = Int(sqlite3_column_int(statement, 0))
                    var ident: String? = nil
                    if let cString = sqlite3_column_text(statement, 1) {
                        ident = String(describing: String(cString: cString))
                    }
                    let lonx = Double(sqlite3_column_double(statement, 2))
                    let laty = Double(sqlite3_column_double(statement, 3))
                    var region: String? = nil
                    if let cString = sqlite3_column_text(statement, 4) {
                        region = String(describing: String(cString: cString))
                    }
                    let mag_var = Double(sqlite3_column_double(statement, 5))
                    
                    let model = NAV(nav_search_id: nav_search_id, ident: ident, lonx: lonx, laty: laty, region: region, mag_var: mag_var)
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            //TODO: Crash
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    func asyncSearchVorForAnnotation(name: String, icao: String, region: String, completionHandler: @escaping (_ mainList: [VOR]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [VOR]()
            var query = "select vor_id,ident,lonx,laty, name, region, frequency, range, mag_var, dme_only, dme_altitude, dme_lonx, dme_laty, altitude from vor where "
            if !name.isEmpty {
                query += "vor.name like '\(name)%' and "
            }
            if !icao.isEmpty {
                query += "vor.ident like '\(icao)%' and "
            }
            if !region.isEmpty {
                query += "vor.region like '\(region)%' and "
            }
            query = query[0..<query.count - 5]
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let vor_id = Int(sqlite3_column_int(statement, 0))
                    var ident: String? = nil
                    if let cString = sqlite3_column_text(statement, 1) {
                        ident = String(describing: String(cString: cString))
                    }
                    let lonx = Double(sqlite3_column_double(statement, 2))
                    let laty = Double(sqlite3_column_double(statement, 3))
                    var name: String? = nil
                    if let cString = sqlite3_column_text(statement, 4) {
                        name = String(describing: String(cString: cString))
                    }
                    var region: String? = nil
                    if let cString = sqlite3_column_text(statement, 5) {
                        region = String(describing: String(cString: cString))
                    }
                    let frequency = Int(sqlite3_column_double(statement, 6))
                    let range = Int(sqlite3_column_double(statement, 7))
                    let mag_var = Double(sqlite3_column_double(statement, 8))
                    let dme_only = Int(sqlite3_column_double(statement, 9))
                    let dme_altitude = Int(sqlite3_column_double(statement, 10))
                    let dme_lonx = Double(sqlite3_column_double(statement, 11))
                    let dme_laty = Double(sqlite3_column_double(statement, 12))
                    let altitude = Int(sqlite3_column_double(statement, 13))
                    
                    let model = VOR(vor_id: vor_id, ident: ident, lonx: lonx, laty: laty, name: name, region: region, frequency: frequency, range: range, mag_var: mag_var, dme_only: dme_only, dme_altitude: dme_altitude, dme_lonx: dme_lonx, dme_laty: dme_laty, altitude: altitude)
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            // TODO: Crash
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    func asyncSearchNdbForAnnotation(name: String, icao: String, region: String, completionHandler: @escaping (_ mainList: [NDB]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [NDB]()
            var query = "select ndb_id,ident,lonx,laty, name, region, type, frequency, range, mag_var from ndb where "
            if !name.isEmpty {
                query += "ndb.name like '\(name)%' and "
            }
            if !icao.isEmpty {
                query += "ndb.ident like '\(icao)%' and "
            }
            if !region.isEmpty {
                query += "ndb.region like '\(region)%' and "
            }
            query = query[0..<query.count - 5]
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let ndb_id = Int(sqlite3_column_int(statement, 0))
                    var ident: String? = nil
                    if let cString = sqlite3_column_text(statement, 1) {
                        ident = String(describing: String(cString: cString))
                    }
                    let lonx = Double(sqlite3_column_double(statement, 2))
                    let laty = Double(sqlite3_column_double(statement, 3))
                    var name: String? = nil
                    if let cString = sqlite3_column_text(statement, 4) {
                        name = String(describing: String(cString: cString))
                    }
                    var region: String? = nil
                    if let cString = sqlite3_column_text(statement, 5) {
                        region = String(describing: String(cString: cString))
                    }
                    var type: String? = nil
                    if let cString = sqlite3_column_text(statement, 6) {
                        type = String(describing: String(cString: cString))
                    }
                    let frequency = Int(sqlite3_column_double(statement, 7))
                    let range = Int(sqlite3_column_double(statement, 8))
                    let mag_var = Double(sqlite3_column_double(statement, 9))
                    
                    let model = NDB(ndb_id: ndb_id, ident: ident, lonx: lonx, laty: laty, name: name, region: region, type: type, frequency: frequency, range: range, mag_var: mag_var)
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            // TODO: Crash
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    func asyncSearchAirway(airway_name: String, airway_type: String, completionHandler: @escaping (_ mainList: [Airway]) -> Void) {
        DispatchQueue.global().async {
            var mainList = [Airway]()
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var query = "select airway_id,airway_name,from_lonx,from_laty,to_lonx,to_laty, airway_type, from_waypoint_id, to_waypoint_id, minimum_altitude from airway where "
            if !airway_name.isEmpty {
                query += "airway.airway_name like '\(airway_name)%' and "
            }
            if !airway_type.isEmpty {
                query += "airway.airway_type like '\(airway_type)%' and "
            }
            query = query[0..<query.count - 5]
            var statement: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    
                    let airway_id = Int(sqlite3_column_int(statement, 0))
                    var airway_name: String? = nil
                    if let cString = sqlite3_column_text(statement, 1) {
                        airway_name = String(describing: String(cString: cString))
                    }
                    let from_lonx = Double(sqlite3_column_double(statement, 2))
                    let from_laty = Double(sqlite3_column_double(statement, 3))
                    let to_lonx = Double(sqlite3_column_double(statement, 4))
                    let to_laty = Double(sqlite3_column_double(statement, 5))
                    var curr_airway_type: String? = nil
                    if let cString = sqlite3_column_text(statement, 6) {
                        curr_airway_type = String(describing: String(cString: cString))
                    }
                    let from_waypoint_id = Int(sqlite3_column_int(statement, 7))
                    let to_waypoint_id = Int(sqlite3_column_int(statement, 8))
                    let minimum_altitude = Int(sqlite3_column_int(statement, 9))
                    
                    let model = Airway(airway_id: airway_id, airway_name: airway_name, from_lonx: from_lonx, from_laty: from_laty, to_lonx: to_lonx, to_laty: to_laty, airway_type: curr_airway_type, from_waypoint_id: from_waypoint_id, to_waypoint_id: to_waypoint_id, minimum_altitude: minimum_altitude)
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    func asyncSearchILSForAnnotation(ident: String, completionHandler: @escaping (_ mainList: [ILS]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [ILS]()
            var query = "select ident,name,frequency,'range',mag_var,has_backcourse,dme_range,dme_altitude,dme_lonx, dme_laty,gs_range,gs_pitch,gs_altitude,loc_runway_name,loc_airport_ident,loc_heading,loc_width,altitude,laty,lonx from ils where "
            if !ident.isEmpty {
                query += "ils.loc_airport_ident like '\(ident)%' and "
            }
            
            query = query[0..<query.count - 5]
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    var ident: String? = nil
                    if let cString = sqlite3_column_text(statement, 0) {
                        ident = String(describing: String(cString: cString))
                    }
                    var name: String? = nil
                    if let cString = sqlite3_column_text(statement, 1) {
                        name = String(describing: String(cString: cString))
                    }
                    let frequency = Int(sqlite3_column_int(statement, 2))
                    let range = Int(sqlite3_column_int(statement, 3))
                    let mag_var = Double(sqlite3_column_double(statement, 4))
                    let has_backcourse = Int(sqlite3_column_int(statement, 5))
                    let dme_range = Int(sqlite3_column_int(statement, 6))
                    let dme_altitude = Int(sqlite3_column_int(statement, 7))
                    let dme_lonx = Double(sqlite3_column_double(statement, 8))
                    let dme_laty = Double(sqlite3_column_double(statement, 9))
                    let gs_range = Int(sqlite3_column_int(statement, 10))
                    let gs_pitch = Double(sqlite3_column_double(statement, 11))
                    let gs_altitude = Int(sqlite3_column_int(statement, 12))
                    var loc_runway_name: String? = nil
                    if let cString = sqlite3_column_text(statement, 13) {
                        loc_runway_name = String(describing: String(cString: cString))
                    }
                    var loc_airport_ident: String? = nil
                    if let cString = sqlite3_column_text(statement, 14) {
                        loc_airport_ident = String(describing: String(cString: cString))
                    }
                    let loc_heading = Double(sqlite3_column_double(statement, 15))
                    let loc_width = Double(sqlite3_column_double(statement, 16))
                    let altitude = Int(sqlite3_column_int(statement, 17))
                    let laty = Double(sqlite3_column_double(statement, 18))
                    let lonx = Double(sqlite3_column_double(statement, 19))
                    
                    let model = ILS(ident: ident, name: name, frequency: frequency, range: range, mag_var: mag_var, has_backcourse: has_backcourse, dme_range: dme_range, dme_altitude: dme_altitude, dme_lonx: dme_lonx, dme_laty: dme_laty, gs_range: gs_range, gs_pitch: gs_pitch, gs_altitude: gs_altitude, loc_runway_name: loc_runway_name, loc_airport_ident: loc_airport_ident, loc_heading: loc_heading, loc_width: loc_width, altitude: altitude, laty: laty, lonx: lonx)
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            // TODO: Crash
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    func asyncSearchRunwayOfAirport(icao: String, completionHandler: @escaping (_ mainList: [RunwayEnd]) -> Void) {
        DispatchQueue.global().async {
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var mainList = [RunwayEnd]()
            var query: String
            
            query = "select name,blast_pad,left_vasi_type,left_vasi_pitch,right_vasi_type,right_vasi_pitch,has_closed_markings,has_stol_markings,is_takeoff,is_landing,is_pattern,app_light_system_type,has_end_lights,has_reils,has_touchdown_lights,num_strobes,ils_ident,runway.heading,runway_end.laty,runway_end.lonx,surface,length,width,pattern_altitude,marking_flags,edge_light,center_light,has_center_red,runway.altitude, runway_end.end_type, runway_end.offset_threshold, runway_end.overrun from runway_end,runway where (runway_end_id = runway.primary_end_id or runway_end_id = runway.secondary_end_id) and runway_end_id in (select secondary_end_id from runway where airport_id in (select airport_id from airport where ident = '\(icao)') union select primary_end_id from runway where airport_id in (select airport_id from airport where ident = '\(icao)'));"
            var statement: OpaquePointer? = nil
            
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    var name: String? = nil
                    if let cString = sqlite3_column_text(statement, 0) {
                        name = String(describing: String(cString: cString))
                    }
                    let blast_pad: Int? = Int(sqlite3_column_int(statement, 1))
                    var left_vasi_type: String? = nil
                    if let cString = sqlite3_column_text(statement, 2) {
                        left_vasi_type = String(describing: String(cString: cString))
                    }
                    let left_vasi_pitch: Double? = Double(sqlite3_column_double(statement, 3))
                    var right_vasi_type: String? = nil
                    if let cString = sqlite3_column_text(statement, 4) {
                        right_vasi_type = String(describing: String(cString: cString))
                    }
                    let right_vasi_pitch:  Double? = Double(sqlite3_column_double(statement, 5))
                    let has_closed_markings = Int(sqlite3_column_int(statement, 6))
                    let has_stol_markings = Int(sqlite3_column_int(statement, 7))
                    let is_takeoff = Int(sqlite3_column_int(statement, 8))
                    let is_landing = Int(sqlite3_column_int(statement, 9))
                    var is_pattern: String? = nil
                    if let cString = sqlite3_column_text(statement, 10) {
                        is_pattern = String(describing: String(cString: cString))
                    }
                    var app_light_system_type: String? = nil
                    if let cString = sqlite3_column_text(statement, 11) {
                        app_light_system_type = String(describing: String(cString: cString))
                    }
                    let has_end_lights = Int(sqlite3_column_int(statement, 12))
                    let has_reils = Int(sqlite3_column_int(statement, 13))
                    let has_touchdown_lights = Int(sqlite3_column_int(statement, 14))
                    let num_strobes = Int(sqlite3_column_int(statement, 15))
                    var ils_ident: String? = nil
                    if let cString = sqlite3_column_text(statement, 16) {
                        ils_ident = String(describing: String(cString: cString))
                    }
                    let heading = Double(sqlite3_column_double(statement, 17))
                    let laty = Double(sqlite3_column_double(statement, 18))
                    let lonx = Double(sqlite3_column_double(statement, 19))
                    var surface: String? = nil
                    if let cString = sqlite3_column_text(statement, 20) {
                        surface = String(describing: String(cString: cString))
                    }
                    let length = Int(sqlite3_column_int(statement, 21))
                    let width = Int(sqlite3_column_int(statement, 22))
                    let pattern_altitude = Int(sqlite3_column_int(statement, 23))
                    let marking_flags = Int(sqlite3_column_int(statement, 24))
                    var edge_light: String? = nil
                    if let cString = sqlite3_column_text(statement, 25) {
                        edge_light = String(describing: String(cString: cString))
                    }
                    var center_light: String? = nil
                    if let cString = sqlite3_column_text(statement, 26) {
                        center_light = String(describing: String(cString: cString))
                    }
                    let has_center_red = Int(sqlite3_column_int(statement, 27))
                    let altitude = Int(sqlite3_column_int(statement, 28))
                    var end_type: String? = nil
                    if let cString = sqlite3_column_text(statement, 29) {
                        end_type = String(describing: String(cString: cString))
                    }
                    let offset_threshold = Int(sqlite3_column_int(statement, 30))
                    let overrun = Int(sqlite3_column_int(statement, 31))
                    
                    
                    let model = RunwayEnd(lonx: lonx, laty: laty, name: name, surface: surface, length: length, width: width, altitude: altitude, app_light_system_type: app_light_system_type, ils_ident: ils_ident, end_type: end_type, has_end_lights: has_end_lights, has_touchdown_lights: has_touchdown_lights, blast_pad: blast_pad, offset_threshold: offset_threshold, overrun: overrun, left_vasi_type: left_vasi_type, left_vasi_pitch: left_vasi_pitch, right_vasi_type: right_vasi_type, right_vasi_pitch: right_vasi_pitch, has_closed_markings: has_closed_markings, has_stol_markings: has_stol_markings, is_takeoff: is_takeoff, is_landing: is_landing, is_pattern: is_pattern, has_reils: has_reils, num_strobes: num_strobes, heading: heading, has_center_red: has_center_red, edge_light: edge_light, center_light: center_light, pattern_altitude: pattern_altitude, marking_flags: marking_flags)
                    
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            DBManager.closeDB()
            sqlite3_finalize(statement)
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    func asyncReadWaypointForAnnotation(waypointsStrList: [FlightPlanWayPoint], completionHandler: @escaping (_ mainList: [FlightPlanWayPoint]) -> Void) {
        DispatchQueue.global().async {
            var mainList = [FlightPlanWayPoint]()
            for point in waypointsStrList {
                if point.type == .airport {
                    let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
                    let query = "select airport_id, ident, lonx, laty, region, mag_var from airport where ident = '\(point.ident)';"
                    var statement: OpaquePointer? = nil
                    
                    if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                        while sqlite3_step(statement) == SQLITE_ROW {
                            
                            var ident:String?
                            if let cString = sqlite3_column_text(statement, 1) {
                                ident = String(describing: String(cString: cString))
                            }
                            let lonx = Double(sqlite3_column_double(statement, 2))
                            let laty = Double(sqlite3_column_double(statement, 3))
                            
                            
                            let model = FlightPlanWayPoint(laty: laty, lonx: lonx, ident: ident ?? "", type: .airport)
                            mainList.append(model)
                        }
                    } else {
                        print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
                    }
                    sqlite3_finalize(statement)
                    sqlite3_close(dbOpaquePointer)
                } else if point.type == .waypoint {
                    let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
                    let query = "select waypoint_id, ident, lonx, laty, region, type, num_victor_airway, num_jet_airway, mag_var from waypoint where ident = '\(point.ident)' and abs(waypoint.laty - \(point.laty)) < 0.00001 and abs(waypoint.lonx - \(point.lonx)) < 0.00001;"
                    var statement: OpaquePointer? = nil
                    
                    if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                        while sqlite3_step(statement) == SQLITE_ROW {
                            
                            var ident:String?
                            if let cString = sqlite3_column_text(statement, 1) {
                                ident = String(describing: String(cString: cString))
                            }
                            let lonx = Double(sqlite3_column_double(statement, 2))
                            let laty = Double(sqlite3_column_double(statement, 3))
                            
                            let model = FlightPlanWayPoint(laty: laty, lonx: lonx, ident: ident ?? "", type: .waypoint)
                            mainList.append(model)
                        }
                    } else {
                        print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
                    }
                    sqlite3_finalize(statement)
                    sqlite3_close(dbOpaquePointer)
                }
                
            }
            completionHandler(mainList)
        }
    }
    
    
    func asyncSearchWaypoint(ident: String, completionHandler: @escaping (_ mainList: [Waypoint]) -> Void) {
        DispatchQueue.global().async {
            var mainList = [Waypoint]()
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            let query = "select waypoint_id, ident, lonx, laty, region, type, num_victor_airway, num_jet_airway, mag_var from waypoint where ident like '\(ident)%';"
            var statement: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    
                    let waypoint_id = Int(sqlite3_column_int(statement, 0))
                    var ident:String?
                    if let cString = sqlite3_column_text(statement, 1) {
                        ident = String(describing: String(cString: cString))
                    }
                    let lonx = Double(sqlite3_column_double(statement, 2))
                    let laty = Double(sqlite3_column_double(statement, 3))
                    
                    var region:String?
                    if let cString = sqlite3_column_text(statement, 4) {
                        region = String(describing: String(cString: cString))
                    }
                    var type:String?
                    if let cString = sqlite3_column_text(statement, 5) {
                        type = String(describing: String(cString: cString))
                    }
                    let num_vector_airway = Int(sqlite3_column_double(statement, 6))
                    let num_jet_airway = Int(sqlite3_column_double(statement, 7))
                    let mag_var = Double(sqlite3_column_double(statement, 8))
                    
                    let model = Waypoint(title: ident, waypoint_id: waypoint_id, ident: ident, lonx: lonx, laty: laty, region: region, type: type, num_vector_airway: num_vector_airway, num_jet_airway: num_jet_airway, mag_var: mag_var)
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    func asyncSearchNextAirway(lastIdent: String, completionHandler: @escaping (_ mainList: [Airway]) -> Void) {
        DispatchQueue.global().async {
            var mainList = [Airway]()
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            let query = "select airway_id,airway_name,from_lonx,from_laty,to_lonx,to_laty from airway where from_waypoint_id in (select waypoint_id from  waypoint where ident = '\(lastIdent)');"
            var statement: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    
                    let airway_id = Int(sqlite3_column_int(statement, 0))
                    var airway_name: String? = nil
                    if let cString = sqlite3_column_text(statement, 1) {
                        airway_name = String(describing: String(cString: cString))
                    }
                    let from_lonx = Double(sqlite3_column_double(statement, 2))
                    let from_laty = Double(sqlite3_column_double(statement, 3))
                    let to_lonx = Double(sqlite3_column_double(statement, 4))
                    let to_laty = Double(sqlite3_column_double(statement, 5))
                    
                    let model = Airway(airway_id: airway_id, airway_name: airway_name, from_lonx: from_lonx, from_laty: from_laty, to_lonx: to_lonx, to_laty: to_laty)
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    
    func asyncSearchNextWaypoint(lastAirwayName: String, lastWaypointIdent: String,completionHandler: @escaping (_ mainList: [Waypoint]) -> Void) {
        DispatchQueue.global().async {
            var mainList = [Waypoint]()
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            let query = "select waypoint_id, ident, lonx, laty, region, type, num_victor_airway, num_jet_airway, mag_var from waypoint where waypoint_id in (select to_waypoint_id from airway where airway_name = '\(lastAirwayName)' and airway.from_waypoint_id in (select waypoint_id from waypoint where waypoint.ident = '\(lastWaypointIdent)'));"
            var statement: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    
                    let waypoint_id = Int(sqlite3_column_int(statement, 0))
                    var ident:String?
                    if let cString = sqlite3_column_text(statement, 1) {
                        ident = String(describing: String(cString: cString))
                    }
                    let lonx = Double(sqlite3_column_double(statement, 2))
                    let laty = Double(sqlite3_column_double(statement, 3))
                    
                    var region:String?
                    if let cString = sqlite3_column_text(statement, 4) {
                        region = String(describing: String(cString: cString))
                    }
                    var type:String?
                    if let cString = sqlite3_column_text(statement, 5) {
                        type = String(describing: String(cString: cString))
                    }
                    let num_vector_airway = Int(sqlite3_column_double(statement, 6))
                    let num_jet_airway = Int(sqlite3_column_double(statement, 7))
                    let mag_var = Double(sqlite3_column_double(statement, 8))
                    
                    let model = Waypoint(title: ident, waypoint_id: waypoint_id, ident: ident, lonx: lonx, laty: laty, region: region, type: type, num_vector_airway: num_vector_airway, num_jet_airway: num_jet_airway, mag_var: mag_var)
                    mainList.append(model)
                }
            } else {
                print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
            }
            sqlite3_finalize(statement)
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    
    func asyncFetchFlightPlanAirway(flightPlanWayPoints:[FlightPlanWayPoint], _ completionHandler: @escaping ([LineChartDataPoint]) -> Void) {
        DispatchQueue.global().async {
            var mainList: [LineChartDataPoint] = []
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            var prevWayPoint:FlightPlanWayPoint?
            for flightPlanWayPoint in flightPlanWayPoints {
                if flightPlanWayPoint.type == FlightPlanWayPoint.FlightPlanWayPointType.airway,
                   let id = flightPlanWayPoint.digitID,
                   let prevWayPoint = prevWayPoint {
                    let query = "select minimum_altitude from airway where airway_id = \(id);"
                    var statement: OpaquePointer? = nil
                    
                    if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                        while sqlite3_step(statement) == SQLITE_ROW {
                            
                            let minimum_altitude = Int(sqlite3_column_int(statement, 0))
                            
                            mainList.append(LineChartDataPoint(value: Double(minimum_altitude), xAxisLabel: prevWayPoint.ident))
                        }
                    } else {
                        print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
                    }
                    sqlite3_finalize(statement)
                } else if flightPlanWayPoint.type == FlightPlanWayPoint.FlightPlanWayPointType.direct, prevWayPoint?.ident != flightPlanWayPoints.first?.ident {
                    mainList.append(LineChartDataPoint(value: mainList.last?.value ?? 0, xAxisLabel: prevWayPoint?.ident))
                } else if flightPlanWayPoint.type == FlightPlanWayPoint.FlightPlanWayPointType.airport {
                    let query = "select altitude from airport where ident = '\(flightPlanWayPoint.ident)';"
                    var statement: OpaquePointer? = nil
                    if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                        while sqlite3_step(statement) == SQLITE_ROW {
                            let minimum_altitude = Int(sqlite3_column_int(statement, 0))
                            mainList.append(LineChartDataPoint(value: Double(minimum_altitude), xAxisLabel: flightPlanWayPoint.ident))
                        }
                    } else {
                        print(sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil))
                    }
                    sqlite3_finalize(statement)
                    prevWayPoint = flightPlanWayPoint
                }
                else {
                    prevWayPoint = flightPlanWayPoint
                }
            }
            sqlite3_close(dbOpaquePointer)
            completionHandler(mainList)
        }
    }
    func asyncFetchAirportCount(city:String, _ completionHandler: @escaping (Int) -> Void) {
        DispatchQueue.global().async {
            var mainList: [Int] = []
            let dbOpaquePointer: OpaquePointer? = DBManager.connectDB()
            let query = "select count(airport_id) from airport where city = '\(city)';"
            var statement: OpaquePointer? = nil
            if sqlite3_prepare_v2(dbOpaquePointer, query, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let count = Int(sqlite3_column_int(statement, 0))
                    mainList.append(count)
                }
            }
            sqlite3_finalize(statement)
            sqlite3_close(dbOpaquePointer)
            if mainList.count > 0 {
                completionHandler(mainList[0])
            } else {
                completionHandler(0)
            }
        }
    }
}
