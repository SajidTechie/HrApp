//
//  ForgotPasswordController.swift
//  HrApp
//
//  Created by Goldmedal on 7/18/19.
//  Copyright © 2019 Goldmedal. All rights reserved.
//

import UIKit

class ForgotPasswordController: UIViewController {

    @IBOutlet weak var edtCin: UITextField!
    @IBOutlet weak var captchaView: CaptchaView!
    
       @IBAction func onClickSubmit(_ sender: Any) {
        
        if((edtCin.text?.trimmingCharacters(in: NSCharacterSet.whitespaces).count)!  < 5)
        {
            var alert = UIAlertView(title: nil, message: "Invalid CIN", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        } else {
            if(captchaView.checkCaptcha()){
                if (Utility.isConnectedToNetwork()) {
                    self.apiNewUser()
                }
                else{
                    var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
            }else{
                var alert = UIAlertView(title: nil, message: "Invalid Captcha", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            
        }
        
    }
    
    @IBAction func clicked_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func apiNewUser(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let vcOtp = storyBoard.instantiateViewController(withIdentifier: "OtpController") as! OtpController
        self.navigationController!.pushViewController(vcOtp, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: true)
       
    }
   
}
