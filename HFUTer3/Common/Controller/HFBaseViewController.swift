//
//  HFBaseViewController.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/16.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

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
 带navBar的ViewController基类，
 集成一些基础设置和常用方法
 */

class HFBaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var nav: HFBaseNavBar?
    
    var navTitle: String = "" {
        didSet {
            nav?.setNavTitle(navTitle)
        }
    }
    
    var navRightButton:navRightIconType? {
        didSet {
            if let button = navRightButton {
                nav?.showNavRightButton(withButton: button)
            }
        }
    }
    
    var shouldShowBackButton = true {
        didSet {
            nav?.shouldShowBackButton = shouldShowBackButton
        }
    }
    
    // 是否添加点击空白处隐藏键盘功能
    var shouldHideKeybardWhenTap = false {
        didSet {
            if shouldHideKeybardWhenTap { addMainTapGestureRecognizer() }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = HFTheme.BlackAreaColor
        addBaseNavBar()
        if let title = title {
            navTitle = title
        }
        
        if navigationController?.viewControllers.count > 1 {
            navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTintColor), name: .tintColorUpdated, object: nil)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = nav {
            view.bringSubview(toFront: nav)
            nav.setNavTitle(navTitle)
            nav.delegate = self
            nav.shouldShowBackButton = shouldShowBackButton
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .tintColorUpdated, object: nil)
    }
    
    
    @objc fileprivate func gestureTappedOnMainView(_ sender:AnyObject?) {
        view.endEditing(true)
    }
    
    func onNavRightButtonPressed() {
        
    }
    
    func updateTintColor() {
        
    }
    
    func pop() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func push(_ vc:UIViewController) {
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func addMainTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HFBaseViewController.gestureTappedOnMainView(_:)))
        
        view.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func addBaseNavBar() {
        nav = HFBaseNavBar()
        view.addSubview(nav!)
        
        nav!.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(NavbarHeight)
        }
    }
}

extension  HFBaseViewController: HFBaseNavBarDelegate {
    func navBarDidPressOnBackButton() {
        pop()
    }
    
    func navBarOnNavRightButtonPressed() {
        onNavRightButtonPressed()
    }
}
