//
//  PunchInController.swift
//  HrApp
//
//  Created by Goldmedal on 04/01/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import UIKit

class PunchInPopup: UIViewController {

    
    @IBOutlet weak var btnSubmit : RoundButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnSubmit.GradientButton()
        // Do any additional setup after loading the view.
//        btnSubmit.applyButtonGradient(colors: [GradientView.UIColorFromRGB(0x586aa9).cgColor,GradientView.UIColorFromRGB(0x357b96).cgColor,GradientView.UIColorFromRGB(0x008f7e).cgColor])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
