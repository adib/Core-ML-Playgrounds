/*:
 VGG16 Model Wrapper
 
 *K. Simonyan, A. Zisserman*
 **Very Deep Convolutional Networks for Large-Scale Image Recognition**
 arXiv technical report, 2014
 
 http://www.robots.ox.ac.uk/~vgg/research/very_deep/
 */
import CoreML


/// Model Prediction Input Type
public class VGG16Input : MLFeatureProvider {

    /// Input image to be classified as BGR image buffer, 224 pixels wide by 224 pixels high
    var image: CVPixelBuffer
    
    public var featureNames: Set<String> {
        get {
            return ["image"]
        }
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "image") {
            return MLFeatureValue(pixelBuffer: image)
        }
        return nil
    }
    
    public init(image: CVPixelBuffer) {
        self.image = image
    }
}


/// Model Prediction Output Type
public class VGG16Output : MLFeatureProvider {

    /// Probability of each category as dictionary of strings to doubles
    public let classLabelProbs: [String : Double]

    /// Most likely image category as string value
    public let classLabel: String
    
    public var featureNames: Set<String> {
        get {
            return ["classLabelProbs", "classLabel"]
        }
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "classLabelProbs") {
            return try! MLFeatureValue(dictionary: classLabelProbs as [NSObject : NSNumber])
        }
        if (featureName == "classLabel") {
            return MLFeatureValue(string: classLabel)
        }
        return nil
    }
    
    public init(classLabelProbs: [String : Double], classLabel: String) {
        self.classLabelProbs = classLabelProbs
        self.classLabel = classLabel
    }
}


/// Class for model loading and prediction
public class VGG16 {
    var model: MLModel

    /**
        Construct a model with explicit path to mlmodel file
        - parameters:
           - url: the file url of the model
           - throws: an NSError object that describes the problem
    */
    public init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }

    /// Construct a model that automatically loads the model from the app's bundle
    public convenience init() {
        let bundle = Bundle(for: VGG16.self)
        let assetPath = bundle.url(forResource: "VGG16", withExtension:"mlmodelc")
        try! self.init(contentsOf: assetPath!)
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as VGG16Input
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as VGG16Output
    */
    public func prediction(input: VGG16Input) throws -> VGG16Output {
        let outFeatures = try model.prediction(from: input)
        let result = VGG16Output(classLabelProbs: outFeatures.featureValue(for: "classLabelProbs")!.dictionaryValue as! [String : Double], classLabel: outFeatures.featureValue(for: "classLabel")!.stringValue)
        return result
    }

    /**
        Make a prediction using the convenience interface
        - parameters:
            - image: Input image to be classified as BGR image buffer, 224 pixels wide by 224 pixels high
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as VGG16Output
    */
    public func prediction(image: CVPixelBuffer) throws -> VGG16Output {
        let input_ = VGG16Input(image: image)
        return try self.prediction(input: input_)
    }
}
