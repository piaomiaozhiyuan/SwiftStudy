//
//  CGImageStudyManager.swift
//  SwiftStudyAndAccumulation
//
//  Created by wangzhen on 2017/4/7.
//  Copyright © 2017年 mapbar. All rights reserved.
//

import UIKit
import CoreGraphics
import QuartzCore

class CGImageManager: NSObject {
    
    class func createCGImage(image: UIImage?) -> CGImage? {
        
        var cgImageResult: CGImage? = nil
        
        guard let cgimage = image?.cgImage else {
            return cgImageResult
        }
//
//        /*
//         参数1:
//         
//         
//         */
        let width = cgimage.width
        let height = cgimage.height
//
//        if 1 == 1 {
//            
//        }
//        
//        
////        let cgImageMask: CGImage = CGImage(maskWidth: maskWidth,
////                                       height: height,
////                                       bitsPerComponent: 4,
////                                       bitsPerPixel: 4*8,
////                                       bytesPerRow: maskWidth * 4,
////                                       provider: CGDataProvider,
////                                       decode: nil,
////                                       shouldInterpolate: false)
//        
////        let cgImage: CGImage
//        
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let rawPointer = UnsafeMutableRawPointer.allocate(bytes: width * height * 4, alignedTo: Int(UINT32_MAX))
        /**RGBA*/
//         let cgImage: CGImage = CGImage(width: width,
//                                        height: height,
//                                        bitsPerComponent: 8,
//                                        bitsPerPixel: 4 * 8,
//                                        bytesPerRow: width * 4,
//                                        space: colorSpace,
//                                        bitmapInfo: CGBitmapInfo.byteOrder32Big,
//                                        provider: CGDataProvider,
//                                        decode: <#T##UnsafePointer<CGFloat>?#>,
//                                        shouldInterpolate: true,
//                                        intent: CGColorRenderingIntent.defaultIntent)
        
        if let context: CGContext = CGContext(data: rawPointer,
                                              width: width,
                                              height: height,
                                              bitsPerComponent: 8,
                                              bytesPerRow: width * 4,
                                              space: cgimage.colorSpace!,
                                              bitmapInfo: cgimage.bitmapInfo.rawValue) {
            
            if let cgImage = context.makeImage() {
                cgImageResult = cgImage
            }
            
        }
        
        rawPointer.deallocate(bytes: width * height * 4, alignedTo: Int(UINT32_MAX))
        
        return cgImageResult
    }

}
