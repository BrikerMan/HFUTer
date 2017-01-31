//
//  Utilities.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/24.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation

class Utilities {
    static func getJpgFileName() -> String{
        let timeStamp = Date().timeIntervalSince1970 * 1000
        return "\(timeStamp)".md5() + ".jpg"
    }
    
    
    /**
     关于我的动态 时间展现规则
     1. 60分钟之内的消息 以x分钟显示  例：5分钟前  45分钟前
     2. 超过60分钟，取小时值，例如：1小时前  2小时前
     3. 超过24小时，取天数值，例如：1天前  5天前
     4. 超过一个月，取月数值，例如：1个月前 5个月前
     5. 超过一年，取年数值，例如：1年前  5年前
     */
    static func getTimeStringFromTimeStamp(_ stm:Int) -> String {
        let timeInterval:TimeInterval = Double(stm)
        let nowTimeStamp = Date().timeIntervalSince1970
        
        let sec =  Int(nowTimeStamp - timeInterval)
        
        let min:Int = Int(sec/60)
        if sec < 60 {
            return "\(sec) 秒钟前"
        }
        
        if min < 60 {
            return "\(min) 分钟前"
        }
        
        let hour:Int = Int(min/60)
        
        if hour < 12 {
            return "\(hour) 小时前"
        }
        
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let day = Int(hour/24)
        if day < 300 {
            return date.toString(format: "MM-dd hh:mm")
        }
        return date.toString(format: "yy-MM-dd hh:mm")
        
    }
    

    class func resizeImage(_ image: UIImage, newWidth: CGFloat = 1080) -> UIImage {
        
        if image.size.width < newWidth {
            return image
        }
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: newHeight))
        image.draw(in: CGRect.init(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
