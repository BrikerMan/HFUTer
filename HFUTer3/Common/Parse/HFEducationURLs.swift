//
//  HFEducationURLs.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/2/4.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import Foundation

let EduURL = HFEducationURLs.shared

class HFEducationURLs {
    static let shared = HFEducationURLs()
    
    var jwLogin: String {
        return host() + "/pass.asp"
    }
    
    var schedule: String {
        return host() + "/student/asp/grkb1.asp"
    }
    
    var score: String {
        return host() + "/api/schedule/uploadScore"
    }
    
    var school = 0
    
    let xchost = "http://222.195.8.201"
    let hfhost = "http://bkjw.hfut.edu.cn"
    
    func host() -> String {
        if school == 0 {
            return xchost
        } else {
            return hfhost
        }
    }
}

extension String.Encoding {
    static let gb2312 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue)))
}
