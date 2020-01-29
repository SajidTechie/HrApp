//
//  ProfileController.swift
//  HrApp
//
//  Created by Goldmedal on 04/01/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {

    @IBOutlet weak var profileCard : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        profileCard.applyGradient(colors: [Helper.UIColorFromRGB(0x2B95CE).cgColor,Helper.UIColorFromRGB(0x2ECAD5).cgColor])
        
//        profileCard.applyGradient(colors: [GradientView.UIColorFromRGB(0x367EB9).cgColor,GradientView.UIColorFromRGB(0x6E6FC7).cgColor,GradientView.UIColorFromRGB(0xDC45E4).cgColor])
    
        let sb = UIStoryboard(name: "PunchInPopup", bundle: nil)

        let popup = sb.instantiateInitialViewController()  as? PunchInPopup



     self.present(popup!, animated: true)
        
        
//        let storyboard = UIStoryboard(name: "LeftPanel", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "ApprovalsController")
//        self.present(controller, animated: true, completion: nil)
//
        
        
        
        
//        let sb = UIStoryboard(name: "SuccessMessagePopup", bundle: nil)
//
//           let popup = sb.instantiateInitialViewController()  as? SuccessMessageController
//
//
//
//       self.present(popup!, animated: true)
        // Do any additional setup after loading the view.
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
