//
//  StringExtensions.swift
//  SwiftStudyAndAccumulation
//
//  Created by admin on 2017/4/1.
//  Copyright © 2017年 mapbar. All rights reserved.
//

import UIKit

// MARK: - 字符串扩展
extension String {
    
}

extension NSString {
    
    
}

// MARK: - 为可选NSString类扩展属性
extension Optional where Wrapped == NSString {
    /// 判断数据是否为空（nil || 空串）可以制定一个规则并实现逻辑
    var isEmpty: Bool {
        
        guard let string = self else {
            return true
        }
        
        if string.length == 0 {
            return true
        }
        
        return false
    }
    
    /// nil || 空串 || (null) || <null>
    var isAllEmpty: Bool {
        
        guard let string = self else {
            return true
        }
        
        if string.length == 0 || string.isEqual(to: "(null)") == true || string.isEqual(to: "<null>") == true {
            return true
        }
        
        return false
    }
}
