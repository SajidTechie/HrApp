//
//  SplashScreenController.swift
//  HrApp
//
//  Created by Goldmedal on 7/18/19.
//  Copyright © 2019 Goldmedal. All rights reserved.
//

import UIKit
import AVKit
import FirebaseAnalytics

class SplashScreenController: AVPlayerViewController {

        var appStrorVersionNumber = ""
        var videoPlay = false
        var forceUpdate = false
        var firstTime = true
        
        override func viewDidLoad() {
            super.viewDidLoad()
         
          //  continueInsideApp()
            
            // Do any additional setup after loading the view.
            let path = Bundle.main.path(forResource: "Logo_01", ofType: "mp4")
            let videoURL = URL(fileURLWithPath: path!)
            player = AVPlayer(url: videoURL)
            showsPlaybackControls = false

            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.animationDidFinish(_:)),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: player?.currentItem)
//
//            // add notification observers
            NotificationCenter.default.addObserver(self, selector: #selector(self.didBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)

         //   view.backgroundColor = UIColor.white
    //        Analytics.setScreenName("SPLASH SCREEN", screenClass: "SplashViewController")
           // SQLiteDB.instance.addAnalyticsData(ScreenName: "SPLASH SCREEN", ScreenId: Int64(GlobalConstants.init().SPLASH))
        }
        
        
        @objc func didBecomeActive() {
            print("did become active")
            if(!videoPlay){
                player?.play()
            }
        }
        
    //    func forceUpdate(update: Bool) {
    //        if update {
    //            popupUpdateDialogue()
    //        }
    //
    //    }
        
        @objc func didEnterBackground() {
            print("will enter background")
            player?.pause()
        }
        
    //    func popupUpdateDialogue(){
    //
    //        let alertMessage = "A new version of G - Parivaar Application is available,Please update to version \(self.appStrorVersionNumber)";
    //        let alert = UIAlertController(title: "New Version Available", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
    //
    //        let okBtn = UIAlertAction(title: "Update", style: .default, handler: {(_ action: UIAlertAction) -> Void in
    //            if let url = URL(string: "itms-apps://itunes.apple.com/us/app/id1437778450"),
    //                UIApplication.shared.canOpenURL(url){
    //
    //                //                let loginData = UserDefaults.standard
    //                //                loginData.removeObject(forKey: "loginData")
    //
    //                if #available(iOS 10.0, *) {
    //                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
    //                } else {
    //                    UIApplication.shared.openURL(url)
    //                }
    //
    //            }
    //        })
    //        let noBtn = UIAlertAction(title:"Later" , style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
    //            self.dismiss(animated: true, completion: nil)
    //            self.continueInsideApp()
    //        })
    //        alert.addAction(okBtn)
    //
    //        if(!forceUpdate){
    //            alert.addAction(noBtn)
    //        }
    //
    //        self.present(alert, animated: true, completion: nil)
    //    }
        
    //    func apiSplash(){
    //
    //        let json: [String: Any] = ["Date": "02/17/2018"]
    //
    //        DataManager.shared.makeAPICall(url: "https://api.goldmedalindia.in/api/getInitialValue", params: json, method: .POST, success: { (response) in
    //
    //            if let response = response {
    //                print("SPLASH",response)
    //            }
    //
    //            let data = response as? Data
    //
    //            do {
    //                let responseData =   try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
    //
    //                self.initialMain = try JSONDecoder().decode([InitialElement].self, from: data!)
    //                self.initialObj = self.initialMain[0].data
    //
    //                let result = self.initialMain[0].result ?? false
    //
    //                if result
    //                {
    //                    OperationQueue.main.addOperation {
    //                        let mainData = ((responseData as? Array ?? [])[0] as? Dictionary ?? [:])["data"]
    //                        let initialData = ((mainData as? Array ?? [])[0] as? Dictionary ?? [:])
    //                        UserDefaults.standard.set(initialData, forKey: "initialData")
    //                        self.appStrorVersionNumber = (initialData["iosVersion"] as? String) ?? ""
    //                        self.forceUpdate = (initialData["forceUpdate"] as? Bool) ?? false
    //                        self.forceUpdate(update: self.isUpdateAvailable(appstoreVersion: self.appStrorVersionNumber))
    //                    }
    //
    //                }
    //
    //            } catch let errorData {
    //                print(errorData.localizedDescription)
    //            }
    //        }) { (Error) in
    //            print(Error?.localizedDescription ?? "ERROR")
    //        }
    //
    //    }
        
        
        func isUpdateAvailable(appstoreVersion: String) -> Bool {
            guard let info = Bundle.main.infoDictionary,
                let version = info["CFBundleShortVersionString"] as? String else {
                    return false
            }
            
            let appVersion = Double(version)
            let appStoreVersion = Double(appstoreVersion)
            return CGFloat(appVersion ?? 0) < CGFloat(appStoreVersion ?? 0)
        }
        
        
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            print("FOREGROUND")
            player?.play()
        }
        
        // - - - - -  initial api data parsing - - - - - -
        func continueInsideApp(){
            
//            let storyBoard: UIStoryboard = UIStoryboard(name: "PunchInOut", bundle: nil)
//                   let vcMap = storyBoard.instantiateViewController(withIdentifier: "MapPunchInOutController") as! MapPunchInOutController
//                   self.navigationController!.pushViewController(vcMap, animated: true)
            
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Leaves", bundle: nil)
//            let vcMap = storyBoard.instantiateViewController(withIdentifier: "StatisticViewController") as! StatisticViewController
//            self.navigationController!.pushViewController(vcMap, animated: true)
            
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//            let vcHome = storyBoard.instantiateViewController(withIdentifier: "DashboardController") as! DashboardController
//            self.navigationController!.pushViewController(vcHome, animated: true)

//            let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
//                               let vcIntro = storyBoard.instantiateViewController(withIdentifier: "IntroScreenController") as! IntroScreenController
//                               self.navigationController!.pushViewController(vcIntro, animated: false)
            
            
                if (UserDefaults.standard.value(forKey: "Intro") == nil){
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
                    let vcIntro = storyBoard.instantiateViewController(withIdentifier: "IntroScreenController") as! IntroScreenController
                    self.navigationController!.pushViewController(vcIntro, animated: false)
                }else{
                    if (UserDefaults.standard.value(forKey: "loginData") == nil){
                        // loginview controller code
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
                        let vcLogin = storyBoard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
                        self.navigationController!.pushViewController(vcLogin, animated: false)
                    }else{
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                              let vcHome = storyBoard.instantiateViewController(withIdentifier: "DashboardController") as! DashboardController
                              self.navigationController!.pushViewController(vcHome, animated: true)
                    }
                }

        }
        
        
        @objc func animationDidFinish(_ notification: NSNotification) {
            print("Animation did finish")
            
            guard (!self.isUpdateAvailable(appstoreVersion: self.appStrorVersionNumber)) else {
                return
            }
            
            if(firstTime){
                continueInsideApp()
                firstTime = false
            }
            
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
    }

    protocol SomeMediaPlayerDelegate : class{
        func finishPlayer()
    }

    class SomeMediaPlayer: UIViewController {
        public var audioURL:URL!
        private var player = AVPlayer()
        private var playerLayer: AVPlayerLayer!
        weak var delegate : SomeMediaPlayerDelegate?
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.view.layer.insertSublayer(self.playerLayer, at: 0)
            let playerItem = AVPlayerItem(url: self.audioURL)
            self.player.replaceCurrentItem(with: playerItem)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.animationDidFinish(_:)),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: player.currentItem)
        }
        
        
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.player.play()
        }
        
        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            self.playerLayer.frame = self.view.bounds
        }
        
        @objc func animationDidFinish(_ notification: NSNotification) {
            print("Animation did finish")
            delegate?.finishPlayer()
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        // Force the view into landscape mode if you need to
        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            get {
                return .landscape
            }
        }
    }
