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
    
    
    // MARK: - 下载图片
    
    ///  缓存路径的常量
    private static let imageCachePath = "com.mukang.imagecahce"
    
    ///  缓存图像的完成路径 - 懒加载
    private lazy var cachePath: String? = {
        
        // 1. cache
        var path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last as! String
        
        path = path.stringByAppendingPathComponent(imageCachePath)
        
        // 2. 检查缓存路径是否存在
        var isDirectory: ObjCBool = true // 注意：必须准确地指出类型 ObjCBool
        
        // 无论存在目录还是文件，exist 都会返回 true，是否是路径由 isDirectory 来决定
        let exist = NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDirectory)
        
        // 3. 如果有同名文件 - 干掉 （一定需要判断是否是文件，否则目录也同样会被删除）
        if exist && !isDirectory {
            
            NSFileManager.defaultManager().removeItemAtPath(path, error: nil)
        }
        
        // 4. 直接创建目录，如果存在目录就什么都不做
        NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: nil)
        
        return path
    }()
    
    
    ///  完整的图片缓存路径
    ///
    ///  :param: urlString urlString
    ///
    ///  :returns: 返回完整的路径
    func fullImageCachePath(urlString: String) -> String {
        
        // 1. 将下载的图像 url 进行 md5
        let path = urlString.md5
        
        // 2. 目标路径
        return cachePath!.stringByAppendingPathComponent(path)
    }
    
    
    
    ///  下载单张图像并保存到沙盒
    ///
    ///  :param: urlString  图片路径
    ///  :param: completion 完成回调
    func downloadImage(urlString: String, completion: Completion) {
       
        // 1. 目标路径
        let path = fullImageCachePath(urlString)
        
        // 2 缓存检测，如果文件已经下载完成直接返回
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            
            completion(result: nil, error: nil)
            
            return
        }
        
        // 3. 下载图像
        if let url = NSURL(string: urlString) {
        
            self.session!.downloadTaskWithURL(url, completionHandler: { (location, _, error) -> Void in
                
                // 错误处理
                if error != nil {
                    
                    completion(result: nil, error: error)
                    
                    return
                }
                
                // 将文件复制到缓存路径
                NSFileManager.defaultManager().copyItemAtPath(location.path!, toPath: path, error: nil)
                
                // 直接回调，不传递任何参数
                completion(result: nil, error: nil)
                
            }).resume()
            
        } else { // 如果 URL 创建不成功，回调错误
            
            let error = NSError(domain: SimpleNetwork.errorDomain, code: -1, userInfo: ["error": "无法创建 URL"])
            
            completion(result: nil, error: error)
        }
    }
    
    
    ///  下载多张图片
    ///
    ///  :param: urlStrings 图片 url 数组
    ///  :param: completion 完成回调
    func downloadImages(urlStrings: [String], completion: Completion) {
        
        // 希望所有图片下载完成，统一回调
        
        // 利用调度组统一监听一组异步任务执行完毕
        let group = dispatch_group_create()
        
        // 遍历 urlStrings 数组
        for urlString in urlStrings {
            
            // 进入调度组
            dispatch_group_enter(group)
            
            downloadImage(urlString, completion: { (result, error) -> () in
                
                // 离开调度组
                dispatch_group_leave(group)
            })
        }
        
        // 在主线程回调
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            
            // 所有任务完成后的回调
            completion(result: nil, error: nil)
        }
    }

    ///  异步下载网络图像
    ///
    ///  :param: urlString  urlString
    ///  :param: completion 完成回调
    func requestImage(urlString: String, _ completion: Completion) {
        
        weak var weakSelf = self
        
        // 1. 调用 download 下载图像，如果图片已经被缓存过，就不会再次下载
        downloadImage(urlString, completion: { (result, error) -> () in
            
            // 2. 错误处理
            if error != nil {
                
                completion(result: nil, error: error)
                
            } else {
                
                // 3. 图像是保存在沙盒路径中的，文件名是 url ＋ md5
                let path = weakSelf?.fullImageCachePath(urlString)
                
                // 将图片从沙盒加载到内存
                var image = UIImage(contentsOfFile: path!)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    completion(result: image, error: nil)
                })
            }
        })
    }
    
    
    // MARK: - 请求 JSON
    
    ///  请求 JSON
    ///
    ///  :param: method    访问方法
    ///  :param: urlString 请求路径
    ///  :param: _params   参数字典
    func requestJSON(method: HTTPMethod, _ urlString: String, _ params: [String: String]?, _ completion: Completion) {
        
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
    private func request(method: HTTPMethod, _ urlStirng: String, _ params: [String: String]?) -> NSURLRequest? {
        
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
    private func queryString(params: [String: String]?) -> String? {
        
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
    private lazy var session: NSURLSession? = {
        return NSURLSession.sharedSession()
    }()
    
    /// 类属性
    private static let errorDomain = "com.mukang.error"
    
}
