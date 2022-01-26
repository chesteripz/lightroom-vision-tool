import ArgumentParser
import Cocoa
import Foundation
import SQLite3
import Vision

func process(urlString: String) -> [String: Float] {
  let url = URL(fileURLWithPath: urlString)

  // Classify the images
  let request = VNClassifyImageRequest()
  let handler = VNImageRequestHandler(url: url, options: [:])
  try? handler.perform([request])

  let categories: [String: VNConfidence]
  guard let observations = request.results else { return [:] }
  categories =
    observations
    .filter { $0.hasMinimumPrecision(0.01, forRecall: 0.7) }
    .reduce(into: [String: VNConfidence]()) { dict, observation in
      dict[observation.identifier] = observation.confidence
    }

  return categories
}

@main
struct TagPhoto: ParsableCommand {
  @Argument(help: "Output path.")
  var output: String

  @Argument(help: "A group of images to operate on.")
  var paths: [String] = []

  mutating func run() throws {
    print("Core ML Vision Image Classifier")
    print("Input: \(paths.count) file(s)")

    var results = [String: [String: Float]]()

    for (index, argument) in paths.enumerated() {
      print("[\(index + 1)/\(paths.count)] \(argument)")
      let result = process(urlString: argument)
      if result.count > 0 {
        results[argument] = result
      }
    }
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: results, options: .prettyPrinted)
      let output = URL(fileURLWithPath: output)
      try jsonData.write(to: output)
    } catch {
      print("Error writing result")
    }
    print("Finished processing \(paths.count) file(s)")
  }
}
