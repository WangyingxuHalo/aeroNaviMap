//
//  String.swift
//  AeroNaviMap
//
//  Created by Yuankai Zhu on 10/25/22.
//

import Foundation

extension String {
    subscript(_ indexs: PartialRangeThrough<Int>) -> String {
        return String(self[startIndex...index(startIndex, offsetBy: indexs.upperBound)])
    }

    subscript(_ indexs: ClosedRange<Int>) -> String {
        return String(self[index(startIndex, offsetBy: indexs.lowerBound)...index(startIndex, offsetBy: indexs.upperBound)])
    }

    subscript(_ indexs: PartialRangeUpTo<Int>) -> String {
        return String(self[startIndex..<index(startIndex, offsetBy: indexs.upperBound)])
    }

    subscript(_ indexs: Range<Int>) -> String {
        return String(self[index(startIndex, offsetBy: indexs.lowerBound)..<index(startIndex, offsetBy: indexs.upperBound)])
    }

    subscript(_ indexs: PartialRangeFrom<Int>) -> String {
        return String(self[index(startIndex, offsetBy: indexs.lowerBound)..<endIndex])
    }
}
