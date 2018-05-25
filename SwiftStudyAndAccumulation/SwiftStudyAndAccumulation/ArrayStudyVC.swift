//
//  ArrayStudyVC.swift
//  SwiftStudyAndAccumulation
//
//  Created by wangzhen on 2018/4/27.
//  Copyright © 2018年 mapbar. All rights reserved.
//

import UIKit

class ArrayStudyVC: UIViewController {
    
    var pinyinSortArray = ["ceshi","kaifa","chanpin","ued","xiangmujingli","yunwei","fuwuqi"]
    var emptyArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "数组操作学习"
        self.view.backgroundColor = UIColor.white
        
        for index in 0 ..< 10 {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: 10, y: 60 + index * 60, width: 140, height: 44)
            btn.backgroundColor = UIColor.purple
            btn.setTitle("\(index)", for: .normal)
            btn.tag = index + 1000
            btn.addTarget(self, action: #selector(ArrayStudyVC.actionHandle(_:)), for: .touchUpInside)
            self.view.addSubview(btn)
            
            let tag = btn.tag - 1000
            if tag == 0 {
                btn.setTitle("拼音排序", for: .normal)
            } else if tag == 1 {
                btn.setTitle("空数组插入", for: .normal)
            } else if tag == 2 {
                
            } else if tag == 3 {
                
            } else if tag == 4 {
                
            } else if tag == 5 {
                
            } else if tag == 6 {
                
            } else {
                
            }
        }
    }
    
    @objc func actionHandle(_ sender: UIButton) {
        let tag = sender.tag - 1000
        if tag == 0 {
            pinyinSortArray.sort { (item1, item2) -> Bool in
                return item1 < item2
            }
            NSLog("pinyinArray = \(pinyinSortArray)")
        } else if tag == 1 {
            emptyArray.insert("1", at: 0)
            NSLog("emptyArray = \(emptyArray)")
        } else if tag == 2 {
            
        } else if tag == 3 {
            
        } else if tag == 4 {
            
        } else if tag == 5 {
            
        } else {
            
        }
    }
}
