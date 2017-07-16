import Foundation
import CoreVideo
import UIKit

public func makePixelBuffer(image inputImage: UIImage, width inputWidth: Int, height inputHeight: Int) -> CVPixelBuffer? {
    
    let pixelBufferAttributes = [
        kCVPixelBufferCGImageCompatibilityKey : kCFBooleanTrue,
        kCVPixelBufferCGBitmapContextCompatibilityKey : kCFBooleanTrue
        ] as CFDictionary
    
    var pixelBuffer = nil as CVPixelBuffer?
    let createError = CVPixelBufferCreate(kCFAllocatorDefault, inputWidth, inputHeight, kCVPixelFormatType_32ARGB, pixelBufferAttributes, &pixelBuffer)
    guard createError == 0, pixelBuffer != nil else {
        print("Error creating pixel buffer: \(createError)")
        return nil
    }
    
    CVPixelBufferLockBaseAddress(pixelBuffer!,CVPixelBufferLockFlags(rawValue:0))
    defer {
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue:0))
    }
    
    let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
    
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer!)
    guard let context = CGContext(data: pixelData,
                               width: Int(inputWidth),
                               height: Int(inputHeight),
                               bitsPerComponent: 8,
                               bytesPerRow: bytesPerRow,
                               space: rgbColorSpace,
                               bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
        print("Error creating image context")
        return nil
    }
    context.translateBy(x: 0, y: CGFloat(inputHeight))
    context.scaleBy(x: 1.0, y: -1.0)
        
    let targetRect : CGRect
    let sourceSize = inputImage.size
    if sourceSize.height > sourceSize.width {
        // tall image
        let targetHeight = CGFloat(inputHeight)
        let targetWidth = sourceSize.width * targetHeight / sourceSize.height
        let x = (CGFloat(inputWidth) - targetWidth) / 2
        targetRect = CGRect(x: x,y: 0, width:targetWidth, height:targetHeight)
    } else {
        // wide image or square
        let targetWidth = CGFloat(inputWidth)
        let targetHeight = sourceSize.height * targetWidth / sourceSize.width
        let y = (CGFloat(inputHeight) - targetHeight) / 2
        targetRect = CGRect(x: 0,y: y, width:targetWidth, height:targetHeight)
    }
        
    UIGraphicsPushContext(context)
    inputImage.draw(in: targetRect)
    UIGraphicsPopContext()

    return pixelBuffer
}
