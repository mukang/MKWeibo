//
//  SwiftDictModel.swift
//  字典转模型
//
//  Created by 穆康 on 15/3/7.
//  Copyright (c) 2015年 穆康. All rights reserved.
//

import Foundation

/**
字典转模型协议

提示：
* 自定义类映射字典中需要包含类的命名空间

示例代码：
return ["info": "\(Info.self)", "other": "\(Info.self)", "demo": "\(Info.self)"];

* 目前存在的问题：

- 由于 customClassMapping 是一个静态函数，子类模型中不能重写协议函数
- 如果子类中也包含自定义对象，需要在父类的 customClassMapping 一并指定

* 不希望参与字典转模型的属性可以定义为 private 的
*/

///  字典转模型自定义协议
@objc protocol DictModelProtocol {
    
    ///  自定义类映射
    ///
    ///  :returns: 可选关系映射字典 [属性名: 自定义对象名称]
    static func customeClassMapping() -> [String: String]?
}

class SwiftDictModel {
    
    /// 全局单例
    private static let sharedInstance = SwiftDictModel()
    
    class var sharedManager: SwiftDictModel {
        return sharedInstance
    }
    
    ///  字典转模型
    ///
    ///  :param: dict 要转的字典
    ///  :param: cls  模型类
    ///
    ///  :returns: 转好的模型对象
    func objectWithDict(dict: NSDictionary, _ cls: AnyClass) -> AnyObject? {
        
        // 取得模型类信息字典
        let dictInfo = fullModelInfo(cls)
        
        // 实例化对象
        let obj: AnyObject = cls.alloc()
        
        // 遍历模型信息字典，有什么属性就设置什么属性
        for (k, v) in dictInfo {
            
            // 取出传入字典中的内容
            // MARK: - 需特别注意 if let value: AnyObject? = dict[k] 不能有问号
            if let value: AnyObject = dict[k] {
                
                // 1.判断是否是自定义对象（不是自定义对象）
                // 在json反序列化时，如果是null值，保存在字典中的结果是NSNull()
                if v.isEmpty && !(value === NSNull()) {
                    
                    obj.setValue(value, forKey: k)
                
                } else { // 2.是自定义对象和value为NSNull()的系统类型
                    
                    // 确定value的类型
                    let type = "\(value.classForCoder)"
                    
                    if type == "NSDictionary" { // 2.1如果类型是字典
                        
                        // 将value字典转换成 Info 对象
                        if let subObj: AnyObject = objectWithDict(value as! NSDictionary, NSClassFromString(v)) {
                            
                            obj.setValue(subObj, forKey: k)
                        }
                            
                    } else if type == "NSArray" { // 2.2如果类型是数组
                        
                        if let subObj: AnyObject = objectWithArray(value as! NSArray, NSClassFromString(v)) {
                            
                            obj.setValue(subObj, forKey: k)
                        }
                    }
                }
            }
        }
        
        return obj
    }
    
    
    ///  数组转模型数组
    ///
    ///  :param: array 给定得数组
    ///  :param: cls   要转的模型类
    ///
    ///  :returns: 模型数组
    func objectWithArray(array: NSArray, _ cls: AnyClass) -> [AnyObject]? {
        
        // 创建一个临时数组
        var tempArray = [AnyObject]()
        
        // 遍历传进来的数组
        for value in array {
            
            let type = "\(value.classForCoder)"
            
            if type == "NSDictionary" { // 1. 数组里是字典
                
                if let subObj: AnyObject = objectWithDict(value as! NSDictionary, cls) {
                    
                    tempArray.append(subObj)
                }
                
            } else if type == "NSArray" { // 2. 数组里是数组
                
                if let subObj: AnyObject = objectWithArray(value as! NSArray, cls) {
                    
                    tempArray.append(subObj)
                }
            }
        }
        
        return tempArray
    }
    
    
    /// 缓存字典，将模型类的信息记录到缓存字典
    var modelCache = [String: [String: String]]()
    
    ///  获取模型类完整信息
    ///
    ///  :returns: cls模型类
    func fullModelInfo(cls: AnyClass) -> [String: String] {
        
        // 判断类信息是否被缓存
        if let cache = modelCache["\(cls)"] {
//            println("\(cls) 已经被缓存")
            return cache
        }
        
        var currentCls: AnyClass = cls
        
        // 模型信息字典
        var dictInfo = [String: String]()
        
        // 循环查找父类
        while let parent: AnyClass = currentCls.superclass() {
            
            // 取出并拼接currentCls模型信息字典
            dictInfo.merge(modelInfo(currentCls))
            
            currentCls = parent
        }
        // 将模型信息写入缓存
        modelCache["\(cls)"] = dictInfo
        
        return dictInfo
    }
    
    // 获取给定类的信息
    func modelInfo(cls: AnyClass) -> [String: String] {
        
        // 判断类信息是否被缓存
        if let cache = modelCache["\(cls)"] {
            println("\(cls) 已经被缓存")
            return cache
        }
        
        var mapping: [String: String]?
        // 判断类是否遵守协议，一旦遵守协议，说明有自定义对象
        if cls.respondsToSelector("customeClassMapping") {
            // 调用协议方法，获取自定义对象映射关系字典
            mapping = cls.customeClassMapping()
        }
        
        // 定义属性数量
        var count: UInt32 = 0
        
        let properties = class_copyPropertyList(cls, &count)
        
        // 定义一个类属性的字典 [属性名称：自定对象的名称/""]
        var dictInfo = [String: String]()
        // 获取每个属性的信息，属性的名字和类型
        for i in 0..<count {
            let property = properties[Int(i)]
            // UInt8 = char，C语言的字符串
            let cname = property_getName(property)
            // 将C语言字符串转化成swift的String
            let name = String.fromCString(cname)!
            
            // 判断映射字典中，是否存在name，来确定是否是自定义对象
            // 关于对象类型：如果是系统的类型，可以通过KVC直接设置数值， 只有自定义对象才需要确定类型
            let type = mapping?[name] ?? ""
            
            // 设置字典
            dictInfo[name] = type
            
            // 获取每个属性对应的类型
//            let ctype = property_getAttributes(property)
//            let type = String.fromCString(ctype)
            
        }
        free(properties)
        
        // 将模型信息写入缓存
        modelCache["\(cls)"] = dictInfo
        
        return dictInfo
    }
}


///  给字典添加扩展
extension Dictionary {
    
    // 将给定的字典合并到当前的字典（可变字典）
    mutating func merge<K, V>(dict: [K: V]) {
        
        for (k, v) in dict {
            
            // 字典的分类方法中，如果要使用 updateValue，需要明确的指定类型
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}















