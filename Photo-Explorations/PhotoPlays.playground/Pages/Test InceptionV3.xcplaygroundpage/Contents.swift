//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport
import CoreVideo

let inputImage = #imageLiteral(resourceName: "elephant-africa-african-elephant-kenya-70080.jpeg")

// https://stackoverflow.com/a/44422838/199360

// Inceptionv3 Input image to be classified as RGB image buffer, 299 pixels wide by 224 pixels high
let inputWidth=299, inputHeight=299

if let pixelBuffer = makePixelBuffer(image: inputImage, width: inputWidth, height: inputHeight) {
    do {
        let inceptionInput = Inceptionv3Input(image: pixelBuffer)
        let inceptionModel = Inceptionv3()
        let inceptionOutput = try inceptionModel.prediction(input: inceptionInput)
        print("Inception model says image is: \(inceptionOutput.classLabel)")
    } catch let error as NSError {
        print("inception model error: \(error)")
    }
} else {
    print("Failed to create pixel buffer")
}


//: [Next](@next)
