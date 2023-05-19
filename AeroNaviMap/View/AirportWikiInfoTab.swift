//
//  AirportWikiInfoTab.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 11/20/22.
//

import SwiftUI
import MapboxMaps

struct AirportWikiInfoTab: View {
    @ObservedObject var airportInfoPanelViewModel: AirportInfoPanelViewModel
    var body: some View {
        VStack {
            if airportInfoPanelViewModel.isResultReturned {
                if let wikiUrl = airportInfoPanelViewModel.wikiUrl {
                    SafariView(url: wikiUrl)
                } else {
                    Text("No Related Found.")
                }
            } else {
                VStack {
                    ProgressView()
                    Text("Loading...")
                }
            }
        }
    }
}
