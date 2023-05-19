//
//  NdbGeneralInfoTab.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/4/22.
//

import SwiftUI

struct NdbGeneralInfoTab: View {
    @ObservedObject var ndbInfoPanelViewModel: NdbInfoPanelViewModel
    @Environment(\.colorScheme) var themeScheme
    let sec1Columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        ScrollView {
            if let ident = ndbInfoPanelViewModel.ndb.ident {
                HStack {
                    Image("ndb")
                    Text(ident)
                        .font(.title)
                }
            }
            VStack {
                LazyVGrid(columns: sec1Columns) {
                    if let name = ndbInfoPanelViewModel.ndb.name {
                        Text("Name")
                        Text(name);
                    }
                    if let region = ndbInfoPanelViewModel.ndb.region {
                        Text("Region")
                        Text(region);
                    }
                    if let type = ndbInfoPanelViewModel.ndb.type {
                        Text("Type")
                        Text(type);
                    }
                    if let frequency = ndbInfoPanelViewModel.ndb.frequency {
                        Text("Frequency")
                        Text("\(frequency)");
                    }
                    if let range = ndbInfoPanelViewModel.ndb.range {
                        Text("Range")
                        Text("\(range)");
                    }
                    if let mag_var = ndbInfoPanelViewModel.ndb.mag_var {
                        Text("Magnetic Declination")
                        Text("\(mag_var)");
                    }
                    if let lonx = ndbInfoPanelViewModel.ndb.lonx,
                        let laty = ndbInfoPanelViewModel.ndb.laty {
                        Text("Coordinate")
                        Text("\(laty), \(lonx)");
                    }
                }
                
            }
        }
                .padding()
    }
}
