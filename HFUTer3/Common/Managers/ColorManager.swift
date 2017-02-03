//
//  ColorManager.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/15.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
//import ChameleonFramework

struct HFFlatColor {
    let name:String
    let color:UIColor
}

let defaultColor = UIColor.white

extension Notification.Name {
    static let tintColorUpdated = Notification.Name("HFTintColorUpdatedNotification")
}

class ColorManager {
    static let shared = ColorManager()
    
    var tintName = ""
    
    /// 主题色
    var TintColor      = UIColor(hexString: "#FF5B57")!
    /// 二级主题色
    var LightTintColor = UIColor(hexString: "#FC6B5D")!
    
    /// 主文字颜色
    let DarkTextColor  = UIColor(hexString: "#555555")!
    /// 二级文字颜色
    let GreyTextColor  = UIColor(hexString: "#777777")!
    /// 三级文字颜色
    let LightTextColor = UIColor(hexString: "#b2b2b2")!
    
    /// 分割线
    let SeperatorColor = UIColor(hexString: "#dfdfdf")!
    /// 空白部分背景色
    let BlackAreaColor = UIColor(hexString: "#f5f5f5")!
    /// 内容部分背景色
    let WhiteBackColor = UIColor(hexString: "#ffffff")!
    
    // Flat Colors
    let flatColors: [HFFlatColor] = [
        HFFlatColor(name:"Sunset Orange",color:UIColor(hexString: "#FF5B57")!),
        HFFlatColor(name:"Mint",color:UIColor(hexString: "#00C6AD")!),
        HFFlatColor(name:"Green",color:UIColor(hexString: "#02D286")!),
        HFFlatColor(name:"Sky Blue",color:UIColor(hexString: "#38A9E0")!),
        HFFlatColor(name:"Forest Green",color:UIColor(hexString: "#3E7054")!),
        HFFlatColor(name:"Navy Blue",color:UIColor(hexString: "#425B71")!),
        HFFlatColor(name:"Teal",color:UIColor(hexString: "#468294")!),
        HFFlatColor(name:"Blue",color:UIColor(hexString: "#627AAF")!),
        HFFlatColor(name:"Brown",color:UIColor(hexString: "#735744")!),
        HFFlatColor(name:"Plum",color:UIColor(hexString: "#744670")!),
        HFFlatColor(name:"Purple",color:UIColor(hexString: "#8974CD")!),
        HFFlatColor(name:"Marnoon",color:UIColor(hexString: "#8E4238")!),
        HFFlatColor(name:"Magenta",color:UIColor(hexString: "#AF70C0")!),
        HFFlatColor(name:"Lime",color:UIColor(hexString: "#B2CF55")!),
        HFFlatColor(name:"Coffee",color:UIColor(hexString: "#B49885")!),
        HFFlatColor(name:"Orange",color:UIColor(hexString: "#EF9235")!),
        HFFlatColor(name:"Red",color:UIColor(hexString: "#F3674E")!),
        HFFlatColor(name:"Water Lemon",color:UIColor(hexString: "#F8888C")!),
        HFFlatColor(name:"Pink",color:UIColor(hexString: "#FD94CE")!),
    ]
    
    /// [课程名:颜色] - 用于为同一个课程获取同一个颜色
    var colorsForCourse:[String:String] = [:] {
        didSet {
            PlistManager.settingsPlist.saveValues(["colorsForCourse":colorsForCourse])
        }
    }
    
    init() {
        let setting = PlistManager.settingsPlist.getValues()
        colorsForCourse = setting?["colorsForCourse"] as? [String:String] ?? [:]
        
        tintName = PlistManager.settingsPlist.getValues()?["主体颜色"] as? String ?? "Sunset Orange"
        TintColor = getColor(with: tintName)
    }
    
    func saveTintColor(name: String, color: String) {
        PlistManager.settingsPlist.saveValues(["主体颜色":name,
                                               "自定义颜色": color])
        TintColor = UIColor(hexString: color)!
        NotificationCenter.default.post(name: .tintColorUpdated, object: nil)
    }
    
    
    /**
     获取随机扁平颜色
     */
    func getRandomColor() -> HFFlatColor {
        let index = Int(arc4random_uniform(UInt32(flatColors.count)))
        return flatColors[index]
    }
    
    
    func getColor(with name: String) -> UIColor {
        if name == "自定义" {
            let color = PlistManager.settingsPlist.getValues()?["自定义颜色"] as? String ?? "#FF5B57"
            return UIColor(hexString: color)!
        } else {
            for flat in flatColors where flat.name == name {
                return flat.color
            }
        }
        return UIColor(hexString: "#FF5B57")!
    }
    
    /**
     为课程名返回已保存的字典中的颜色，如果没有保存，则随机产生一个返回，并保存至字典
     */
    func getColorForCourses(withName name:String) -> UIColor {
        var color = UIColor(hexString: "#468294")!
        if let colorName = colorsForCourse[name] {
            for flat in flatColors where flat.name == colorName {
                color = flat.color
            }
        } else {
            let flat = getRandomColor()
            colorsForCourse[name] = flat.name
            color = flat.color
        }
        
        return color
    }
}
