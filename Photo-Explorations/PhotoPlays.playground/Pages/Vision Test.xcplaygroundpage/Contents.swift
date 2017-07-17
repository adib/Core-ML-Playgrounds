//: [Previous](@previous)
import Foundation
import UIKit
import Vision

var str = "Hello, playground"
let inputImage = #imageLiteral(resourceName: "pexels-photo-109919.jpeg")


let faceLandmarkRequest = VNDetectFaceLandmarksRequest { (request : VNRequest , error : Error?) in
    guard let faceRequest = request as? VNDetectFaceLandmarksRequest else {
        print("unknown request type: \(request)")
        return
    }
    
}

//let requestHandler = VNImageRequestHandler(cgImage:inputImage.cgImage!,options:[:])


//: [Next](@next)
