//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport
import CoreVideo
import Accelerate

let inputImage = #imageLiteral(resourceName: "BluetickCoonhound.jpg")

// https://stackoverflow.com/a/44422838/199360


// Input image to be classified as BGR image buffer, 224 pixels wide by 224 pixels high
let inputWidth=224, inputHeight=224

if let pixelBuffer = makePixelBuffer(image: inputImage, width: inputWidth, height: inputHeight) {
    do {
        let vggInput = VGG16Input(image: pixelBuffer)
        let vggModel = VGG16()
        
        let vggOutput = try vggModel.prediction(input: vggInput)
        print("VGG16 model says image is: \(vggOutput.classLabel)")
    } catch let error as NSError {
        print("inception model error: \(error)")
    }
} else {
    print("Failed to create pixel buffer")
}


//: [Next](@next)
