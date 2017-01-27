//
//  NewsModelTest.swift
//  Excercise
//
//  Created by John De Guzman on 2017-01-27.
//  Copyright © 2017 John De Guzman. All rights reserved.
//


import XCTest
@testable import Excercise

class ModelTests: XCTestCase {
    

    
    func testNewsModel() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let news = NewsModel(author: "John Jones", title: "How to unit test your code", description: "Testing your code is awesome", url: "http://testme.com", backgroundImage: UIImage())
        
        XCTAssertNotNil(news)
        XCTAssertEqual(news.author, "John Jones")
        XCTAssertEqual(news.title, "How to unit test your code")
        XCTAssertEqual(news.description, "Testing your code is awesome")
        XCTAssertEqual(news.url, "http://testme.com")
        XCTAssertNotNil(news.backgroundImage)
        
    }
    
    func testMessageModel(){
        
        //Testing out creating a news Message model
        let message = MessageModel()
        message.changeNewsOutlet(news: "daily mail")
        message.action = "news"
        message.message = "looking for news"
        
        XCTAssertEqual(message.newsOutlet, "daily-mail")
        
    }
    

}
    
