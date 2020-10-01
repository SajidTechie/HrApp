//
//  LoginController.swift
//  DealorsApp
//
//  Created by Goldmedal on 3/26/18.
//  Copyright © 2018 Goldmedal. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import CoreLocation

class LoginController: UIViewController,UITextFieldDelegate{
  
    @IBOutlet weak var edtCin: UITextField!
    @IBOutlet weak var edtPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var vwLoginContainer: UIView!
    @IBOutlet weak var captchaView: CaptchaView!
    
    var login : LoginElement!
    var errorData : [ErrorsData]?
    var loginData : [NSDictionary]?
   
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var strToken = ""
    
    var mLat:Double = 0
    var mLong:Double = 0
    
    var appVersion = ""
    var osVersion = ""
    var ipAddress = ""
   
    var loginApi=""
    
    var lastCin = ""
    var currCin = ""
    
    var mpin = ""
    var checkMpinApi = ""

    let locationManager = CLLocationManager()
  
    @IBAction func onLoginClicked(_ sender: Any) {
      
        if((edtCin.text?.trimmingCharacters(in: NSCharacterSet.whitespaces).count)!  < 5)
        {
            var alert = UIAlertView(title: nil, message: "Invalid CIN", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else if ((edtPassword.text?.trimmingCharacters(in: NSCharacterSet.whitespaces).count)!  == 0) {
            var alert = UIAlertView(title: nil, message: "Please Enter Password", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        } else {
            if(captchaView.checkCaptcha()){
                if (Utility.isConnectedToNetwork()) {
                   apiLogin()
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
    
    
    func apiLogin(){
         ViewControllerUtils.sharedInstance.showLoader()
        
        let json: [String: Any] =  [
                 "UserName":(edtCin.text ?? "")!,
                 "Password":(edtPassword.text ?? "")!,
                 "deviceid": Utility.getDeviceId(),
                 "DeviceType": AppConstants.DEVICE_TYPE,
                 "AppVersion": appVersion,
                 "OSVersion": osVersion,
                 "pooswooshid": strToken,
                 "IP": ipAddress,
                 "Lat": String(mLat),
                 "Lng": String(mLong),
                 "AppType": AppConstants.APP_TYPE,
                 "ModalType": Utility.getDeviceId(),
                 "ClientID": AppConstants.CLIENT_ID,
                 "ClientSecret":  AppConstants.CLIENT_SECRET,
        ]
       
         print("LOGIN - - - - -",json)
         
         let manager =  DataManager.shared
         
         manager.makeAPICall(url: loginApi, params: json, method: .POST, success: { (response) in
              let data = response as? Data
             print("loginApi - - - - - ",self.loginApi,"-----",json)
             
             do {
             let responseData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                 
             self.login = try JSONDecoder().decode(LoginElement.self, from: data!)
                 
             let statusCode = self.login?.statusCode
            
             self.errorData = self.login?.errors
                
            var errMsg = ""
             if(!(self.errorData?.isEmpty ?? true)){
             errMsg = self.errorData?[0].errorMsg ?? "No Data Available"
             }
                
             if (statusCode == 200)
             {
                 self.loginData = (responseData as? NSDictionary)?["Data"] as? [NSDictionary]
                 UserDefaults.standard.set(self.loginData, forKey: "loginData")
                
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                    let vcHome = storyBoard.instantiateViewController(withIdentifier: "DashboardController") as! DashboardController
                    self.navigationController!.pushViewController(vcHome, animated: true)
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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        edtCin.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.requestLocation()
        
        loginApi = AppConstants.PROD_BASE_URL + AppConstants.LOGIN
        
        print("IP ADDRESS - - - - ",Utility.getIPAddress())
        
        ipAddress = (Utility.getIPAddress() ?? "-")!
        
     //   strToken = (appDelegate.tokenString ?? "-")!
        if(strToken.isEqual("")){
            strToken = "-"
        }
        
        print("STR TOKEN",(strToken))
      
        osVersion = UIDevice.current.systemVersion
        if(osVersion.isEqual("")){
            osVersion = "-"
        }
        
        appVersion = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String)!
        if(appVersion.isEqual("")){
            appVersion = "-"
        }
    
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func clicked_newUser(_ sender: UIButton) {
       let vcNewUser = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordController") as! ForgotPasswordController
        self.navigationController!.pushViewController(vcNewUser, animated: true)
    }
    
    
    @IBAction func clicked_forgotPassword(_ sender: UIButton) {
        let vcForgotPassword = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordController") as! ForgotPasswordController
        self.navigationController!.pushViewController(vcForgotPassword, animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension LoginController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lat = locations.last?.coordinate.latitude, let long = locations.last?.coordinate.longitude {
            print("LAT LONG - - - \(lat),\(long)")
            mLat = lat
            mLong = long
        } else {
            print("No coordinates")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
