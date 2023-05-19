//
//  DBManager.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 10/19/22.
//

import Foundation
import SQLite3

class DBManager {
    static let dbPointer: OpaquePointer? = nil
    static let copyToPath: String = "Documents.AeroNaviMap"

    static func connectDB() -> OpaquePointer? {

        let fileManager = FileManager.default
        let dbFileURLs = fileManager.urls(for: .documentDirectory,
                in: .userDomainMask)
        guard !dbFileURLs.isEmpty,
              let dbURL = dbFileURLs.first?.appendingPathComponent(copyToPath)
        else {
            print("Could not find dbFileURLs")
            return nil
        }
        let isReachable = try? dbURL.checkResourceIsReachable()
        if !(isReachable ?? false) {
            let documentsURL = Bundle.main.url(forResource: copyToPath, withExtension: "sqlite")
            do {
                if let filePath = documentsURL?.path {
                    try fileManager.copyItem(atPath: filePath, toPath: dbURL.path)
                }
            } catch {
                print("Couldn't copy file to sandbox.")
            }
        }

        var dbPointer: OpaquePointer? = nil

        if sqlite3_open(dbURL.path, &dbPointer) != SQLITE_OK {
            print("Error to connect DB")
            return nil
        } else {
            return dbPointer
        }
    }

    static func closeDB() {
        sqlite3_close(dbPointer)
    }
}
