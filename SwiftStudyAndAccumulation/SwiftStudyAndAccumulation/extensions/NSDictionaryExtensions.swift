//
//  NSDictionaryExtensions.swift
//  SwiftStudyAndAccumulation
//
//  Created by wangzhen on 2017/10/9.
//  Copyright © 2017年 mapbar. All rights reserved.
//

import Foundation


extension NSDictionary {
    func valueIsEmpty(key: NSString) -> Bool {
        var result = true
        // 非空判断
        if let value = self.object(forKey: key) {
            if (value is NSNull) == false {
                result = false
            }
        }
        return result
    }
}
