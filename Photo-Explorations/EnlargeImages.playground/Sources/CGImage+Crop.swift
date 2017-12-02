//
//  UIImage+Crop.swift
//  waifu2x-ios
//
//  Created by xieyi on 2017/9/14.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import AppKit

extension CGImage {
    
    public func getCropRects() -> ([CGRect]) {
        let width = Int(self.width)
        let height = Int(self.height)
        let num_w = width / block_size
        let num_h = height / block_size
        let ex_w = width % block_size
        let ex_h = height % block_size
        var rects: [CGRect] = []
        for i in 0..<num_w {
            for j in 0..<num_h {
                let x = i * block_size
                let y = j * block_size
                let rect = CGRect(x: x, y: y, width: block_size, height: block_size)
                rects.append(rect)
            }
        }
        if ex_w > 0 {
            let x = width - block_size
            for i in 0..<num_h {
                let y = i * block_size
                let rect = CGRect(x: x, y: y, width: block_size, height: block_size)
                rects.append(rect)
            }
        }
        if ex_h > 0 {
            let y = height - block_size
            for i in 0..<num_w {
                let x = i * block_size
                let rect = CGRect(x: x, y: y, width: block_size, height: block_size)
                rects.append(rect)
            }
        }
        if ex_w > 0 && ex_h > 0 {
            let x = width - block_size
            let y = height - block_size
            let rect = CGRect(x: x, y: y, width: block_size, height: block_size)
            rects.append(rect)
        }
        return rects
    }
    
    public func crop(rects: [CGRect]) -> [CGImage] {
        var result: [CGImage] = []
        for rect in rects {
            result.append(crop(rect: rect))
        }
        return result
    }
    
    public func crop(rect: CGRect) -> CGImage {
//        let cgimg = cgImage?.cropping(to: rect)
//        return NSImage(cgImage: cgimg!)
        let cgimg = self.cropping(to: rect)
        return cgimg!
    }
    
}
