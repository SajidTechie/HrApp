//
//  StatisticViewController.swift
//  HrApp
//
//  Created by Goldmedal on 1/8/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import UIKit

class StatisticViewController: UIViewController {
    
    @IBOutlet weak var circularProgress: CircularProgressBar!
    
    @IBOutlet var tabButtons: [UIButton]!
    @IBOutlet var lineLabels: [UILabel]!
    
    var countFired: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
       Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
             self.countFired += 1
             
             DispatchQueue.main.async {
                self.circularProgress.progress = min(0.03 * self.countFired, 0.6)
               
               if self.circularProgress.progress == 1 {
                 timer.invalidate()
               }
             }
           }
        // Do any additional setup after loading the view.
//        circularProgress.trackClr = UIColor.lightGray
//       // circularProgress.progressClr = GradientColor
//
//        circularProgress.setProgressWithAnimation(duration: 1.0, value: 0.30)
    }
    
    @IBAction func tabAction(sender: UIButton) {
    for (index, button) in tabButtons.enumerated() {
        let labelLine = lineLabels[index]
        labelLine.backgroundColor = (button == sender) ? UIColor.red : UIColor.clear
    }
    }

}
