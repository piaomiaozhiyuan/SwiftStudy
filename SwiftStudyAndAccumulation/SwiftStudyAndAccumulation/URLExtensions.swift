//
//  URLExtensions.swift
//  SwiftStudyAndAccumulation
//
//  Created by admin on 2017/4/1.
//  Copyright © 2017年 mapbar. All rights reserved.
//

import UIKit

extension URL {
    /// 扩展URL属性:只针对?后的参数.
    var urlParameters: [String: String]? {
        // 参数字典
        var params = [String: String]()
        // 参数部分
        if let urlQuery = self.query {
            // Returns a new string made from the receiver by replacing all percent encoded sequences with the matching UTF-8 characters.
            if let urlQueryString = urlQuery.removingPercentEncoding {
                NSLog("urlQueryEncode:%@", "\(urlQueryString)")
                // 通过"&"分割字符串
                if urlQueryString.contains("&") { // 结构：key=value&key=value
                    // 多个参数，分割参数
                    let urlComponents = urlQueryString.components(separatedBy: "&")
                    // 遍历参数
                    for component in urlComponents {
                        // 通过"="分割字符串
                        if component.contains("=") { // 结构：key=value
                            // 获取key -> Value对
                            let pairComponents = component.components(separatedBy: "=")
                            
                            if let key = pairComponents.first, let value = pairComponents.last {// 没有value的情况，认为参数丢失
                                // key value 都存在的情况
                                params[key] = value
                            }
                        }
                    }
                } else { // 考虑单一参数的情况 ?key=value
                    // 通过"="分割字符串
                    if urlQueryString.contains("=") { // 结构：key=value
                        // 获取key -> Value对
                        let pairComponents = urlQueryString.components(separatedBy: "=")
                        
                        if let key = pairComponents.first, let value = pairComponents.last {// 没有value的情况，认为参数丢失
                            // key value 都存在的情况
                            params[key] = value
                        }
                    }
                }
            }
        }
        return params
    }
}
