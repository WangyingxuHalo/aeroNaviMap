//
//  HomeLoadingView.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/26/22.
//

import SwiftUI

struct HomeLoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("AeroNaviMap")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
            Image("icon")
            ProgressView()
                    .tint(.white)
            Spacer()
            Text("Loading Essential Tools ...")
                    .foregroundColor(.white)
            Spacer()
        }
    }
}
