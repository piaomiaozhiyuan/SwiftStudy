//
//  CGImageStudyManager.swift
//  SwiftStudyAndAccumulation
//
//  Created by wangzhen on 2017/4/7.
//  Copyright © 2017年 mapbar. All rights reserved.
//

import UIKit
import CoreGraphics

class CGImageStudyManager: NSObject {
    
    func createCGImage(image: UIImage?) {
        
        guard let cgimage = image?.cgImage else {
            return
        }
        
        /*
         参数1:
         
         
         */
        let maskWidth = cgimage.width
        let height = cgimage.height

        if 1 == 1 {
            
        }
        
        
        let cgImage: CGImage = CGImage(maskWidth: maskWidth,
                                       height: height,
                                       bitsPerComponent: 4,
                                       bitsPerPixel: 4*8,
                                       bytesPerRow: maskWidth * 4,
                                       provider: CGDataProvider,
                                       decode: nil,
                                       shouldInterpolate: false)
    }

}
