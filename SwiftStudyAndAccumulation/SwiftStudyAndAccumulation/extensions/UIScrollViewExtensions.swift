//
//  UIScrollViewExtensions

import UIKit


extension UIScrollView {
    var hh_insetT : CGFloat {
        
        get {
            return contentInset.top
        }
        
        set(newVal) {
            var inset = contentInset
            inset.top = newVal
            contentInset = inset
        }
    }
    
//    open var contentOffset: CGPoint {
//        get {
//            return CGPoint(x: 0, y: 0)
//        }
//    }
    
}
