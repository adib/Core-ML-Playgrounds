//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport
import CoreVideo

var str = "Hello, playground"
//let bundle = Bundle.main.URL(forResource: "elephant-africa-african-elephant-kenya-70080", ofType: "jpeg")
let inputImage = #imageLiteral(resourceName: "dog_320x240.png")

// https://stackoverflow.com/a/44422838/199360

// Inceptionv3 Input image to be classified as RGB image buffer, 299 pixels wide by 224 pixels high
let inputWidth=299, inputHeight=299

let pixelBufferAttributes = [
    kCVPixelBufferCGImageCompatibilityKey : kCFBooleanTrue,
    kCVPixelBufferCGBitmapContextCompatibilityKey : kCFBooleanTrue
] as CFDictionary

var pixelBuffer = nil as CVPixelBuffer?
let createError = CVPixelBufferCreate(kCFAllocatorDefault, inputWidth, inputHeight, kCVPixelFormatType_32ARGB, pixelBufferAttributes, &pixelBuffer)

if createError == 0 {
    CVPixelBufferLockBaseAddress(pixelBuffer!,CVPixelBufferLockFlags(rawValue:0))
    defer {
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue:0))
    }
    let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer!)
    if let context = CGContext(data: pixelData,
                               width: Int(inputWidth),
                               height: Int(inputHeight),
                               bitsPerComponent: 8,
                               bytesPerRow: bytesPerRow,
                               space: rgbColorSpace,
                               bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) {
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
        
        do {
            let inceptionInput = Inceptionv3Input(image: pixelBuffer!)
            let inceptionModel = Inceptionv3()
            let inceptionOutput = try inceptionModel.prediction(input: inceptionInput)
            print("Inception model says image is: \(inceptionOutput.classLabel)")
        } catch let error as NSError {
            print("inception model error: \(error)")
        }


    } else {
        print("Error creating context")
    }
    
} else {
    // Probably pixel format not supported.
    // https://stackoverflow.com/questions/8029497/how-do-i-create-a-cvpixelbuffer-with-32rgba-format-for-iphone/8029701#8029701
    print("create error: \(createError)")
}


//: [Next](@next)
