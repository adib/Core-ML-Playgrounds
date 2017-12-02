//
//  UIImage+MultiArray.swift
//  waifu2x-ios
//
//  Created by xieyi on 2017/9/14.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import AppKit
import CoreML

extension CGImage {
    
    /// Expand the original image by shrink_size and store rgb in float array.
    /// The model will shrink the input image by 7 px.
    ///
    /// - Returns: Float array of rgb values
    public func expand() -> [Float] {
        let startTime = Date.timeIntervalSinceReferenceDate

        let width = Int(self.width)
        let height = Int(self.height)
        
        let exwidth = width + 2 * shrink_size
        let exheight = height + 2 * shrink_size
        
        let pixels = self.dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixels!)
        
        var arr = [Float](repeating: 0, count: 3 * exwidth * exheight)
        
        var xx, yy, pixel: Int
        var r, g, b: UInt8
        var fr, fg, fb: Float
        // http://www.jianshu.com/p/516f01fed6e4
        for y in 0..<height {
            for x in 0..<width {
                xx = x + shrink_size
                yy = y + shrink_size
                pixel = (width * y + x) * 4
                r = data[pixel]
                g = data[pixel + 1]
                b = data[pixel + 2]
                // !!! rgb values are from 0 to 1
                // https://github.com/chungexcy/waifu2x-new/blob/master/image_test.py
                fr = Float(r) / 255
                fg = Float(g) / 255
                fb = Float(b) / 255
                arr[yy * exwidth + xx] = fr
                arr[yy * exwidth + xx + exwidth * exheight] = fg
                arr[yy * exwidth + xx + exwidth * exheight * 2] = fb
            }
        }
        // Top-left corner
        pixel = 0
        r = data[pixel]
        g = data[pixel + 1]
        b = data[pixel + 2]
        fr = Float(r) / 255
        fg = Float(g) / 255
        fb = Float(b) / 255
        for y in 0..<shrink_size {
            for x in 0..<shrink_size {
                arr[y * exwidth + x] = fr
                arr[y * exwidth + x + exwidth * exheight] = fg
                arr[y * exwidth + x + exwidth * exheight * 2] = fb
            }
        }
        // Top-right corner
        pixel = (width - 1) * 4
        r = data[pixel]
        g = data[pixel + 1]
        b = data[pixel + 2]
        fr = Float(r) / 255
        fg = Float(g) / 255
        fb = Float(b) / 255
        for y in 0..<shrink_size {
            for x in width+shrink_size..<width+2*shrink_size {
                arr[y * exwidth + x] = fr
                arr[y * exwidth + x + exwidth * exheight] = fg
                arr[y * exwidth + x + exwidth * exheight * 2] = fb
            }
        }
        // Bottom-left corner
        pixel = (width * (height - 1)) * 4
        r = data[pixel]
        g = data[pixel + 1]
        b = data[pixel + 2]
        fr = Float(r) / 255
        fg = Float(g) / 255
        fb = Float(b) / 255
        for y in height+shrink_size..<height+2*shrink_size {
            for x in 0..<shrink_size {
                arr[y * exwidth + x] = fr
                arr[y * exwidth + x + exwidth * exheight] = fg
                arr[y * exwidth + x + exwidth * exheight * 2] = fb
            }
        }
        // Bottom-right corner
        pixel = (width * (height - 1) + (width - 1)) * 4
        r = data[pixel]
        g = data[pixel + 1]
        b = data[pixel + 2]
        fr = Float(r) / 255
        fg = Float(g) / 255
        fb = Float(b) / 255
        for y in height+shrink_size..<height+2*shrink_size {
            for x in width+shrink_size..<width+2*shrink_size {
                arr[y * exwidth + x] = fr
                arr[y * exwidth + x + exwidth * exheight] = fg
                arr[y * exwidth + x + exwidth * exheight * 2] = fb
            }
        }
        // Top & bottom bar
        for x in 0..<width {
            pixel = x * 4
            r = data[pixel]
            g = data[pixel + 1]
            b = data[pixel + 2]
            fr = Float(r) / 255
            fg = Float(g) / 255
            fb = Float(b) / 255
            xx = x + shrink_size
            for y in 0..<shrink_size {
                arr[y * exwidth + xx] = fr
                arr[y * exwidth + xx + exwidth * exheight] = fg
                arr[y * exwidth + xx + exwidth * exheight * 2] = fb
            }
            pixel = (width * (height - 1) + x) * 4
            r = data[pixel]
            g = data[pixel + 1]
            b = data[pixel + 2]
            fr = Float(r) / 255
            fg = Float(g) / 255
            fb = Float(b) / 255
            xx = x + shrink_size
            for y in height+shrink_size..<height+2*shrink_size {
                arr[y * exwidth + xx] = fr
                arr[y * exwidth + xx + exwidth * exheight] = fg
                arr[y * exwidth + xx + exwidth * exheight * 2] = fb
            }
        }
        // Left & right bar
        for y in 0..<height {
            pixel = (width * y) * 4
            r = data[pixel]
            g = data[pixel + 1]
            b = data[pixel + 2]
            fr = Float(r) / 255
            fg = Float(g) / 255
            fb = Float(b) / 255
            yy = y + shrink_size
            for x in 0..<shrink_size {
                arr[yy * exwidth + x] = fr
                arr[yy * exwidth + x + exwidth * exheight] = fg
                arr[yy * exwidth + x + exwidth * exheight * 2] = fb
            }
            pixel = (width * y + (width - 1)) * 4
            r = data[pixel]
            g = data[pixel + 1]
            b = data[pixel + 2]
            fr = Float(r) / 255
            fg = Float(g) / 255
            fb = Float(b) / 255
            yy = y + shrink_size
            for x in width+shrink_size..<width+2*shrink_size {
                arr[yy * exwidth + x] = fr
                arr[yy * exwidth + x + exwidth * exheight] = fg
                arr[yy * exwidth + x + exwidth * exheight * 2] = fb
            }
        }
        
        let endTime = Date.timeIntervalSinceReferenceDate
        print("cgimage-expand: ",endTime - startTime)

        return arr
    }
    
}
