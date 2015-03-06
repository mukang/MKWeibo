//
//  SimpleNetwork.swift
//  SimpleNetwork
//
//  Created by 穆康 on 15/3/3.
//  Copyright (c) 2015年 穆康. All rights reserved.
//

import Foundation

/// 常用的网络访问方法
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
}

class SimpleNetwork {
    
    // 定义闭包类型，类型别名，首字母一定要大写
    typealias Completion = (result: AnyObject?, error: NSError?) -> ()
    
    ///  请求 JSON
    ///
    ///  :param: method    访问方法
    ///  :param: urlString 请求路径
    ///  :param: _params   参数字典
    func requestJSON(method: HTTPMethod, _ urlString: String, _ params: [String: String]?, completion: Completion) {
        
        // 实例化网络请求
        if let request = request(method, urlString, params) {
            
            // 访问网络 - 回调方法是异步的
            session!.dataTaskWithRequest(request, completionHandler: { (data, _, error) -> Void in
                
                // 如果有错误，直接回调，将网络返回的错误传回
                if error != nil {
                    completion(result: nil, error: error)
                    return
                }
                
                // 反序列化
                let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil)
                // 判断反序列化是否成功
                if json == nil {
                    let error = NSError(domain: SimpleNetwork.errorDomain, code: -2, userInfo: ["error": "反序列化失败"])
                    completion(result: nil, error: error)
                } else {
                    // 在主线程回调
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(result: json, error: nil)
                    })
                }
            }).resume()
            
            return
        }
        
        // 如果网络请求没有创建成功，应该生成一个错误，提供给其他开发者
        // domain: 错误所属领域字符串 com.mukang.error 
        // code: 如果是复杂的系统，可以自己定义错误编号
        // userInfo: 错误信息字典
        let error = NSError(domain: SimpleNetwork.errorDomain, code: -1, userInfo: ["error": "请求建立失败"])
        completion(result: nil, error: error)
    }
    
    
    
    ///  2.请求 request
    ///
    ///  :param: method    访问方法
    ///  :param: urlString 请求路径
    ///  :param: _params   参数字典
    func request(method: HTTPMethod, _ urlStirng: String, _ params: [String: String]?) -> NSURLRequest? {
        
        var urlStr = urlStirng
        let query = queryString(params)
        var request: NSMutableURLRequest?
        
        // GET请求
        if method == HTTPMethod.GET {
            
            if query != nil {
                urlStr = urlStr + "?" + query!
            }
            request = NSMutableURLRequest(URL: NSURL(string: urlStr)!)
        } else {
            // POST请求必须发送数据给服务器
            if let query = queryString(params) {
                request = NSMutableURLRequest(URL: NSURL(string: urlStr)!)
                // 设置请求方法
                request!.HTTPMethod = method.rawValue
                // 设置请求体
                request!.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            }
        }
        return request
    }
    
    
    
    ///  1.拼接参数
    ///
    ///  :param: params 参数字典
    ///
    ///  :returns: 返回拼接好的字符串
    func queryString(params: [String: String]?) -> String? {
        
        // 判断参数是否为空
        if params == nil {
            return nil
        }
        
        // 拼接参数
        var array = [String]()
        // 遍历字典
        for (k, v) in params! {
            let str = k + "=" + v.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            array.append(str)
        }
        
        return join("&", array)
    }
    
    
    /// 全局的网络会话
    lazy var session: NSURLSession? = {
        return NSURLSession.sharedSession()
    }()
    
    /// 类属性
    static let errorDomain = "com.mukang.error"
    
}
