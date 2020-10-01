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
    
    var getOtpElement : GetOtpElement!
    var errorData : [ErrorsData]?
    var getOtpData : [GetOtpData]?
    
    var getOtpApi = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        getOtpApi = AppConstants.PROD_BASE_URL + AppConstants.GET_OTP
       
    }
    
       @IBAction func onClickSubmit(_ sender: Any) {
        
        if((edtCin.text?.trimmingCharacters(in: NSCharacterSet.whitespaces).count)!  < 5)
        {
            var alert = UIAlertView(title: nil, message: "Invalid CIN", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        } else {
            if(captchaView.checkCaptcha()){
                if (Utility.isConnectedToNetwork()) {
                    self.apiGetOtp()
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
    
  
    func apiGetOtp(){
        ViewControllerUtils.sharedInstance.showLoader()
                
                let json: [String: Any] =  [
                         "MobileNo": (edtCin.text ?? "")!,
                         "deviceid": Utility.getDeviceId(),
                         "ClientID": AppConstants.CLIENT_ID,
                         "ClientSecret": AppConstants.CLIENT_SECRET
                ]
               
                 print("getOtp - - - - -",json)
                 
                 let manager =  DataManager.shared
                 
                 manager.makeAPICall(url: getOtpApi, params: json, method: .POST, success: { (response) in
                      let data = response as? Data
                     print("getOtpApi - - - - - ",self.getOtpApi,"-----",json)
                     
                     do {
                     
                        self.getOtpElement = try JSONDecoder().decode(GetOtpElement.self, from: data!)
                        self.getOtpData = self.getOtpElement.data
                         
                     let statusCode = self.getOtpElement?.statusCode
                    
                     self.errorData = self.getOtpElement?.errors
                        
                        var errMsg = ""
                        if(!(self.errorData?.isEmpty ?? true)){
                        errMsg = self.errorData?[0].errorMsg ?? "No Data Available"
                        }
                    
                        
                     if (statusCode == 200)
                     {
                           let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
                            let vcOtp = storyBoard.instantiateViewController(withIdentifier: "OtpController") as! OtpController
                        vcOtp.strEmailid = "abc@gmail.com"
                        vcOtp.strMobileNumber = "0000000000"
                            self.navigationController!.pushViewController(vcOtp, animated: true)
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    
   
}
