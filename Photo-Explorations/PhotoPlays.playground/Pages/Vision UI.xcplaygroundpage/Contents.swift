

//: [Previous](@previous)

import Foundation
import UIKit
import Vision
import PlaygroundSupport

class ViewController : UIViewController {
    
    var mainImage = #imageLiteral(resourceName: "pexels-photo-109919.jpeg")
    
    lazy var mainImageView = {
        () -> UIImageView in
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return imageView
    }()
    
    override func loadView() {
        mainImageView.image = mainImage
        
        let resetButton = UIButton(type: .plain)
        resetButton.addTarget(self, action: #selector(resetImage), for: .primaryActionTriggered)
        resetButton.setTitle(NSLocalizedString("Reset", comment: "Reset Button"), for: .normal)

        let faceRectanglesButton = UIButton(type: .plain)
        faceRectanglesButton.addTarget(self, action: #selector(detectFaceRectangles), for: .primaryActionTriggered)
        faceRectanglesButton.setTitle(NSLocalizedString("Face Rectangles", comment: "Recognize Button"), for: .normal)

        
        let recognizeButton = UIButton(type: .plain)
        recognizeButton.addTarget(self, action: #selector(detectFaceLandmarks), for: .primaryActionTriggered)
        recognizeButton.setTitle(NSLocalizedString("Face Landmarks", comment: "Recognize Button"), for: .normal)
        
        let maskButton = UIButton(type: .plain)
        maskButton.addTarget(self, action: #selector(maskFaces), for: .primaryActionTriggered)
        maskButton.setTitle(NSLocalizedString("Mask", comment: "Mask Button"), for: .normal)
        
        let buttonBar = UIStackView(arrangedSubviews:[resetButton,faceRectanglesButton,recognizeButton,maskButton])
        buttonBar.axis = .horizontal
        buttonBar.distribution = .fillEqually
        buttonBar.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        let rootStackView = UIStackView(arrangedSubviews:[mainImageView,buttonBar])
        rootStackView.axis = .vertical
        rootStackView.distribution = .fill
        
        self.view = rootStackView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func resetImage() {
        print("Reset image")
        mainImageView.image = mainImage
    }
    
    @IBAction func detectFaceRectangles() throws {
        print("detect face rectangles")
        let image = mainImage
        let faceFeaturesRequest = VNDetectFaceRectanglesRequest { (request : VNRequest, error : Error?) in
            
            let imageSize = image.size
            UIGraphicsBeginImageContextWithOptions(imageSize, true, 1)
            let currentContext = UIGraphicsGetCurrentContext()!
            defer {
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                DispatchQueue.main.async {
                    self.mainImageView.image = resultImage
                }
            }
            
            image.draw(in: CGRect(origin: CGPoint(x:0,y:0), size: imageSize))
            
            // Translate to cartesian
            currentContext.translateBy(x: 0, y: imageSize.height)
            currentContext.scaleBy(x: 1.0, y: -1.0)
            
            let faceBoxColor = UIColor.magenta
            currentContext.setStrokeColor(faceBoxColor.cgColor)
            currentContext.setLineWidth(4)
            
            for observation in request.results! {
                if let faceObservation = observation as? VNFaceObservation {
                    let boundingBox = faceObservation.boundingBox
                    let rectBox = CGRect(x: boundingBox.origin.x * imageSize.width, y: boundingBox.origin.y * imageSize.height,width:boundingBox.size.width * imageSize.width, height: boundingBox.size.height * imageSize.height)
                    print("boundingBox: \(boundingBox) rectBox: \(rectBox)")
                    currentContext.stroke(rectBox)
                }
            }
            
        }
        
        let requestHandler = VNImageRequestHandler(cgImage:image.cgImage! , options: [:])
        try requestHandler.perform([faceFeaturesRequest])
    }

    
    @IBAction func detectFaceLandmarks() throws {
        print("detect face landmarks")
        let image = mainImage
        let faceFeaturesRequest = VNDetectFaceLandmarksRequest { (request : VNRequest, error : Error?) in
            
            let imageSize = image.size
            UIGraphicsBeginImageContextWithOptions(imageSize, true, 1)
            let currentContext = UIGraphicsGetCurrentContext()!
            defer {
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                DispatchQueue.main.async {
                    self.mainImageView.image = resultImage
                }
            }
            
            image.draw(in: CGRect(origin: CGPoint(x:0,y:0), size: imageSize))
            
            // Translate to cartesian
            currentContext.translateBy(x: 0, y: imageSize.height)
            currentContext.scaleBy(x: 1.0, y: -1.0)

            
            let faceBoxColor = UIColor.green
            currentContext.setStrokeColor(faceBoxColor.cgColor)
            currentContext.setLineWidth(4)
            
            for observation in request.results! {
                if let faceObservation = observation as? VNFaceObservation {
                    let boundingBox = faceObservation.boundingBox
                    let rectBox = CGRect(x: boundingBox.origin.x * imageSize.width, y: boundingBox.origin.y * imageSize.height,width:boundingBox.size.width * imageSize.width, height: boundingBox.size.height * imageSize.height)
                    print("boundingBox: \(boundingBox) rectBox: \(rectBox)")
                    currentContext.stroke(rectBox)
                }
            }
            
        }
        
        let requestHandler = VNImageRequestHandler(cgImage:image.cgImage! , options: [:])
        try requestHandler.perform([faceFeaturesRequest])
    }

    @IBAction func maskFaces() {
        print("Mask faces")
    }
    
}

let viewController = ViewController()
viewController.preferredContentSize = CGSize(width: 600, height: 600)
PlaygroundPage.current.liveView = viewController
PlaygroundPage.current.needsIndefiniteExecution

//: [Next](@next)
