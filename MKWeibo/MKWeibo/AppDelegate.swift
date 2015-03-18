//
//  AppDelegate.swift
//  MKWeibo
//
//  Created by 穆康 on 15/3/6.
//  Copyright (c) 2015年 穆康. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 统一设置导航栏
        setNavigationBarColor()
        
        // 检查token，如果有缓存token，直接显示主页，没有缓存，就显示登录界面，然后用通知跳转
        if let token = AccessToken.loadAccessToken() {
            
            showMainInterface()
            
        } else {
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMainInterface", name: WB_Login_Successed_Notification, object: nil)
        }
        
        return true
    }
    
    
    func setNavigationBarColor() {
        
        // 一经设置全局有效
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
    }
    
    ///  显示主页UI
    func showMainInterface() {
        
        // 通知需要注销
        NSNotificationCenter.defaultCenter().removeObserver(self, name: WB_Login_Successed_Notification, object: nil)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        window!.rootViewController = sb.instantiateInitialViewController() as! MainViewController
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

