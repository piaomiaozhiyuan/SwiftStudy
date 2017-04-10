//
//  CGImageStudyViewController.swift
//  SwiftStudyAndAccumulation
//
//  Created by wangzhen on 2017/4/7.
//  Copyright © 2017年 mapbar. All rights reserved.
//

import UIKit

/// 用于学习CGImage
class CGImageStudyViewController: BaseViewController {
    
    var imageView: UIImageView!
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "学习CGImage"
        
        createUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("CGImageStudyViewController对象已销毁")
    }
    
    func createUI() {
        
        // 按钮创建
        let lookImagePropertiesButton: UIButton = UIButton(frame: CGRect(x: 0, y: 90, width: 44, height: 44))
        lookImagePropertiesButton.setTitle("截图", for: .normal)
        lookImagePropertiesButton.backgroundColor = UIColor.red
        lookImagePropertiesButton.addTarget(self, action: #selector(lookImagePropertiesButtonClick(_:)), for: .touchUpInside)
        self.view.addSubview(lookImagePropertiesButton)
        
        
        let lookImagePropertiesButton1: UIButton = UIButton(frame: CGRect(x: 190, y: 90, width: 44, height: 44))
        lookImagePropertiesButton1.setTitle("1234", for: .normal)
        lookImagePropertiesButton1.backgroundColor = UIColor.green
        lookImagePropertiesButton1.addTarget(self, action: #selector(lookButtonClick(_:)), for: .touchUpInside)
        self.view.addSubview(lookImagePropertiesButton1)
        // 图片创建
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 200, width: 200, height: 200))
        imageView.image = UIImage(named: "test2")
        self.view.addSubview(imageView)
        
        
    }
    
    // MARK: - 点击事件
    
    /// 查看image属性
    func lookImagePropertiesButtonClick(_ sender: UIButton) {
        if let image: UIImage = UIImage(named: "test1") {
            if let temImg: CGImage = image.cgImage {
                
                //根据范围截图
                if let temImg = temImg.cropping(to: CGRect(x: 100, y: 100, width: 100, height: 100)) {
                    let image_new = UIImage(cgImage: temImg)
                    imageView.image = image_new
                }
                
            }
        }
    }
    
    
    func lookButtonClick(_ sender: UIButton) {
//        if let image: UIImage = UIImage(named: "png1") {
//            
//        }
        
        if let cgimage = CGImageManager.createCGImage(image: UIImage(named: "png1")) {
           imageView.image = UIImage(cgImage: cgimage) 
        }
        
    }

}
