//
//  ILSSearchTabViewModel.swift
//  AeroNaviMap
//
//  Created by 王迎旭 on 11/12/22.
//

import Foundation

class ILSSearchTabViewModel: ObservableObject {
    @Published var ident: String = ""
    @Published var searchResults: [ILS] = []
    @Published var isSearchInvalid = true
    var timer: Timer?

    func searchILS() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false, block: { (_) in
            if self.ident.count < 4 {
                self.isSearchInvalid = true
                self.searchResults = []
            } else {
                DBReader.shared.asyncSearchILSForAnnotation(ident: self.ident) { mainList in
                    DispatchQueue.main.async {
                        self.isSearchInvalid = false
                        self.searchResults = mainList
                    }
                }
            }
        })
    }
}
