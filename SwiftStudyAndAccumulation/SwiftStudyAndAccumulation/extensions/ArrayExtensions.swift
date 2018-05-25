//
//  ArrayExtensions.swift
//  SwiftStudyAndAccumulation
//
//  Created by wangzhen on 2017/4/20.
//  Copyright © 2017年 mapbar. All rights reserved.
//

import UIKit

extension Array {
    // array最后元素的索引值
    var lastIndex: Int {
        return self.count - 1
    }
    
    public func containsType<T>(of element: T) -> Bool {
        let elementType = type(of: element)
        return contains { type(of: $0) == elementType}
    }
}
