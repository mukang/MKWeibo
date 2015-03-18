//
//  NetworkManager.swift
//  MKWeibo
//
//  Created by 穆康 on 15/3/4.
//  Copyright (c) 2015年 穆康. All rights reserved.
//

import Foundation

///  网络接口 - 单例
class NetworkManager {
    
    
    private static let sharedInstance = NetworkManager()
    ///  全局的网络访问入口
    class var sharedManager: NetworkManager {
        return sharedInstance
    }
    
    // 定义一个类的完成闭包类型
    typealias Completion = (result: AnyObject?, error: NSError?) -> ()
    
    ///  全局的一个网络框架实例
    private let net = SimpleNetwork()
    
    func requestJSON(method: HTTPMethod, _ urlString: String, _ params: [String: String]?, _ completion: Completion) {
        
        net.requestJSON(method, urlString, params, completion)
    }
    
    
    ///  下载图像并保存到沙盒
    ///
    ///  :param: urlString  图片路径
    ///  :param: completion 完成回调
    func downloadImage(urlString: String, completion: Completion) {
        
        net.downloadImage(urlString, completion: completion)
    }
    
    
    ///  下载多张图片
    ///
    ///  :param: urlStrings 图片 url 数组
    ///  :param: completion 完成回调
    func downloadImages(urlStrings: [String], completion: Completion) {
        
        net.downloadImages(urlStrings, completion: completion)
    }
    
    
}
