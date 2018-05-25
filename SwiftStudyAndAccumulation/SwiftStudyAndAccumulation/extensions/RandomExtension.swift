//
//  RandomExtension.swift
//  SwiftStudyAndAccumulation
//
//  Created by wangzhen on 2017/8/10.
//  Copyright © 2017年 mapbar. All rights reserved.
//

import Foundation

// 参考链接：http://blog.csdn.net/u014455765/article/details/50419651

public extension Int {
    public static func random(_ lower: Int = 0, _ upper: Int = Int.max) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    public static func random(range: Range<Int>) -> Int {
        return random(range.lowerBound, range.upperBound)
    }
}

public extension Bool {
    public static func random() -> Bool {
        return Int.random(0, 1) == 0
    }
}

public extension Double {
    /// SwiftRandom extension
    public static func random(lower: Double = 0, _ upper: Double = 100) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
}

public extension Float {
    /// SwiftRandom extension
    public static func random(lower: Float = 0, _ upper: Float = 100) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
}

public extension CGFloat {
    /// SwiftRandom extension
    public static func random(lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
}

