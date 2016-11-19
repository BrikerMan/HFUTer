//
//  HFCommunityUserPublishedLostVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/5/25.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFCommunityUserPublishedLostVC: HFBaseViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    fileprivate func loadData() {

    }
}

extension HFCommunityUserPublishedLostVC: HFBaseAPIManagerCallBack {
    func managerApiCallBackFailed(_ manager: HFBaseAPIManager) {
        hud.showError(manager.errorInfo)
    }
    
    func managerApiCallBackSuccess(_ manager: HFBaseAPIManager) {
        
    }
}
