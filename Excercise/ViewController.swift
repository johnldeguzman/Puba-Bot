//
//  ViewController.swift
//  Excercise
//
//  Created by John De Guzman on 2017-01-23.
//  Copyright © 2017 John De Guzman. All rights reserved.
//

import UIKit
import ApiAI
import SwiftyGif
import Speech
import PulsingHalo
import TNInfoBubble

class ViewController: UIViewController {

    @IBOutlet weak var workoutBuddy: UIImageView!
    @IBOutlet weak var response: UITextView!
    @IBOutlet weak var text: UITextField!
    
    @IBOutlet weak var messageView: TNInfoBubbleView!
    @IBOutlet weak var recordButton: UIButton!
  
    var isRecord: Bool = false
    var halo: PulsingHaloLayer!
    
     private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /* The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    print("woo")
                case .denied:
                    print("The app needs to be authorized in order to record your voice")
                case .restricted:
                    print("The app needs to be authorized in order to record your voice")
                case .notDetermined:
                    print("The app needs to be authorized in order to record your voice")
                }
            }
        }
        
        
         self.navigationController?.isNavigationBarHidden = true
        
        let config = TNInfoBubbleConfiguration()
        messageView.config = config
        
        let gifmanager = SwiftyGifManager(memoryLimit: 50)
        let gif = UIImage(gifName: "diploma")
        workoutBuddy.setGifImage(gif, manager: gifmanager)
        
        showMessage(message:"Tap me to start talking to me!")
        
        
    }
    
    func showMessage(message: String){
        
        messageView.labelText = message
        messageView.show()
    }
    
    
    func pushMessage(text:String){
        
        let message = text
        APIProvider.sharedInstance.sendMessage(query: message, completionHandler: {[unowned self] response in
            self.showMessage(message: response.message!)
            
            if response.action == "news"{
                let news = response.newsOutlet
            self.getNews(news: news)
                
            }
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func getNews(news: String){
        APIProvider.sharedInstance.getNews(newsOutlet: news, completionHandler: {response in
        
            let vc = NewsViewController()
            vc.news = response
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overCurrentContext
            
            self.present(nav, animated: true, completion: nil)
        
        })
        
    }

    @IBAction func record(_ sender: UIButton) {

        messageView.hide()
        if !isRecord{
            
            halo = PulsingHaloLayer()
            halo.haloLayerNumber = 7
            halo.radius = 200
            halo.animationDuration = 5
            halo.position = workoutBuddy.center
            view.layer.addSublayer(halo)
            halo.start()
            isRecord = true
            workoutBuddy.showFrameAtIndex(1)
             workoutBuddy.stopAnimatingGif()
               startRecording()
            
        }else {
            halo.pulseInterval = Double.infinity
            isRecord = false
            workoutBuddy.startAnimatingGif()
            
            audioEngine.stop()
            recognitionRequest?.endAudio()
          
            
        }
        
   
    }
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
//                self.textView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                var message = result?.bestTranscription.formattedString
                if message != nil {
                
                self.pushMessage(text: message!)
                } else {
                    message = " "
                    self.pushMessage(text:message!)
                }
                
                
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
      
        
    }
    

}

