/*:
 
 # Enlarge Image
 
 This playground is a proof-of-concept to enlarge images using an ML Model.
 It's a port of [waifu2x-ios](https://github.com/imxieyi/waifu2x-ios/tree/master/waifu2x) to macOS / AppKit.
 */
import Foundation
import AppKit

func CGImage(nsImage: NSImage) -> CGImage {
    let startTime = Date.timeIntervalSinceReferenceDate
    let imageSize = nsImage.size
    let width = Int(ceil(imageSize.width))
    let height = Int(ceil(imageSize.height));
    let bitsPerComponent = 8
    let componentsPerPixel = 4
    let bitmapInfo = CGBitmapInfo(rawValue:  CGImageAlphaInfo.noneSkipLast.rawValue)
    let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
    let bitmapContext = CGContext(data:nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: componentsPerPixel * width,space: colorSpace, bitmapInfo:bitmapInfo.rawValue)!

    let graphicsContext = NSGraphicsContext(cgContext:bitmapContext, flipped:false)
    let oldContext = NSGraphicsContext.current
    defer {
        NSGraphicsContext.current = oldContext
    }
    NSGraphicsContext.current = graphicsContext
    nsImage.draw(in: NSRect(x: 0, y: 0, width: width, height: height))
    let cgImage = bitmapContext.makeImage()!
    let endTime = Date.timeIntervalSinceReferenceDate
    print("convert-nsimage-to-cgimage: ",endTime - startTime)
    return cgImage
}

extension NSImage {
    convenience init(cgImage:CGImage) {
        self.init(cgImage: cgImage, size: NSMakeSize(CGFloat(cgImage.width), CGFloat(cgImage.height)))
    }
}

let image = #imageLiteral(resourceName: "Hollister_Municipal_Airport_photo_D_Ramey_Logan.jpg")
let cgImage = CGImage(nsImage: image)
NSImage(cgImage:cgImage)

let model = Model.photo_noise1_scale2x

let enlargedImage = cgImage.run(model: model,scale: 2 )!
let resultImage = NSImage(cgImage: enlargedImage)

