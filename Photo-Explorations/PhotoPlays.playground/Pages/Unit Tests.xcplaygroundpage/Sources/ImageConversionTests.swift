import Foundation
import XCTest

public class ImageConversionTests : XCTestCase {
    func testAfricanElephant() throws {
        let inputImage = #imageLiteral(resourceName: "elephant-africa-african-elephant-kenya-70080.jpeg")
        guard let pixelBuffer = makePixelBuffer(image: inputImage, width:299, height: 299) else {
            XCTFail("Could not create pixel buffer")
            return
        }
        let predictionResult = try Inceptionv3().prediction(image: pixelBuffer)
        XCTAssertEqual(predictionResult.classLabel,"African elephant, Loxodonta africana")
    }

    func testBluetick() throws {
        let inputImage = #imageLiteral(resourceName: "BluetickCoonhound.jpg")
        guard let pixelBuffer = makePixelBuffer(image: inputImage, width:224, height:224) else {
            XCTFail("Could not create pixel buffer")
            return
        }
        let predictionResult = try VGG16().prediction(image: pixelBuffer)
        XCTAssertEqual(predictionResult.classLabel,"bluetick")
    }

}
