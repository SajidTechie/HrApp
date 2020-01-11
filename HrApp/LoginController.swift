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

class LoginController: UIViewController , UITextFieldDelegate{
  
    @IBOutlet weak var edtCin: UITextField!
    @IBOutlet weak var edtPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var vwLoginContainer: UIView!
    @IBOutlet weak var captchaView: CaptchaView!
   
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var strToken = ""
    
    var mLat:Double = 0
    var mLong:Double = 0
    
    var appVersion = ""
    var osVersion = ""
    var ipAddress = ""
    var deviceId = ""
    
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
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                                                 let vcHome = storyBoard.instantiateViewController(withIdentifier: "DashboardController") as! DashboardController
                                                 self.navigationController!.pushViewController(vcHome, animated: true)
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
        
        print("IP ADDRESS - - - - ",getIPAddress())
        
        ipAddress = (getIPAddress() ?? "-")!
        
     //   strToken = (appDelegate.tokenString ?? "-")!
        if(strToken.isEqual("")){
            strToken = "-"
        }
        
        print("STR TOKEN",(strToken))
        
        deviceId = UIDevice.current.identifierForVendor!.uuidString
        if(deviceId.isEqual("")){
            deviceId = "-"
        }
      
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
    
    
 
    
    func getIPAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" || name == "pdp_ip0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return (address ?? "")!
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
