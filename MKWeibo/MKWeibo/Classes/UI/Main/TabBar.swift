//
//  TabBar.swift
//  MKWeibo
//
//  Created by 穆康 on 15/3/13.
//  Copyright (c) 2015年 穆康. All rights reserved.
//

import UIKit

class TabBar: UITabBar {
    
    // 定义点击撰写按钮的闭包
    var composeBtnClicked: (() -> ())?

    override func awakeFromNib() {
        
        // 添加撰写按钮
        addSubview(composeBtn!)
    }

    // 重写此方法会使TabBar的背景色消失
    override func layoutSubviews() {
        
        // 设置按钮位置及尺寸
        setButtonsFrame()
    }
    
    // 设置按钮位置及尺寸
    func setButtonsFrame() {
        
        // 按钮总数
        let btnCount: CGFloat = 5
        
        let btnW = self.width / btnCount
        let btnH = self.height
        
        var index: CGFloat = 0
        // 遍历子控件
        for view in self.subviews as! [UIView] {
            
            if !(view is UIButton) {
                
                let btnFrame = CGRectMake(btnW * index, 0, btnW, btnH)
                
                view.frame = btnFrame
                
                index++
                
                if index == 2 {
                    
                    // 给撰写按钮设置尺寸
                    composeBtn!.frame = CGRectMake(btnW * index, 0, btnW, btnH)
                    
                    index++
                }
            }
        }
    }
    
    
    
    // 懒加载创建撰写微博按钮
    lazy var composeBtn: UIButton? = {
        
        let btn = UIButton()
        
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        // 添加按钮的监听方法
        btn.addTarget(self, action: "clickComposeBtn", forControlEvents: UIControlEvents.TouchUpInside)
  
        return btn
    }()
    
    
    func clickComposeBtn() {
        
        if composeBtnClicked != nil {
            
            composeBtnClicked!()
        }
    }
    
    

}
