//
//  APIProviderTest.swift
//  Excercise
//
//  Created by John De Guzman on 2017-01-27.
//  Copyright © 2017 John De Guzman. All rights reserved.
//


import XCTest
@testable import Excercise

class APIProviderTests: XCTestCase {
    
    
    
    func testPushMessageAPI(){
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
     let apiProvider = APIProvider.sharedInstance
        
        apiProvider.sendMessage(query: "hello", completionHandler: {response in
        
        XCTAssertNotNil(response, "response can't be nil")
            
        })
    }
    
    func testGetNewsAPI(){
        let apiProvider = APIProvider.sharedInstance
        
        let newsmodel = MessageModel()
        newsmodel.changeNewsOutlet(news: "daily mail")
        
        XCTAssertEqual(newsmodel.newsOutlet, "daily-mail")
        
        apiProvider.getNews(newsOutlet: newsmodel.newsOutlet, completionHandler: {response in
        
            XCTAssertNotNil(response)
            XCTAssert(response is NewsModel)
            
        })
    }
    
    func testProcessImage(){
        let apiProvider = APIProvider.sharedInstance
        apiProvider.processImage(imageUrl: "https://avatars1.githubusercontent.com/u/6422482?v=3&s=400", completionHandler: { response in
        
        
            XCTAssertNotNil(response)
            XCTAssert(response is UIImage)
        
        
        })
    }
    
    
}
    
