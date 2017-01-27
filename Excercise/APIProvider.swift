//
//  APIProvider.swift
//  Excercise
//
//  Created by John De Guzman on 2017-01-24.
//  Copyright © 2017 John De Guzman. All rights reserved.
//

import Foundation
import ApiAI
import SwiftyJSON
import Alamofire
import AlamofireImage

class APIProvider{
    
    //Creating singleton for class
    static let sharedInstance = APIProvider()
    
    //Don't allow use of init for singleton class
    private init(){
        
    }
    
    //Purpose: Send message to API.AI
    //Parameters:  Query: String, CompletionHandler: @escaping (MessageModel)-> Void
    
    //Query: query parameter for API.ai api
    
    //setCompletionBlockSuccess: called when thread successfully completes call back from API.ai
    //parseInfotoObject: parses response into a messageModel
    //completionHandler: called when thread successfully completes call back from API.ai and returns the MessageModel
    
    
    
    func sendMessage(query: String, completionHandler: @escaping (MessageModel) -> Void){
        let request = ApiAI.shared().textRequest()
        
        request?.query = query
        
        request?.setCompletionBlockSuccess({ [unowned self] (request, response) -> Void in
            
            
            let messageModel:MessageModel = self.parseInfotoObject(response: response ?? "")
    
            completionHandler(messageModel)
            
            
            
            }, failure: { (request, error) -> Void in
                
        });
        
        
        ApiAI.shared().enqueue(request)
        
    }
    
    
    
    func getNews(newsOutlet: String, completionHandler: @escaping (NewsModel)-> Void){
        let apiKey = ApplicationConstants().NYTimesAPIKey
        let URL = ApplicationConstants().NYTimesTopStories
        let param = ["source": newsOutlet,"apiKey": apiKey,]
        Alamofire.request(URL, method: .get, parameters: param).responseJSON(completionHandler: {[unowned self]response in
            
            let jsonresponse = JSON(response.result.value!)
            
            self.parseInfotoNewsObject(response: jsonresponse, completionHandler:{ news in
                
                completionHandler(news)
            })
            
        })
    }
    
    
    private func parseInfotoObject(response:Any)-> MessageModel{
     
        let json = JSON(response)
        let message = MessageModel()
      
        message.message = json["result"]["fulfillment"]["speech"].stringValue
        message.action = json["result"]["action"].stringValue
        
        if json["result"]["parameters"]["News"] != nil {
            let news = json["result"]["parameters"]["News"].stringValue
            message.changeNewsOutlet(news: news)
        }
        
//        Keep data model here
        if checkIfComplete(json: json){
            
        }
        
        print(json)
        return message
        
    }

    
    private func parseInfotoNewsObject(response: JSON, completionHandler: @escaping (NewsModel) -> Void){
        let json = response
        var news = NewsModel()
        let random = Int(arc4random_uniform(4))
        
        news.title = json["articles"][random]["title"].stringValue
        news.description = json["articles"][random]["description"].stringValue
        news.author = json["articles"][random]["author"].stringValue
        news.url = json["articles"][random]["url"].stringValue
        let urltoimage = json["articles"][random]["urlToImage"].stringValue
        
        processImage(imageUrl: urltoimage, completionHandler: {response in
        news.backgroundImage = response
        completionHandler(news)
        
        })
        
    }
    
    let downloader = ImageDownloader()
    func processImage(imageUrl: String,completionHandler: @escaping (UIImage)-> Void){
        
    
        
            let urlRequest = URLRequest(url: URL(string: imageUrl)!)
            
            downloader.download(urlRequest) { response in
                
                
            if let image = response.result.value {
                completionHandler(image)
                }
                
                
            }
    
       
    }
    
    
    private func checkIfComplete(json: JSON)-> Bool {
        return !json["actionIncomplete"].boolValue
    }
}

