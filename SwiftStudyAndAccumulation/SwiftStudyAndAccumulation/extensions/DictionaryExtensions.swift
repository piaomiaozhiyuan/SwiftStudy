//
//  DictionaryExtensions.swift
//  SwiftStudyAndAccumulation
//
//  Created by wangzhen on 2017/4/19.
//  Copyright © 2017年 mapbar. All rights reserved.
//

import UIKit

class DictionaryExtensions: NSObject {

}

extension Array {
    var lastIndex: Int {
        return self.count - 1
    }
}

extension Dictionary {
    /// 获取嵌套字典的value，
    ///
    /// - Parameter keys: 每一级的key值
    /// - Returns: 返回要获取的value
    func getValue(withKeys keys: Array<String>) -> AnyObject? {
        // 非空校验
        if keys.isEmpty == false, self.isEmpty == false {
            // 待操作字典
            var obj: Dictionary = self
            
            // 遍历要获取的key
            for index in 0 ..< keys.count {
                // key
                let key = keys[index]
                NSLog("\(obj)")
                // 遍历要获取的字典
                for (keyDic, value) in obj {
                    // 如果key是String类型
                    if keyDic is String {
                        
                        let keyDic1 = keyDic as! String
                        // 匹配key
                        if keyDic1 == key {
                            // 最后一个key, 要获取的值
                            if index == keys.count - 1 {
                                NSLog("\(key)--\(value)")
                                return value as AnyObject
                            } else {
                                // 如果value是字典
                                if value is Dictionary {
                                    // 继续找下一个key
                                    obj = value as! Dictionary
                                    break
                                } else {
                                    // 错误
                                    NSLog("结构错误：下一节点不是字典")
                                    NSLog("\(key)--\(value)")
                                    return value as AnyObject
                                }
                            }
                        }
                    }
                }
            }
        }
        NSLog("没有找到值")
        return "" as AnyObject
    }
}
