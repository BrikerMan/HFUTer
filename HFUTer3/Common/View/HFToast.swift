//
//  HFToast.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/1/29.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import Foundation
import Toaster

let HFToast = HFToastTool.shared

class HFToastTool {
    
    var toast: Toast?
    
    static let shared = HFToastTool()
    
    func debugInfo(_ info: String) {
        #if DEBUG
            toast?.cancel()
            print(info)
            toast = Toast(text: info, delay: 0, duration: 5.0)
            toast?.show()
        #endif
    }
    
    func showError(_ info: String) {
        toast?.cancel()
        toast = Toast(text: info, delay: 0, duration: 5.0)
        toast?.show()
    }
    
}
