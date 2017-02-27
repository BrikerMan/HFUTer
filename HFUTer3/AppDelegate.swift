//
//  AppDelegate.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/2.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import YYWebImage
import Firebase

let Is_Build_For_App_Store = true
let Is_TestFlight          = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Logger.invoke()
        handleFristLuacnh()
        DataEnv.updataHostInfo()
        HFUpdateCookieRequest().checkUpdate(onSucces: nil, failed: nil)
        prepareThridPart(launchOptions)
        
        let rootViewController = RootViewController()
        let rootNavController = UINavigationController(rootViewController:rootViewController)
        rootNavController.isNavigationBarHidden = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = rootNavController
        window?.makeKeyAndVisible()
        window?.tintColor = HFTheme.TintColor
        
        if DataEnv.isLogin {
            var icon1: UIApplicationShortcutIcon?
            var icon2: UIApplicationShortcutIcon?
            var icon3: UIApplicationShortcutIcon?
            
            if #available(iOS 9.1, *) {
                icon1 = UIApplicationShortcutIcon(type: .confirmation)
                icon2 = UIApplicationShortcutIcon(type: .date)
                icon3 = UIApplicationShortcutIcon(type: .compose)
            }
            
            let shortcut1 = UIApplicationShortcutItem(type: "com.eliyar.grade",
                                                      localizedTitle: "成绩",
                                                      localizedSubtitle: nil,
                                                      icon: icon1,
                                                      userInfo: nil)
            
            let shortcut2 = UIApplicationShortcutItem(type: "com.eliyar.calendar",
                                                      localizedTitle: "校历",
                                                      localizedSubtitle: nil,
                                                      icon: icon2,
                                                      userInfo: nil)
            
            let shortcut3 = UIApplicationShortcutItem(type: "com.eliyar.publish_love",
                                                      localizedTitle: "发布表白",
                                                      localizedSubtitle: nil,
                                                      icon: icon3,
                                                      userInfo: nil)
            
            application.shortcutItems = [shortcut1, shortcut2, shortcut3]
        } else {
            application.shortcutItems = nil
        }
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }
    
    func handleShortcut(_ shortcut :UIApplicationShortcutItem ) -> Bool {
        var succeeded = true
        
        switch shortcut.type {
        case "com.eliyar.grade":
            RootController.selectedIndex = 2
            RootController.infoVC.pushToGrades()
        
        case "com.eliyar.calendar":
            RootController.selectedIndex = 2
            RootController.infoVC.pushToCalendar()
        
        case "com.eliyar.publish_love":
            RootController.selectedIndex = 1
            let vc = HFCommunityPostLoveWallVC()
            RootController.infoVC.push(vc)

        default:
            succeeded = false
        }
        
        return succeeded
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcut(shortcutItem) )
    }
    
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("get the deviceToken  \(deviceToken)")
        
        let testflight = Is_TestFlight ? "TestFlight" : "AppStore"
        
        JPUSHService.registerDeviceToken(deviceToken)
        if let user = DataEnv.user {
            JPUSHService.setTags(Set(["push", testflight]), aliasInbackground: "\(user.sid)")
        } else {
            JPUSHService.setTags(Set(["push", testflight]), aliasInbackground: "000000")
        }
        let currentInstallation = AVInstallation.current()
        let sid = DataEnv.user?.sid ?? "\(000000)"
        
        currentInstallation?.setDeviceTokenFrom(deviceToken)
        currentInstallation?.setObject(sid, forKey: "sid")
        currentInstallation?.channels = [testflight]
        currentInstallation?.saveInBackground()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did fail to register for remote notification with error ", error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
        print("收到通知", userInfo)
        NotificationCenter.default.post(name: Notification.Name(rawValue: HFNotification.ReceiveRemoteNotif.rawValue), object: nil)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        //        JPUSHService.showLocalNotification(atFront: notification, identifierKey: nil)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if UIApplication.shared.applicationIconBadgeNumber != 0 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: HFNotification.ReceiveRemoteNotif.rawValue), object: nil)
        }
    }
    
    
    func prepareThridPart(_ launchOptions: [AnyHashable: Any]?) {
        JSPatch.start(withAppKey: JSPatchAppKey)
        JSPatch.sync()
        
        JPUSHService.register(
            forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue |
                UIUserNotificationType.sound.rawValue |
                UIUserNotificationType.alert.rawValue,
            categories: nil)
        
        JPUSHService.setup(withOption: launchOptions, appKey: JPushAppKey, channel: "App Store", apsForProduction: Is_Build_For_App_Store)
        
        AVOSCloud.setApplicationId(LeanCLoudAppID, clientKey: LeanCLoudAppKey)
        
        let conf = UMAnalyticsConfig()
        conf.appKey = UmengKey
        MobClick.start(withConfigure: conf)
        
        Fabric.with([Crashlytics.self])
        FIRApp.configure()
    }
    
    func handleFristLuacnh() {
        let key = "isFirstLaunchFor\(ez.appBuild ?? "0000")"
        let isFirstLaunch = UserDefaults.standard.object(forKey: key) as? Bool ?? true
        if isFirstLaunch {
            UserDefaults.standard.set(false, forKey: key)
            
            let cache = YYWebImageManager.shared().cache
            cache?.memoryCache.removeAllObjects()
            cache?.diskCache.removeAllObjects()
        }
    }
}

