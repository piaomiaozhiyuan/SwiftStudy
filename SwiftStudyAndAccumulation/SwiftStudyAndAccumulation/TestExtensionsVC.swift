//
//  TestExtensionsVC.swift
//  SwiftStudyAndAccumulation
//
//  Created by wangzhen on 2017/4/20.
//  Copyright © 2017年 mapbar. All rights reserved.
//

import UIKit

class TestExtensionsVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "验证扩展功能"
        
        self.testDictionaryExtension()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSLog("TestExtensionsVC被销毁了")
    }
    
    // MARK: - 测试扩展
    
    
    func testDictionaryExtension() {
        // 测试的嵌套字典
        let dic: Dictionary = ["key1":"1","key2":["key3":"3","key5":"5","key6":6],"key4":4] as [String : AnyObject]
        // 测试
        if let obj = dic.getValue(withKeys: ["key2","key6"]) {
            if obj is String {
                print("String---\(obj)")
            } else if obj is NSNumber {
                print("Number---\(obj)")
                if obj.isEqual(to: 6) == true {
                    print("匹配成功")
                }
            } else if obj is Int {
                print("int---\(obj)")
            } else {
                print("otherClass---\(obj)")
            }
        }
    }

}
