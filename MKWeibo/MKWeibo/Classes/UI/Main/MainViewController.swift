//
//  MainViewController.swift
//  MKWeibo
//
//  Created by 穆康 on 15/3/13.
//  Copyright (c) 2015年 穆康. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    
    @IBOutlet weak var mainTabBar: TabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///  添加子控制器
        addChildControllers()
        
        weak var weakSelf = self
        // 给闭包赋值
        mainTabBar.composeBtnClicked = {
            
            // modal出撰写微博的视图控制器
            let sb = UIStoryboard(name: "Compose", bundle: nil)
            
            let composeVC = sb.instantiateInitialViewController() as! UINavigationController
            
            weakSelf!.presentViewController(composeVC, animated: true, completion: nil)
        }

    }
    
    ///  添加子控制器
    func addChildControllers() {
        
        addChildController("Home", "首页", "tabbar_home", "tabbar_home_highlighted")
        addChildController("Message", "消息", "tabbar_message_center", "tabbar_message_center_highlighted")
        addChildController("Discover", "发现", "tabbar_discover", "tabbar_discover_highlighted")
        addChildController("Profile", "我", "tabbar_profile", "tabbar_profile_highlighted")
    }
    
    
    ///  添加子控制器具体函数
    func addChildController(name: String, _ title: String, _ imageName: String, _ selectedImageName: String) {
        
        // 使用代码添加视图控制器
        let sb = UIStoryboard(name: name, bundle: nil)
        let vc = sb.instantiateInitialViewController() as! UINavigationController
        
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: selectedImageName)!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        vc.tabBarItem.title = title
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orangeColor()], forState: UIControlState.Selected)
        
        addChildViewController(vc)
        
    }
    
    
    

}
