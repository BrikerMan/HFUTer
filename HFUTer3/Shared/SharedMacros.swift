//
//  sharedMacros.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/4/27.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import Foundation
import Pitaya

typealias JSONItem = JSONND

enum HFParseError: Error {
    case fullfill
    case loginError
    case getHtmlFail
    case suspend(info: String)
}
