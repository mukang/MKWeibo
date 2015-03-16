//
//  StatusesData.swift
//  MKWeibo
//
//  Created by 穆康 on 15/3/16.
//  Copyright (c) 2015年 穆康. All rights reserved.
//

import UIKit

///  加载微博数据 URL
private let WB_Hom_Timeline_URL = "https://api.weibo.com/2/statuses/home_timeline.json"

///  微博数据列表模型
class StatusesData: NSObject, DictModelProtocol {
   
    ///  微博记录数组
    var statuses: [Status]?
    
    ///  微博总数
    var total_number: Int = 0
    
    ///  未读数量
    var has_unread: Int = 0
    
    // 遵守协议
    static func customeClassMapping() -> [String : String]? {
        
        return ["statuses": "\(Status.self)"]
    }
    
    ///  刷新微博数据
    class func loadStatusesData(complation:(data: StatusesData?, error: NSError?) -> ()) {
    
        let net = NetworkManager.sharedManager
        
        if let token = AccessToken.loadAccessToken() {
            
            let params = ["access_token": "\(token.access_token!)"]
            
            // 发送网络异步请求
            net.requestJSON(.GET, WB_Hom_Timeline_URL, params, { (result, error) -> () in
                
                // 错误处理
                if error != nil {
                    
                    complation(data: nil, error: error)
                    
                    return
                }
                
                // 字典转模型
                let modelTools = SwiftDictModel.sharedManager
                
                let data = modelTools.objectWithDict(result as! NSDictionary, StatusesData.self) as? StatusesData
                
                // 回调，将模型通知给视图控制器
                complation(data: data, error: nil)
            })
            
        }
        
    }
}


class Status: NSObject, DictModelProtocol {
    
    ///  微博创建时间
    var created_at: String?
    
    ///  微博ID
    var id: Int = 0
    
    ///  微博信息内容
    var text: String?
    
    ///  微博来源
    var source: String?
    
    ///  转发数
    var reposts_count: Int = 0
    
    ///  评论数
    var comments_count: Int = 0
    
    ///  表态数
    var attitudes_count: Int = 0
    
    ///  配图数组
    var pic_urls: [StatusPictureURL]?
    
    /// 用户信息
    var user: UserInfo?
    
    /// 转发微博
    var retweeted_status: Status?
    
    // 遵守协议
    static func customeClassMapping() -> [String : String]? {
        
        return ["pic_urls": "\(StatusPictureURL.self)", "user": "\(UserInfo.self)", "retweeted_status": "\(Status.self)"]
    }
}



class StatusPictureURL: NSObject {
    
    
    ///  缩略图 URL
    var thumbnail_pic: String?
}

























