//
//  UIViewController+Extension.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/3/4.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit


extension UIViewController {
    func showAlert(title: String?, message: String?, actions: [UIAlertAction]? = nil) {
        var messageText: NSMutableAttributedString?
        if let message = message {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            messageText = NSMutableAttributedString(string: message,
                                                    attributes: [NSParagraphStyleAttributeName: paragraphStyle,NSFontAttributeName : UIFont.systemFont(ofSize: 12)])
        }
        
        self.showAttAlert(title: title, message: messageText, actions: actions)
    }
    
    
    
    func showAttAlert(title: String?, message: NSMutableAttributedString?, actions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        } else {
            let ok = UIAlertAction(title: "确定", style: .default, handler: nil)
            alert.addAction(ok)
        }
        if let message = message {
            alert.setValue(message, forKey: "attributedMessage")
        }
        
        self.presentVC(alert)
    }
    
    func showEduError(error: String) {
        let title = "从学校服务器获取数据失败"
        var info = "错误：" + error
        info += "\n解决办法：\n"
        info += "1.升级到最新版本 \n2.修改信息门户和教务系统密码并重新绑定 \n3.加 qq 群 117196247 反馈问题"
        self.showAlert(title: title, message: info)
    }
}

