//
//  UnsafePointerViewController.swift
//  SwiftStudyAndAccumulation
//
//  Created by wangzhen on 2018/6/8.
//  Copyright © 2018年 mapbar. All rights reserved.
//

import UIKit

class UnsafePointerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Swift指针学习"
        self.view.backgroundColor = UIColor.white
        setupUI()
    }
    
    func setupUI() {
        var validHeight: CGFloat = self.view.bounds.size.height - 88 - 100
        if #available(iOS 11.0, *) {
            validHeight = validHeight - self.view.safeAreaInsets.bottom
        }
        
        var newlineIndex: Int? = nil
        var needNewline: Bool = false
        let viewWidth: Int = Int(self.view.bounds.size.width)
        let interval: Int = 10
        let buttonWidth: Int = (viewWidth - 3 * interval) / 2
        var buttonTitles: [String] = ["data转bytes"]
        
        for index in 0 ..< 13 {
            let btn = UIButton(type: .custom)
            if !needNewline {
                needNewline = CGFloat(index * 60) + 44 > validHeight
                newlineIndex = index
            }
            let columns = needNewline ? 1 : 0
            let row: Int = (needNewline && newlineIndex != nil && newlineIndex! != 0) ? index % newlineIndex! : index
            
            btn.frame = CGRect(x: interval + columns * (interval + buttonWidth) ,
                               y: 88 + row * 60,
                               width: buttonWidth, height: 44)
            btn.backgroundColor = UIColor.purple
            if index >= buttonTitles.count {
                btn.setTitle("\(index)", for: .normal)
            } else {
                btn.setTitle("\(buttonTitles[index])", for: .normal)
            }
            
            btn.tag = index + 1000
            btn.addTarget(self, action: #selector(UnsafePointerViewController.actionHandle(_:)), for: .touchUpInside)
            self.view.addSubview(btn)
        }
    }
    
    @objc func actionHandle(_ sender: UIButton) {
        print("\(sender.titleLabel?.text ?? "")按钮被点击")
        let tag = sender.tag - 1000
        if tag == 0 {
        } else if tag == 1 {
        } else if tag == 2 {
        } else if tag == 3 {
        }
    }
}
