//
//  UIColor.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/26/22.
//

import SwiftUI

extension UIColor {
    static let theme = ThemeColor()
}

struct ThemeColor {
    let darkBlue = UIColor(red: 0, green: 48 / 255, blue: 135 / 255, alpha: 1.0)
    let grayBackground = UIColor(red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1.0)
    let blackBackground = UIColor(red: 28 / 255, green: 28 / 255, blue: 30 / 255, alpha: 1.0)
    let darkGreen = UIColor(red: 23 / 255, green: 97 / 255, blue: 3 / 255, alpha: 1.0)
}
