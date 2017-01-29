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

let Is_Build_For_App_Store = false
let Is_TestFlight          = true

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
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
        
        #if DEBUG
            let label = YYFPSLabel()
            window?.addSubview(label)
            label.frame.origin = CGPoint(x: 5, y: ScreenHeight - 40)
        #endif

        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }
    
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("get the deviceToken  \(deviceToken)")
        
        let testflight = Is_TestFlight ? "TestFlight" : "AppStore"
        
        JPUSHService.registerDeviceToken(deviceToken)
        if let user = DataEnv.user {
            JPUSHService.setTags(Set([user.sid, testflight]), aliasInbackground: "push")
        }
        let currentInstallation = AVInstallation.current()
        let sid = DataEnv.user?.sid ?? "\(000000)"
       
        currentInstallation?.setDeviceTokenFrom(deviceToken)
        currentInstallation?.setObject(sid, forKey: "sid")
        currentInstallation?.saveInBackground()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did fail to register for remote notification with error ", error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
        print("受到通知", userInfo)
        NotificationCenter.default.post(name: Notification.Name(rawValue: HFNotification.ReceiveRemoteNotif.rawValue), object: nil)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        JPUSHService.showLocalNotification(atFront: notification, identifierKey: nil)
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
    
    }
    
    func handleFristLuacnh() {
        let isFirstLaunch = UserDefaults.standard.object(forKey: "isFirstLaunchFor\(AppVersion)") as? Bool ?? true
        if isFirstLaunch {
            UserDefaults.standard.set(false, forKey: "isFirstLaunchFor\(AppVersion)")
            
            let cache = YYWebImageManager.shared().cache
            cache?.memoryCache.removeAllObjects()
            cache?.diskCache.removeAllObjects()
            
            let mypaths:NSArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as NSArray
            let mydocpath:String = mypaths.object(at: 0) as! String
            
            for file in [PlistManager.dataPlist,PlistManager.settingsPlist,PlistManager.userDataPlist] {
                let detaPath = (mydocpath as NSString).appendingPathComponent(file.name).characters.split{$0 == "."}.map(String.init).first!
                
                if FileManager.default.fileExists(atPath: detaPath) {
                    if let oldValues = NSDictionary(contentsOfFile: detaPath) as? HFRequestParam {
                        file.saveValues(oldValues as [String : AnyObject])
                        do {
                            try FileManager.default.removeItem(atPath: detaPath)
                        }
                        catch {
                            print("Ooops! Something went wrong:")
                        }
                    }
                }
            }
        }
    }
}

