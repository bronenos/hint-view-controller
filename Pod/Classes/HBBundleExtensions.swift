//
//  HBBundleExtensions.swift
//  Pods
//
//  Created by Stan Potemkin on 10/01/2017.
//
//

import Foundation

extension Bundle {
    static func frameworkFilePath(_ name: String) -> String {
        if let frameworksPath = Bundle.main.privateFrameworksURL {
            let frameworkPath = frameworksPath.appendingPathComponent("HBHintViewController.framework")
            return frameworkPath.appendingPathComponent(name).path
        }
        else {
            return name
        }
    }
}
