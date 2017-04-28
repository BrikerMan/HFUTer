//
//  HFHelpInfoWebVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/5.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import AlamofireDomain

enum HFHelpInfoWebType:String {
    case Help       = "Help"
    case About      = "About"
    case Privacy    = "Privacy"
}

class HFHelpInfoWebVC: HFBaseViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var type = HFHelpInfoWebType.Help

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = ""
        
        switch type {
        case .Help:
//            url = DataEnv.helpWebLinks[type.rawValue] ?? "http://ac-jkqbcp9o.clouddn.com/03205dcaf449a6f8c102.html"
            url = "http://ac-jkqbcp9o.clouddn.com/5cf9f1ab6228efbc2d3b.html"
            navTitle = "帮助"
        case .About:
            url = DataEnv.helpWebLinks[type.rawValue] ?? "http://ac-jkqbcp9o.clouddn.com/a8409b5b34ab13af.html"
            navTitle = "关于我们"
        default:
            url = DataEnv.helpWebLinks[type.rawValue] ?? "http://ac-jkqbcp9o.clouddn.com/bfa7ee4bb0c50ff8.html"
            navTitle = "隐私条款"
        }
        
        
        let link = URL (string: url)
        let requestObj = URLRequest(url: link!)
        webView.loadRequest(requestObj)
    }
    
    
}
