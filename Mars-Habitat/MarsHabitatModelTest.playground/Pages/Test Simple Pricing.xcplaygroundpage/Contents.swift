/*:
 # Mars Habitat Pricer
 
 Given the number of solar panels, greenhouses, and size of a martian property, predict how much will the price be.
 This illustrates the simplest way to use a Core ML model.
 
 The model was taken from  [Mars Habitat Price Predictor](https://developer.apple.com/documentation/coreml/integrating_a_core_ml_model_into_your_app).

 */

//: Construct the ML model object.
let pricer = MarsHabitatPricer()

//: Provide some input
let input = MarsHabitatPricerInput(solarPanels: 10, greenhouses: 12, size: 13)
//: Make prediction
let output = try pricer.prediction(input: input)

//: Print the price
print("price: \(output.price)")

