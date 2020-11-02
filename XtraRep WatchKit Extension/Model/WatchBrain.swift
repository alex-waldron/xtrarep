//
//  WatchBrain.swift
//  XtraRep WatchKit Extension
//
//  Created by Alex Waldron on 10/28/20.
//

import Foundation
import CoreMotion

class WatchBrain{
    var exerciseData:ExerciseDataModel = ExerciseDataModel(exerciseType: nil, accelData: [])
    func startCollectingData(exerciseName: String, motionManager: CMMotionManager){
        print("Start collecting data")
        var count = 0
        //setup data model
        exerciseData.exerciseType = exerciseName
        
        //Update interval frequency = 20 Hz
        motionManager.accelerometerUpdateInterval = 1.0/20.0
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {(data, error) in
            //TEST
            //var accelData = exerciseData!.data[K.dataDict.accelKey] as! [Any]
            
            
            
            
             //TRUE FUNCTIONALLITY
             
            if let data = data{
                print(data.acceleration.x)
                count += 1
                print(count)
                self.exerciseData.accelData.append(["x": data.acceleration.x, "y": data.acceleration.y, "z": data.acceleration.z])
                
                
            } else{
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    print("exerciseData is empty")
                }
            }
 
        }
 
        )
        
        
    }
    
    func getExerciseData() -> ExerciseDataModel? {
        
        return exerciseData
    }
    func resetExerciseData(){
        exerciseData = ExerciseDataModel(exerciseType: nil, accelData: [])
    }
}
