//
//  AccessToken.swift
//  MKWeibo
//
//  Created by 穆康 on 15/3/10.
//  Copyright (c) 2015年 穆康. All rights reserved.
//

import UIKit

class AccessToken: NSObject, NSCoding {
   
    ///  用于调用access_token，接口获取授权后的access token
    var access_token: String?
    
    ///  access_token的生命周期，单位是秒数
    var expires_in: NSNumber? {
        didSet{
            expiresDate = NSDate(timeIntervalSinceNow: expires_in!.doubleValue)
        }
    }
    
    ///  过期日期
    var expiresDate: NSDate?
    
    ///  是否过期，用过期日期和当期日期进行比较
    var isExpired: Bool {
        return expiresDate?.compare(NSDate()) == NSComparisonResult.OrderedAscending
    }
    
    ///  access_token的生命周期（该参数即将废弃，开发者请使用expires_in）
    var remind_in: NSNumber?
    
    ///  当前授权用户的UID，整数类型如果要归档&接档，需要使用 Int 类型，NSNumber 会不正常
    var uid: Int = 0
 
    
    ///  构造函数
    init(dict: NSDictionary) {
        
        super.init()
        
        self.setValuesForKeysWithDictionary(dict as [NSObject : AnyObject])
    }
    
    // MARK: - 保存和读取数据
    
    ///  将数据保存到沙盒
    func saveAccessToken() {
        
        NSKeyedArchiver.archiveRootObject(self, toFile: AccessToken.tokenPath())
    }
    
    class func loadAccessToken() -> AccessToken? {
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(tokenPath()) as? AccessToken
    }
    
    ///  返回保存路径
    class func tokenPath() -> String {
        
        var path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last as! String
        
        return path.stringByAppendingPathComponent("WB_Token.plist")
    }
    
    
//    override init() {}
    
    // MARK: - 归档和解档
    
    // 有归档和解档方法是，至少需要写一个构造函数，否则解档方法会覆盖原有构造函数
    // 归档
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(access_token)
        aCoder.encodeObject(expiresDate)
        aCoder.encodeInteger(uid, forKey: "uid")
        
    }
    
    // 解档 - NSCoding需要的方法，前面要加required，并且有init的方法不能写在extention中
    required init(coder aDecoder: NSCoder) {
        
        access_token = aDecoder.decodeObject() as? String
        expiresDate = aDecoder.decodeObject() as? NSDate
        uid = aDecoder.decodeIntegerForKey("uid")
    }

}


///  extension 是一个分类，分类不允许有存储能力
///  如果要打印对象信息，OC 中的 description，在 swift 中需要遵守协议 DebugPrintable
extension AccessToken: DebugPrintable {
    
    override var debugDescription: String {
        
        let dict = self.dictionaryWithValuesForKeys(["access_token", "expiresDate", "uid"])
        
        return "\(dict)"
    }

}













