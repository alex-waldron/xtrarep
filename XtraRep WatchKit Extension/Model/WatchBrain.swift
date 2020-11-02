//
//  WatchBrain.swift
//  XtraRep WatchKit Extension
//
//  Created by Alex Waldron on 10/28/20.
//

import Foundation
import CoreMotion

struct WatchBrain{
    var globalExerciseData:ExerciseDataModel?
    mutating func startCollectingData(exerciseName: String, motionManager: CMMotionManager){
        var exerciseData:ExerciseDataModel?
        print("Start collecting data")
        
        //setup data model
        exerciseData = ExerciseDataModel(exerciseType: exerciseName, accelData: [])
        
        //Update interval frequency = 5 Hz
        motionManager.accelerometerUpdateInterval = 1.0/5.0
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {(data, error) in
            //TEST
            //var accelData = exerciseData!.data[K.dataDict.accelKey] as! [Any]
            
            
            
            
             //TRUE FUNCTIONALLITY
             
            if let data = data{
                
                exerciseData?.accelData.append(["x": data.acceleration.x, "y": data.acceleration.y, "z": data.acceleration.z])
                
                
            } else{
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    print("exerciseData is empty")
                }
            }
 
        }
 
        )
        
        
        globalExerciseData = exerciseData
    }
    
    func getExerciseData() -> ExerciseDataModel? {
        return globalExerciseData
    }
}
