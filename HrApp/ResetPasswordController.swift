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
    var setPasswordApi = ""
    var resetPasswordElement : ForgotPasswordElement!
    var errorData : [ErrorsData]?
    var resetPasswordData : [ForgotPasswordData]?
    
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
            
            if (Utility.isConnectedToNetwork()) {
                self.apiCheckPassword()
            }
            else{
                var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        setPasswordApi = AppConstants.PROD_BASE_URL + AppConstants.RESET_PASSWORD
        
        if(callFrom == "SetPassword"){
            edtOldPassword.isHidden = true
        }
        
    }
    
    @IBAction func clicked_BackButton(_ sender: UIBarButtonItem) {
        if(callFrom == "SetPassword"){
         let vcLogin = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
               self.navigationController?.pushViewController(vcLogin, animated: true)
        }else{
              self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func clicked_back(_ sender: Any) {
        if(callFrom == "SetPassword"){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let vcLogin = storyBoard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            self.navigationController!.pushViewController(vcLogin, animated: false)
        }else{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let vcHome = storyBoard.instantiateViewController(withIdentifier: "DashboardController") as! DashboardController
            self.navigationController!.pushViewController(vcHome, animated: true)
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func apiCheckPassword(){
        ViewControllerUtils.sharedInstance.showLoader()
        
        let json: [String: Any] =  [
            "UserID": (edtNewPassword.text ?? "")!,
            "NewPassword": Utility.getDeviceId(),
            "ClientID": AppConstants.CLIENT_ID,
            "ClientSecret": AppConstants.CLIENT_SECRET,
            "OldPassword": (edtOldPassword.text ?? "")!,
        ]
        
        let manager =  DataManager.shared
        
        manager.makeAPICall(url: setPasswordApi, params: json, method: .POST, success: { (response) in
            let data = response as? Data
            print("setPasswordApi - - - - - ",self.setPasswordApi,"-----",json)
            
            do {
                
                self.resetPasswordElement = try JSONDecoder().decode(ForgotPasswordElement.self, from: data!)
                self.resetPasswordData = self.resetPasswordElement.data
                
                let statusCode = self.resetPasswordElement?.statusCode
                
                self.errorData = self.resetPasswordElement?.errors
                
                var errMsg = ""
                if(!(self.errorData?.isEmpty ?? true)){
                    errMsg = self.errorData?[0].errorMsg ?? "No Data Available"
                }
                
                if (statusCode == 200)
                {
                    let vcLogin = self.storyboard?.instantiateViewController(withIdentifier: "LoginScreen") as! LoginController
                    self.navigationController?.pushViewController(vcLogin, animated: true)
                    
                    var alert = UIAlertView(title: "Success", message: "Password changed successfully", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }else{
                    var alert = UIAlertView(title: "Error", message: errMsg, delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
                ViewControllerUtils.sharedInstance.removeLoader()
            } catch let errorData {
                
                print(errorData.localizedDescription)
                ViewControllerUtils.sharedInstance.removeLoader()
            }
        }) { (Error) in
            ViewControllerUtils.sharedInstance.removeLoader()
            print(Error?.localizedDescription)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
