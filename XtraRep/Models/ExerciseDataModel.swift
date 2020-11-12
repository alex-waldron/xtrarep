//
//  ExerciseDataModel.swift
//  XtraRep
//
//  Created by Alex Waldron on 11/10/20.
//

import Foundation

struct ExerciseDataModel: Codable {
    var exerciseType:String?
    var date:String?
    var times:[Double]
    var accelData: [[String:Double]]
    var gravityData: [[String:Double]]
    var rotationData: [[String:Double]]
    var attitudeData: [[String:Double]]
    
    /*var data: [String:Any?] = [
        "exercise": nil,
        "accelData": [String?:Double?]
        
    ]*/
}
