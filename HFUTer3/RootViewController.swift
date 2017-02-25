//
//  ViewController.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/2.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

var RootController: RootViewController!

class RootViewController: UITabBarController {
    
    var homeVC: HFHomeVC!
    var infoVC: HFInformationVC!
    var mineVC: HFMineVC!
    var communityVC: HFCommunityVC!
    
    fileprivate var hfTabbar: HFTabbarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RootController = self
        preprareViewControllers()
    
        
        hfTabbar.shouldShowBandge = UIApplication.shared.applicationIconBadgeNumber != 0
        shouldShowDashang()
        
        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.afterLoginResponse(_:)), name: NSNotification.Name(rawValue: HFNotification.UserLogin.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.afterLogoutResponse(_:)), name: NSNotification.Name(rawValue: HFNotification.UserLogout.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onReceiveRemoteNotif), name: NSNotification.Name(rawValue: HFNotification.ReceiveRemoteNotif.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onClearBandge), name: NSNotification.Name(rawValue: HFNotification.RemoveBundge.rawValue), object: nil)
       
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onHaveNewSystemNotif(sendet:)),
                                               name: HFNotification.receiveNewAppNotif.get(),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoginVC(false)
    }
    

    
    @objc fileprivate func afterLoginResponse(_ sender:AnyObject) {
        selectedIndex = 0
    }
    
    @objc fileprivate func afterLogoutResponse(_ sender:AnyObject) {
        showLoginVC(true)
    }
    
    @objc fileprivate func onReceiveRemoteNotif() {
        hfTabbar.shouldShowBandge = true
    }
    
    @objc fileprivate func onClearBandge() {
        hfTabbar.shouldShowBandge = false
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    @objc fileprivate func onHaveNewSystemNotif(sendet: Notification) {
        if let notif = sendet.userInfo?["info"] as? String, let id = sendet.userInfo?["id"] as? Int {
            let alert = UIAlertController(title: nil, message: notif, preferredStyle: .alert)
            
            let ignore = UIAlertAction(title: "不再提醒", style: .cancel, handler: { (_) in
                var ignored = PlistManager.settingsPlist.getValues()?["ignored"] as? [Int] ?? []
                ignored.append(id)
                PlistManager.settingsPlist.saveValues(["ignored": ignored])
            })
            
            let done = UIAlertAction(title: "知道了", style: .default, handler: { (_) in
                
            })
            alert.addAction(ignore)
            alert.addAction(done)
            if let vc = self.presentedViewController {
                vc.present(alert, animated: true, completion: {
                    
                })
            } else {
                self.present(alert, animated: true, completion: {
                    
                })
            }
        }
    }
    
    fileprivate func showLoginVC(_ animated:Bool) {
        if !DataEnv.isLogin {
            let sb = UIStoryboard(name: "Login", bundle: nil)
            let vc = sb.instantiateInitialViewController()!
            let navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            navController.transitioningDelegate = self
            self.present(navController, animated: animated, completion: nil)
        } else {
            //            NSNotificationCenter.defaultCenter().postNotificationName(HFUserLoginNotification, object: nil)
        }
    }
    
    
    fileprivate func shouldShowDashang() {
        var openTimes = PlistManager.settingsPlist.getValues()?["openTimes"] as? Int ?? 0
        openTimes += 1
        PlistManager.settingsPlist.saveValues(["openTimes" : openTimes as AnyObject])
        if openTimes == 10 {
            let alert = UIAlertController(title: "支持程序员~", message:"这个项目是由工大学生自主开发的，并不是学校官方的应用，学校也没有给我们以任何方式资助。\n\n希望大家给程序员买杯咖啡~", preferredStyle: UIAlertControllerStyle.alert)
            let open = UIAlertAction(title: "支持", style: UIAlertActionStyle.default, handler: { (action) in
                let vc = UIStoryboard(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "HFMineDonateVC") as! HFMineDonateVC
                self.navigationController?.pushViewController(vc, animated: true)
            })
            let cancel = UIAlertAction(title: "不支持", style: UIAlertActionStyle.cancel, handler: nil)
            
            alert.addAction(open)
            alert.addAction(cancel)
            delay(seconds: 5, completion: { 
                DispatchQueue.main.async(execute: { 
                    self.present(alert, animated: true, completion: nil)
                })
            })
            
        }
    }
    
    // MARK: - 初始化
    fileprivate func preprareViewControllers() {
        homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as! HFHomeVC
        infoVC = UIStoryboard(name: "Information", bundle: nil).instantiateInitialViewController() as! HFInformationVC
        mineVC = UIStoryboard(name: "Mine", bundle: nil).instantiateInitialViewController() as! HFMineVC
        communityVC = UIStoryboard(name: "Community", bundle: nil).instantiateInitialViewController() as! HFCommunityVC
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let infoNav = UINavigationController(rootViewController: infoVC)
        let mineNav = UINavigationController(rootViewController: mineVC)
        let communityNav = UINavigationController(rootViewController: communityVC)


        let navList = [homeNav, communityNav, infoNav, mineNav]
        
        for i in  0..<4 {
            navList[i].isNavigationBarHidden = true
        }
        
        viewControllers = [homeNav, communityNav, infoNav, mineNav]
        
        let frame = CGRect(x: 0, y: ScreenHeight-49, width: ScreenWidth, height: 49)
        self.tabBar.frame = frame
        
        hfTabbar = HFTabbarView(frame: CGRect(x: 0,y: 0, width: ScreenWidth, height: 49))
        hfTabbar.delegate = self
        tabBar.addSubview(hfTabbar)
    }
}

extension RootViewController: HFTabbarViewDelegate {
    func tabbar(_ tabbar: HFTabbarView, didSelectedIndex index: Int) {
        self.selectedIndex = index
    }
}

extension RootViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeAnimator()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
