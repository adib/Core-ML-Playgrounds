import Foundation
import XCTest

public class PlaygroundTestObserver : NSObject,XCTestObservation {
    override public init() {
        print("playground observer")
    }
    
    public func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        print("observed failure")

        // https://medium.com/@johnsundell/writing-unit-tests-in-swift-playgrounds-9f5b6cdeb5f7
        assertionFailure(description, line: UInt(lineNumber) )
    }
}
