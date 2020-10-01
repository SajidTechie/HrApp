//
//  SuccessMessageController.swift
//  HrApp
//
//  Created by Goldmedal on 06/01/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import UIKit

class SuccessPunchInPopup: BaseViewController {

    @IBOutlet weak var lblPunchTime : UILabel!
    @IBOutlet weak var btnOk : RoundButton!
    var strPunchTime = String()
    var punchType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let punchTimeArr = strPunchTime.components(separatedBy: " ")
        
        if(punchTimeArr.count > 0){
            strPunchTime = punchTimeArr[1] + punchTimeArr[2]
        }
      
        let firstAttributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 16)]
        let secondAttributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Bold", size: 30)]

        let firstString = NSMutableAttributedString(string: punchType, attributes: firstAttributes)
        let secondString = NSAttributedString(string: strPunchTime, attributes: secondAttributes)

        firstString.append(secondString)
        
        lblPunchTime.attributedText = firstString
    }
    
    @IBAction func clicked_submit(_ sender: UIButton) {
     dismiss(animated: true, completion: nil)
    }
  
}
