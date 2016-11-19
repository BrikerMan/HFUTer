//
//  HFCommunityContactVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/5/25.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

class HFCommunityContactVC: HFFormViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    fileprivate func initUI() {
        form
        +++ Section()
            <<< TextRow("studentNum") {
                $0.title = "被通知同学学号"
        }
    }
    
}
