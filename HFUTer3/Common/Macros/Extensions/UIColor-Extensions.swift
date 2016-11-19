//
//  Extensions.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/15.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

// MARK: - UIColor
// MARK: - UIColor
extension UIColor {
    /**
     Create non-autoreleased color with in the given hex string. Alpha will be set as 1 by default.
     - parameter hexString: The hex string, with or without the hash character.
     - returns: A color with the given hex string.
     */
    convenience init(hexString: String) {
        self.init(hexString: hexString, alpha: 1.0)
    }
    
    /**
     Create non-autoreleased color with in the given hex string and alpha.
     - parameter hexString: The hex string, with or without the hash character.
     - parameter alpha: The alpha value, a floating value between 0 and 1.
     - returns: A color with the given hex string and alpha.
     */
    convenience init(hexString: String, alpha: Float) {
        var hex = hexString
        
        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            hex = hex.substring(from: hex.characters.index(hex.startIndex, offsetBy: 1))
        }
        
        if (hex.range(of: "(^[0-9A-Fa-f]{6}$)|(^[0-9A-Fa-f]{3}$)", options: .regularExpression) != nil) {
            
            // Deal with 3 character Hex strings
            if hex.characters.count == 3 {
                let redHex   = hex.substring(to: hex.characters.index(hex.startIndex, offsetBy: 1))
                let greenHex = hex.substring(with: hex.characters.index(hex.startIndex, offsetBy: 1)..<hex.characters.index(hex.startIndex, offsetBy: 2))
                //                    Range<String.Index>(start: hex.startIndex.advancedBy(1), end: hex.startIndex.advancedBy(2)))
                let blueHex  = hex.substring(from: hex.characters.index(hex.startIndex, offsetBy: 2))
                
                hex = redHex + redHex + greenHex + greenHex + blueHex + blueHex
            }
            
            let redHex = hex.substring(to: hex.characters.index(hex.startIndex, offsetBy: 2))
            let greenHex = hex.substring(with: hex.characters.index(hex.startIndex, offsetBy: 2)..<hex.characters.index(hex.startIndex, offsetBy: 4))
            //                Range<String.Index>(start: hex.startIndex.advancedBy(2), end: hex.startIndex.advancedBy(4)))
            let blueHex = hex.substring(with: hex.characters.index(hex.startIndex, offsetBy: 4)..<hex.characters.index(hex.startIndex, offsetBy: 6))
            //                Range<String.Index>(start: hex.startIndex.advancedBy(4), end: hex.startIndex.advancedBy(6)))
            
            var redInt:   CUnsignedInt = 0
            var greenInt: CUnsignedInt = 0
            var blueInt:  CUnsignedInt = 0
            
            Scanner(string: redHex).scanHexInt32(&redInt)
            Scanner(string: greenHex).scanHexInt32(&greenInt)
            Scanner(string: blueHex).scanHexInt32(&blueInt)
            
            self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: CGFloat(alpha))
        }
        else {
            // Note:
            // The swift 1.1 compiler is currently unable to destroy partially initialized classes in all cases,
            // so it disallows formation of a situation where it would have to.  We consider this a bug to be fixed
            // in future releases, not a feature. -- Apple Forum
            self.init(red: CGFloat(0) / 255.0, green: CGFloat(0) / 255.0, blue: CGFloat(0) / 255.0, alpha: CGFloat(0.5))
        }
    }
    
    /**
     Create non-autoreleased color with in the given hex value. Alpha will be set as 1 by default.
     - parameter hex: The hex value. For example: 0xff8942 (no quotation).
     - returns: A color with the given hex value
     */
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    /**
     Create non-autoreleased color with in the given hex value and alpha
     - parameter hex: The hex value. For example: 0xff8942 (no quotation).
     - parameter alpha: The alpha value, a floating value between 0 and 1.
     - returns: color with the given hex value and alpha
     */
    public convenience init(hex: Int, alpha: Float) {
        var hexString = String(format: "%2X", hex)
        let leadingZerosString = String(repeating: "0", count: 6 - hexString.characters.count)
        hexString = leadingZerosString + hexString
        self.init(hexString: hexString as String , alpha: alpha)
    }
}

