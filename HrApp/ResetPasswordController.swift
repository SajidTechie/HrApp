//
//  ResetPasswordController.swift
//  HrApp
//
//  Created by Goldmedal on 7/18/19.
//  Copyright © 2019 Goldmedal. All rights reserved.
//

import UIKit

class ResetPasswordController: UIViewController {
        
        @IBOutlet weak var edtOldPassword: UITextField!
        @IBOutlet weak var edtNewPassword: UITextField!
        @IBOutlet weak var edtConfirmPassword: UITextField!
        @IBOutlet weak var btnSetPassword: UIButton!
       
        var callFrom = String()
        var setPasswordApi=""
        
        @IBAction func clicked_setpassword(_ sender: UIButton) {
          
            if(callFrom == "ChangePassword" && (edtOldPassword.text?.trimmingCharacters(in: NSCharacterSet.whitespaces).count)!  == 0)
            {
                var alert = UIAlertView(title: nil, message: "Please enter old password", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }else if((edtNewPassword.text?.trimmingCharacters(in: NSCharacterSet.whitespaces).count)!  == 0)
            {
                var alert = UIAlertView(title: nil, message: "Please enter new password", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            else if(edtNewPassword.text != edtConfirmPassword.text)
            {
                var alert = UIAlertView(title: nil, message: "Confirm Password does not match", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            else{
               self.apiCheckPassword()
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
        
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
            if(callFrom == "SetPassword"){
                edtOldPassword.isHidden = true
            }
         
        }
        
        @IBAction func clicked_back(_ sender: Any) {
             if(callFrom == "SetPassword"){
                let vcLogin = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
                self.navigationController?.pushViewController(vcLogin, animated: true)
            }else{
                let vcHome = self.storyboard?.instantiateViewController(withIdentifier: "DashboardController") as! DashboardController
                self.navigationController!.pushViewController(vcHome, animated: false)
            }
             self.dismiss(animated: true, completion: nil)
          
        }
        
         func apiCheckPassword(){
       
                        let vcLogin = self.storyboard?.instantiateViewController(withIdentifier: "LoginScreen") as! LoginController
                        self.navigationController?.pushViewController(vcLogin, animated: true)
                 
            
        }
   
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        

    }
