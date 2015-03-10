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
    
}
