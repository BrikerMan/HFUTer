//
//  HFBasicViewController.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/19.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


/**
 不带navBar的ViewController基类，
 集成一些基础设置和常用方法
 */
class HFBasicViewController: UIViewController, UIGestureRecognizerDelegate{
    
    // 是否添加点击空白处隐藏键盘功能
    var shouldHideKeybardWhenTap = false {
        didSet {
            if shouldHideKeybardWhenTap { addMainTapGestureRecognizer() }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = HFTheme.BlackAreaColor
        
        if navigationController?.viewControllers.count > 1 {
            navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.delegate = nil
    }
    
    @objc fileprivate func gestureTappedOnMainView(_ sender:AnyObject?) {
        view.endEditing(true)
    }
    
    func pop() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func push(_ vc:UIViewController) {
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    fileprivate func addMainTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HFBasicViewController.gestureTappedOnMainView(_:)))
        view.addGestureRecognizer(tapGesture)
    }
}
