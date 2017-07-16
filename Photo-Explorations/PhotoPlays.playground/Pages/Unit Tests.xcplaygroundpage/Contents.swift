//: [Previous](@previous)

import Foundation
import XCTest

let testObserver = PlaygroundTestObserver()
XCTestObservationCenter.shared.addTestObserver(testObserver)

//: Test ML models against known images and known results.

ImageConversionTests.defaultTestSuite.run()

//: [Next](@next)
