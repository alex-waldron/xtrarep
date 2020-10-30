//
//  ExerciseDataModel.swift
//  XtraRep WatchKit Extension
//
//  Created by Alex Waldron on 10/27/20.
//

import Foundation


struct ExerciseDataModel {
    var data: [String:Any?] = [
        "exercise": nil,
        "accelData": [XYZ(x: 1, y: 2, z: 3),XYZ(x: 1, y: 2, z: 3),XYZ(x: 1, y: 2, z: 3),XYZ(x: 1, y: 2, z: 3),XYZ(x: 1, y: 2, z: 3)]
        
    ]
}
