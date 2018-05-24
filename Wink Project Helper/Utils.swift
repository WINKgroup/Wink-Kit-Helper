//
//  Utils.swift
//  Wink Project Helper
//
//  Created by Rico Crescenzio on 30/03/18.
//  Copyright © 2018 wink srl. All rights reserved.
//

import Foundation
import Cocoa

extension String  {
    func conformsTo(pattern: String) -> Bool {
        let pattern = NSPredicate(format:"SELF MATCHES %@", pattern)
        return pattern.evaluate(with: self)
    }
}

extension NSColor {
    class func fromHex(hex: Int, alpha: Float) -> NSColor {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        return NSColor(calibratedRed: red, green: green, blue: blue, alpha: 1.0)
    }
    
    class func fromHexString(hex: String, alpha: Float) -> NSColor? {
        // Handle two types of literals: 0x and # prefixed
        var cleanedString = ""
        if hex.hasPrefix("0x") {
            cleanedString = hex.replacingOccurrences(of: "0x", with: "")
        } else if hex.hasPrefix("#") {
            cleanedString = hex.replacingOccurrences(of: "#", with: "")
        }
        // Ensure it only contains valid hex characters 0
        let validHexPattern = "[a-fA-F0-9]+"
        if cleanedString.conformsTo(pattern: validHexPattern) {
            var theInt: UInt32 = 0
            let scanner = Scanner(string: cleanedString)
            scanner.scanHexInt32(&theInt)
            let red = CGFloat((theInt & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((theInt & 0xFF00) >> 8) / 255.0
            let blue = CGFloat((theInt & 0xFF)) / 255.0
            return NSColor(calibratedRed: red, green: green, blue: blue, alpha: 1.0)
        } else {
            return nil
        }
    }
}

