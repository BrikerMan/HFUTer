//
//  String-Extensions.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

extension String {
    
    // MARK: - 计算UI
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    
    // MARK: - JSON处理
    func jsonToArray() -> [AnyObject]? {
        do {
            if let data = self.data(using: String.Encoding.utf8) {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
                if let array = json as? [AnyObject] {
                    return array
                }
            }
            return nil
        }
        catch {
            return nil
        }
    }
    
    func jsonToDic() -> [String: AnyObject]? {
        do {
            let dic = try JSONSerialization.jsonObject(with: self.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: AnyObject]
            return dic
        }
        catch {
            return nil
        }
    }
    
    //
    //    // MARK: - 验证
    //    //To check text field or String is blank or not
    //    var isBlank: Bool {
    //        get {
    //            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
    //            return trimmed.isEmpty
    //        }
    //    }
    //
    //    //Validate Email
    //    var isEmail: Bool {
    //        do {
    //            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
    //            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
    //        } catch {
    //            return false
    //        }
    //    }
    
    //validate PhoneNumber
    //    var isPhoneNumber: Bool {
    //
    //        let charcter  = CharacterSet(charactersIn: "+0123456789").inverted
    //        var filtered:NSString!
    //        let inputString:NSArray = self.components(separatedBy: charcter)
    //        filtered = inputString.componentsJoined(by: "") as NSString!
    //        return  self == filtered
    //
    //    }
    
    
    // MARK: - MD5加密
    
    func md5() ->  String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(16)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02X", result[i])
        }
        
        result.deinitialize()
        
        return "\(hash.lowercased)"
    }
    
    func sha1() ->  String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_SHA1(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deinitialize()
        
        return "\(hash)"
    }
    
    //    func base64() -> String!{
    //        let plainData = data(using: String.Encoding.utf8)
    //        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    //        return base64String!
    //    }
    
    //    // MARK: - 文字截断
    subscript (r: Range<Int>) -> String? { //Optional String as return value
        get {
            let stringCount = self.characters.count as Int
            //Check for out of boundary condition
            if (stringCount < r.upperBound) || (stringCount < r.lowerBound){
                return nil
            }
            let startIndex = self.characters.index(self.startIndex, offsetBy: r.lowerBound)
            
            let endIndex = self.characters.index(self.startIndex, offsetBy: r.upperBound - r.lowerBound)
            
            return self[startIndex..<endIndex]
            //            [Range(start: startIndex, end: endIndex)]
        }
    }
    //
    func matchesForRegexInText(_ regex: String!, text: String!) -> [String] {
        let regex = try! NSRegularExpression(pattern: regex, options: NSRegularExpression.Options(rawValue: 0))
        let nsString = text as NSString
        let results = regex.matches(in: text, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, nsString.length))
        return results.map { nsString.substring(with: $0.range)}
    }
    
    func repelaceForRegexInText(_ regex: String!, text: String!, repelaceWithString string: String) -> String {
        
        var newString = ""
        
        let regex = try! NSRegularExpression(pattern: regex, options: NSRegularExpression.Options(rawValue: 0))
        let nsString = text as NSString
        let results = regex.matches(in: text, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, nsString.length))
        for result in results {
            newString = nsString.replacingCharacters(in: result.range, with: string)
        }
        return newString
    }
}
