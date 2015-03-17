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
        
//        if let token = AccessToken.loadAccessToken() {
//            
//            println("\(token.debugDescription)")
//        }
//        println("\(SimpleNetwork().cachePath)")
        
//        SimpleNetwork().downloadImage("http://ww4.sinaimg.cn/thumbnail/6f1045a5jw1eq7xuvaf5gj20hs0dcgn2.jpg", completion: { (result, error) -> () in
//            println("OK")
//        })
        
        // 统一设置导航栏
        setNavigationBarColor()
        
        return true
    }
    
    
    func setNavigationBarColor() {
        
        // 一经设置全局有效
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
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

