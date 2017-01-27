//
//  MessageModel.swift
//  Excercise
//
//  Created by John De Guzman on 2017-01-24.
//  Copyright © 2017 John De Guzman. All rights reserved.
//

import Foundation

class MessageModel{
    var message, action:String?
    var workout: ExcerciseModel?
    var newsOutlet: String = ""
        
    
    
    init(){
        self.message = ""
    }
    
    func changeNewsOutlet(news: String){
        
        switch news{
        case  "techcrunch":
            self.newsOutlet = "techcrunch"
        case  "buzzfeed":
            self.newsOutlet = "buzzfeed"
        case  "cnbc":
            self.newsOutlet = "cnbc"
        case  "cnn":
            self.newsOutlet = "cnn"
        case  "daily mail":
            self.newsOutlet = "daily-mail"
        case  "espn":
            self.newsOutlet = "espn"
        case  "ign":
            self.newsOutlet = "ign"
        case  "the next web":
            self.newsOutlet = "the-next-web"
        case  "the new york times":
            self.newsOutlet = "the-new-york-times"
        default:
            self.newsOutlet = "techcrunch"
        }
    }
}

