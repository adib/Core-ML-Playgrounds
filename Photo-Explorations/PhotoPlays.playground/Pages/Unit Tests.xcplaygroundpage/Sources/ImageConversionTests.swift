import Foundation
import XCTest

public class ImageConversionTests : XCTestCase {
    func testAfricanElephant() throws {
        let inputImage = #imageLiteral(resourceName: "elephant-africa-african-elephant-kenya-70080.jpeg")
        guard let pixelBuffer = makePixelBuffer(image: inputImage, width:299, height: 299) else {
            XCTFail("Could not create pixel buffer")
            return
        }
        let model = Inceptionv3()
        var classLabel = ""
        self.measure({
            do {
                let predictionResult = try model.prediction(image: pixelBuffer)
                classLabel = predictionResult.classLabel
            } catch let e {
                XCTFail("Exception thrown during prediction: \(e)")
            }
        })
        XCTAssertEqual(classLabel,"African elephant, Loxodonta africana")
    }

    func testBluetick() throws {
        let inputImage = #imageLiteral(resourceName: "BluetickCoonhound.jpg")
        guard let pixelBuffer = makePixelBuffer(image: inputImage, width:224, height:224) else {
            XCTFail("Could not create pixel buffer")
            return
        }
        let model = VGG16()
        var classLabel = ""
        self.measure({
            do {
                let predictionResult = try model.prediction(image: pixelBuffer)
                classLabel = predictionResult.classLabel
            } catch let e {
                XCTFail("Exception thrown during prediction: \(e)")
            }
        })
        XCTAssertEqual(classLabel,"bluetick")
    }

}
