//
//  WatchBrain.swift
//  XtraRep WatchKit Extension
//
//  Created by Alex Waldron on 10/28/20.
//

import Foundation
import CoreMotion
import WatchConnectivity

protocol WatchBrainDelegate {
    func sendDataToiOS()
}

class WatchBrain{
    var exerciseData:ExerciseDataModel = ExerciseDataModel(exerciseType: nil, accelData: ["x":[],"y":[], "z":[], "t":[]])
    var delegate: WatchBrainDelegate?
    var count = 0
    func startCollectingData(exerciseName: String, motionManager: CMMotionManager){
        var time = 0.0
        print("Start collecting data")
        //setup data model
        exerciseData.exerciseType = exerciseName
        
        //Update interval frequency = 60 Hz
        let updateInterval = 1.0/60.0
        motionManager.accelerometerUpdateInterval = updateInterval
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {(data, error) in
            //TEST
            //var accelData = exerciseData!.data[K.dataDict.accelKey] as! [Any]
            if error != nil {
                print("encountered error : \(error!)")
            }
            
            
            
             //TRUE FUNCTIONALLITY
             
            if let data = data{
                self.count += 1
                print(self.count)
                self.exerciseData.accelData["x"]?.append(data.acceleration.x)
                self.exerciseData.accelData["y"]?.append(data.acceleration.y)
                self.exerciseData.accelData["z"]?.append(data.acceleration.z)
                self.exerciseData.accelData["t"]?.append(time)
                time += updateInterval
                if self.count > 400 {
                    self.delegate?.sendDataToiOS()
                    self.count = 0
                    self.exerciseData = ExerciseDataModel(exerciseType: exerciseName, accelData: ["x":[],"y":[], "z":[], "t":[]])
                }
                print(self.count)
                
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
        count = 0
        exerciseData = ExerciseDataModel(exerciseType: nil, accelData: ["x":[],"y":[], "z":[], "t":[]])
    }
}
