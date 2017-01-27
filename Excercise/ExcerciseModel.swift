//
//  ExcerciseModel.swift
//  Excercise
//
//  Created by John De Guzman on 2017-01-24.
//  Copyright © 2017 John De Guzman. All rights reserved.
//

import Foundation

class ExcerciseModel: NSObject{
    
    var excercise: String!
    var reps: Int!
    var sets: Int!
    var weight: String!
    var weightUnit: Int!
    
    
    init(_ excercise:String, _ reps: Int, _ sets: Int, weight: String, weightUnit: Int!){
        
        self.excercise = excercise
        self.reps = reps
        self.sets = sets
        self.weight = weight
        self.weightUnit = weightUnit
    }
    
    
    
}
