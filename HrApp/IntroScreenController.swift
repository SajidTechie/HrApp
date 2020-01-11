//
//  IntroScreenViewController.swift
//  DealorsApp
//
//  Created by Goldmedal on 8/29/18.
//  Copyright © 2018 Goldmedal. All rights reserved.
//

import UIKit

class IntroScreenController: BaseViewController {
    
    @IBOutlet weak var imageSlider: CPImageSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imageSlider.autoSrcollEnabled = false
        imageSlider.enableArrowIndicator = true
        imageSlider.showOnlyImages = true
        self.imageSlider.images = ["attendance","report","approval","leaves","expense"]
        imageSlider.delegate = self
        
//        Analytics.setScreenName("INTRO SCREEN", screenClass: "IntroScreenViewController")
//        SQLiteDB.instance.addAnalyticsData(ScreenName: "INTRO SCREEN", ScreenId: 2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showLoginVC() {
        DispatchQueue.main.async {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let vcLogin = storyBoard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            self.navigationController!.pushViewController(vcLogin, animated: false)
            
            UserDefaults.standard.set("intro", forKey: "Intro")
        }
    }
}

extension IntroScreenController: CPSliderDelegate {
    func previousClick() {
        showLoginVC()
    }
    
    func nextClick() {
        showLoginVC()
    }
    
    func sliderImageTapped(slider: CPImageSlider, index: Int) {
        //Image Click event
    }
    
    func sliderImageIndex(index: Int) {
        //Slide image index
    }
    
    
}

