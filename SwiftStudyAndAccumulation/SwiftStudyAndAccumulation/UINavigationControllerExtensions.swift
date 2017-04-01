//
//  UINavigationControllerExtensions.swift
//  iosNewNavi
//
//  Created by wangzhen on 17/3/27.
//  Copyright © 2017年 Mapbar Inc. All rights reserved.
//

import UIKit

// MARK: - 导航控制器扩展 @see AppDelegateUtil
extension UINavigationController {

    /*---扩展目的，控制根视图的方向，从而控制当前viewController的方向 start---*/
    // @note 如果当前视图与App的方向支持不同，需要在当前的ViewController重写下面属性
    
    override open var shouldAutorotate: Bool {
        return (self.viewControllers.last?.shouldAutorotate)!
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return (self.viewControllers.last?.supportedInterfaceOrientations)!
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return (self.viewControllers.last?.preferredInterfaceOrientationForPresentation)!
    }
    
    /*---扩展目的，控制根视图的方向，从而控制当前viewController的方向 end---*/
}
