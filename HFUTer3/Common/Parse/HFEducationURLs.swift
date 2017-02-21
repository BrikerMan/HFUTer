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
    
    let xchost = "http://222.195.8.201"
    let hfhost = "http://bkjw.hfut.edu.cn"
    
    let login    = "/pass.asp"
    let schedule = "/student/asp/grkb1.asp"
    let score    = "/api/schedule/uploadScore"
}

extension String.Encoding {
    static let gb2312 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue)))
}
