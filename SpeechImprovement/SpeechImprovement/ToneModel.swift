//
//  ToneModel.swift
//  SpeechImprovement
//
//  Created by Maanik Gogna on 2023-05-24.
//

import Foundation
import AVFoundation
import CoreML
import SoundAnalysis

let defaultConfig = MLModelConfiguration()
//let toneClassifier = try! toneModel(configuration: defaultConfig)
//let toneClassifier = try! SpeechImprovement_ML_12(configuration: defaultConfig)
//let toneClassifier = try! SpeechImprovement_ML_13(configuration: defaultConfig)
//let toneClassifier = try! SpeechImprovement_ML_14(configuration: defaultConfig)

//SpeechImprovement_ML_10 model has 100% training, 93% accuracy (25 iterations, 5.0 sec window duration, 75% window overlap)
let toneClassifier = try! SpeechImprovement_ML_10(configuration: defaultConfig)
//let speedClassifier = try! speedModel(configuration: defaultConfig)
//let volumeClassifier try! volumeModel(configuration: defaultConfig)
//let clarityClassifier try! clarityModel(configuration: defaultConfig)
let classifyToneSoundReq = try! SNClassifySoundRequest(mlModel: toneClassifier.model)
let resultsObserver = ResultsObserver()
var resultDict: [String:Double] = [:]

//TODO: COMMENTED OUT PRINTING FOR CLARITY
/// An observer that receives results from a classify sound request.
class ResultsObserver: NSObject, SNResultsObserving {
    /// Notifies the observer when a request generates a prediction.
    func request(_ request: SNRequest, didProduce result: SNResult) {
        // Downcast the result to a classification result.
        guard let result = result as? SNClassificationResult else  { return }

        // Get the prediction with the highest confidence.
//        guard let classification = result.classifications.first else { return }
        let classification = result.classifications
        // Get the starting time.
        let timeInSeconds = result.timeRange.start.seconds
        let endTime = result.timeRange.end.seconds

        // Convert the time to a human-readable string.
        
        let formattedTime = String(format: "%.2f", timeInSeconds)
        //COMMENTED OUT
        print("Analysis result for audio at time: \(formattedTime) - \(String(format:"%.2f", endTime))")

        for classif in classification{
            let percent = classif.confidence * 100.0
            let percentString = String(format: "%.2f%%", percent)

            if let value = resultDict[classif.identifier]{
                resultDict[classif.identifier] = value + classif.confidence*result.timeRange.duration.seconds
            }
            else{
                resultDict[classif.identifier] = classif.confidence*result.timeRange.duration.seconds
            }

            //COMMENTED OUT
            if (round(percent) != 0){
                print("\(classif.identifier): \(percentString) confidence.")
            }
        }
        
        // Convert the confidence to a percentage string.
//        let percent = classification.confidence * 100.0
//        let percentString = String(format: "%.2f%%", percent)

        // Print the classification's name (label) with its confidence.
//        print("\(classification.identifier): \(percentString) confidence.\n")
    }
    
    /// Notifies the observer when a request generates an error.
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The analysis failed: \(error.localizedDescription)")
    }

    /// Notifies the observer when a request is complete.
    func requestDidComplete(_ request: SNRequest) {
        print("The sound classifier request completed successfully!")
        print(resultDict)
    }
}

/// Creates an analyzer for an audio file.
/// - Parameter audioFileURL: The URL to an audio file.
func createAnalyzer(audioFileURL: URL) -> SNAudioFileAnalyzer? {
    return try? SNAudioFileAnalyzer(url: audioFileURL)
}
