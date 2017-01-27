//
//  NewsViewController.swift
//  Excercise
//
//  Created by John De Guzman on 2017-01-26.
//  Copyright © 2017 John De Guzman. All rights reserved.
//

import Foundation
import PullToDismiss
import AlamofireImage
import Alamofire

class NewsViewController: ArticleViewController{
    
    private var pullToDismiss: PullToDismiss?
    var news: NewsModel!
    
    override func viewDidLoad() {
        // required
        
        autoColored = true
        image = news.backgroundImage!
   
        url = news.url!
        headline = news.title!
        author = news.author!
        date = Date()
        body = news.description!
        
    
        
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
    
    }
    

    
}
