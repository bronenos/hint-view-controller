//
//  HBHintCommon.swift
//  Pods
//
//  Created by Stan Potemkin on 10/01/2017.
//
//

import Foundation

public typealias HBHintLayoutProvider = (CGSize) -> CGRect

@objc public enum HBHintHoleType: Int {
    case ellipse
    case rectangle
}

enum HoleElement {
    case ellipse(HBHintLayoutProvider)
    case rectangle(HBHintLayoutProvider)
}

enum HintElement {
    case imageView(UIImageView, HBHintLayoutProvider)
    case label(UILabel, HBHintLayoutProvider)
}
