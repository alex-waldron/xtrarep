//
//  WatchBrain.swift
//  XtraRep WatchKit Extension
//
//  Created by Alex Waldron on 10/28/20.
//

import Foundation
import CoreMotion

class WatchBrain{
    var exerciseData:ExerciseDataModel = ExerciseDataModel(exerciseType: nil, accelData: [], gravityData: [], rotationData: [], attitudeData: [])
    func startCollectingData(exerciseName: String, motionManager: CMMotionManager){
        print("Start collecting data")
        var count = 0
        //setup data model
        exerciseData.exerciseType = exerciseName
        
        //Update interval frequency = 20 Hz
        motionManager.deviceMotionUpdateInterval = 1.0/20.0
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {(data, error) in
            //TEST
            //var accelData = exerciseData!.data[K.dataDict.accelKey] as! [Any]
            if error != nil {
                print("encountered error : \(error!)")
            }
            
            
            
             //TRUE FUNCTIONALLITY
             
            if let data = data{
                
                count += 1
                print(count)
                self.exerciseData.accelData.append(["x": data.userAcceleration.x, "y": data.userAcceleration.y, "z": data.userAcceleration.z])
                self.exerciseData.gravityData.append(["x": data.gravity.x, "y": data.gravity.y, "z": data.gravity.z])
                self.exerciseData.attitudeData.append(["roll": data.attitude.roll, "pitch":data.attitude.pitch, "yaw":data.attitude.yaw])
                self.exerciseData.rotationData.append(["x": data.rotationRate.x, "y": data.rotationRate.y, "z": data.rotationRate.z])
                
                
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
    
    func getCurrentDate() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let datetime = formatter.string(from: date)
        return datetime
    }
    
    func getExerciseData() -> ExerciseDataModel? {
        
        return exerciseData
    }
    func resetExerciseData(){
        exerciseData = ExerciseDataModel(exerciseType: nil, accelData: [], gravityData: [], rotationData: [], attitudeData: [])
    }
}
