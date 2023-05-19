//
//  MapboxTestView.swift
//  aeronavimap
//
//  Created by Yuankai Zhu on 10/18/22.
//

import SwiftUI

struct MapboxTestView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = MapboxTestViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
