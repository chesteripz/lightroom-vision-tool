//
//  main.swift
//  vision-tool
//
//  Created by User on 28/10/2021.
//

import Foundation
import Cocoa
import Vision

func process(urlString: String) -> [String: Float]{
    let url = URL(fileURLWithPath: urlString)
    print(url.path)

    // Classify the images
    let request = VNClassifyImageRequest()
    let handler = VNImageRequestHandler(url: url, options: [:])
    try? handler.perform([request])

    let categories: [String: VNConfidence]
    guard let observations = request.results else {return[:]}
    categories = observations
        .filter { $0.hasMinimumPrecision(0.01, forRecall: 0.7) }
        .reduce(into: [String: VNConfidence]()) { dict, observation in dict[observation.identifier] = observation.confidence }

    return categories
}


func main(){
    print("Core ML Vision Classifier")

    print("Input: \(CommandLine.arguments.count - 2) file(s)")
    var argCount = 0;
    var results = [String: [String: Float]]();
    var path: String = "results.json";

    for argument in CommandLine.arguments {
        if (argCount > 1){
            let result = process(urlString: argument)
            if (result.count > 0){
                results[argument] = result
            }
        } else if (argCount == 1){
            path = argument
        }
        argCount += 1
    }
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: results, options: .prettyPrinted)
        let output = URL(fileURLWithPath: path)
        try jsonData.write(to: output)
    } catch {
        print("Error writing result")
    }
    print("Finished processing")
}

main()
