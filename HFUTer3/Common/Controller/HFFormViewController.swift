//
//  HFFormViewController.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/5/25.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Eureka

class HFFormViewController: FormViewController, UIGestureRecognizerDelegate {

    var nav: HFBaseNavBar?
    
    var navTitle: String = "" {
        didSet {
            nav?.setNavTitle(navTitle)
        }
    }
    
    var hideNavLeftButton: Bool = false {
        didSet {
            nav?.navLeftButton.isHidden = hideNavLeftButton
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = HFTheme.BlackAreaColor
        addBaseNavBar()
        if let title = title {
            navTitle = title
        }
        
        initForm()
        
        // Do any additional setup after loading the view.
    }
    
    func initForm() {
        TextRow.defaultCellUpdate = { cell, row in
            cell.textField.textColor    = HFTheme.GreyTextColor
            cell.textField.font         = UIFont.systemFont(ofSize: 14)
            cell.titleLabel!.font       = UIFont.systemFont(ofSize: 14)
            cell.titleLabel!.textColor  = row.isDisabled ? HFTheme.GreyTextColor : HFTheme.DarkTextColor
        }
        
        HFEurekaInfoRow.defaultCellUpdate = { cell, row in
            cell.titleLabel.textColor = HFTheme.DarkTextColor
            cell.titleLabel.font      = UIFont.systemFont(ofSize : 14)
            cell.infoLabel.font       = UIFont.systemFont(ofSize : 14)
            cell.infoLabel.textColor  = row.isDisabled ? HFTheme.GreyTextColor : HFTheme.DarkTextColor
        }

        
        PasswordRow.defaultCellUpdate = { cell, row in
            cell.textField.textColor    = HFTheme.GreyTextColor
            cell.textField.font         = UIFont.systemFont(ofSize: 14)
            cell.titleLabel!.font       = UIFont.systemFont(ofSize: 14)
            cell.titleLabel!.textColor  = row.isDisabled ? HFTheme.GreyTextColor : HFTheme.DarkTextColor
        }
        
        EmailRow.defaultCellUpdate = { cell, row in
            cell.textField.textColor    = HFTheme.GreyTextColor
            cell.textField.font         = UIFont.systemFont(ofSize: 14)
            cell.titleLabel!.font       = UIFont.systemFont(ofSize: 14)
            cell.titleLabel!.textColor  = row.isDisabled ? HFTheme.GreyTextColor : HFTheme.DarkTextColor
        }
        
        DateRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor        = HFTheme.DarkTextColor
            cell.textLabel?.font             = UIFont.systemFont(ofSize: 14)
            cell.detailTextLabel?.font       = UIFont.systemFont(ofSize: 14)
            cell.detailTextLabel?.textColor  = row.isDisabled ? HFTheme.GreyTextColor : HFTheme.GreyTextColor
        }
        
        AlertRow<String>.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor        = HFTheme.DarkTextColor
            cell.textLabel?.font             = UIFont.systemFont(ofSize: 14)
            cell.detailTextLabel?.font       = UIFont.systemFont(ofSize: 14)
            cell.detailTextLabel?.textColor  = row.isDisabled ? HFTheme.GreyTextColor : HFTheme.GreyTextColor
        }
        
        TextAreaRow.defaultCellUpdate = { cell, row in
            cell.textView.textColor          = HFTheme.DarkTextColor
            cell.textView.font               = UIFont.systemFont(ofSize: 14)
            cell.placeholderLabel?.font       = UIFont.systemFont(ofSize: 14)
            cell.placeholderLabel?.textColor  = HFTheme.GreyTextColor

        }

        ImageRow.defaultCellSetup = { cell,row in
            cell.height = { return 80 }
        }
        
        ImageRow.defaultCellUpdate = { cell,row in
            cell.textLabel?.textColor        = HFTheme.DarkTextColor
            cell.textLabel?.font             = UIFont.systemFont(ofSize: 14)
            cell.accessoryView?.frame.size = CGSize(width: 50, height: 50)
            cell.accessoryView?.layer.cornerRadius = 3
            
        }
        
        SwitchRow.defaultCellUpdate = { cell,row in
            cell.textLabel?.textColor        = HFTheme.DarkTextColor
            cell.textLabel?.font             = UIFont.systemFont(ofSize: 14)
        }
        
        CheckRow.defaultCellUpdate = { cell,row in
            cell.textLabel?.textColor        = HFTheme.DarkTextColor
            cell.textLabel?.font             = UIFont.systemFont(ofSize: 14)
        }
        
        ButtonRow.defaultCellUpdate = { cell,row in
            cell.textLabel?.font             = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.textColor        = HFTheme.DarkTextColor
        }

    
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.bringSubview(toFront: nav!)
        nav!.setNavTitle(navTitle)
        nav!.delegate = self
        nav!.shouldShowBackButton = shouldShowBackButton
        tableView?.frame = CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight-64)
        tableView?.backgroundColor = HFTheme.BlackAreaColor
        tableView?.separatorColor  = HFTheme.SeperatorColor
        nav?.navLeftButton.isHidden = hideNavLeftButton
        automaticallyAdjustsScrollViewInsets = false
    }
    
    
    
    @objc fileprivate func gestureTappedOnMainView(_ sender:AnyObject?) {
        view.endEditing(true)
    }
    

    
    func onNavRightButtonPressed() {
        
    }
    
    func pop() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func push(_ vc:UIViewController) {
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func addBaseNavBar() {
        nav = HFBaseNavBar()
        view.addSubview(nav!)
        
        nav!.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(64)
        }
    }
}

extension  HFFormViewController: HFBaseNavBarDelegate {
    func navBarDidPressOnBackButton() {
        pop()
    }
    
    func navBarOnNavRightButtonPressed() {
        onNavRightButtonPressed()
    }
}
