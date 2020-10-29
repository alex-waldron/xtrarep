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
        exerciseData = ExerciseDataModel(exerciseName: exerciseName)
        //Update interval frequency = 5 Hz
        motionManager.accelerometerUpdateInterval = 1.0/5.0
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {(data, error) in
            if let data = data{
                exerciseData?.accelData?.append(XYZ(x: data.acceleration.x, y: data.acceleration.y, z: data.acceleration.z))
            }
            
        })
        
        
        globalExerciseData = exerciseData
    }
    
    func getExerciseData() -> ExerciseDataModel? {
        return globalExerciseData
    }
}
