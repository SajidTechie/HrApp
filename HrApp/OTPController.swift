//
//  OtpController.swift
//  DealorsApp
//
//  Created by Goldmedal on 3/26/18.
//  Copyright © 2018 Goldmedal. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class OtpController: UIViewController {
    
    @IBOutlet weak var lblEmailId: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    @IBOutlet weak var edtReqNo: UITextField!
    @IBOutlet weak var edtOtp: UITextField!
    @IBOutlet weak var lblChangeCin: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnVerify: UIButton!
    
    var countdownTimer: Timer!
    var totalTime = 120
    var countDownStopped = false
    
    var callFrom = String()
    var strEmailid = String()
    var strMobileNumber = String()
    var strCin = String()
    
    var otpApi=""
    var verifyApi=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        startTimer()
        
        var strEmail = ""
        var strMobile = ""
      
        var chars : Array<Character> = Array()
        var arr : [Substring] = []
        
        if (strEmailid.count > 0 && strEmailid.range(of:"@") != nil) {
            
            arr =  strEmailid.split(separator: "@")
            chars = Array(arr[0])
        }
        
        if(chars.count>4){
            for i in 2..<chars.count-2 {
                chars[i] = "*"
            }
            
            var Text:String = String (chars)
            Text.append("@")
            Text.append(String (arr[1]))
            
            lblEmailId.text = Text
        }else{
            lblEmailId.text = strEmailid
        }
        
        if(strMobileNumber.count > 5){
            let startMobile = strMobileNumber.startIndex;
            let endMobile = strMobileNumber.index(strMobileNumber.startIndex, offsetBy: 6);
            strMobile = strMobileNumber.replacingCharacters(in: startMobile..<endMobile, with: "******")
        }else{
            strMobile = strMobileNumber
        }
        lblContactNo.text = strMobile
       
        let resendOtp = UITapGestureRecognizer(target: self, action: #selector(self.tapResendOtp))
        lblTimer.addGestureRecognizer(resendOtp)
        
        let changeCin = UITapGestureRecognizer(target: self, action: #selector(self.tapChangeCin))
        lblChangeCin.addGestureRecognizer(changeCin)
        
        if(self.callFrom == "ChangePassword" || self.callFrom == "ForgotMpin"){
          lblChangeCin.isHidden = true
        }else{
          lblChangeCin.isHidden = false
        }
        
      
        
    }
    

    
    @objc func tapResendOtp(sender:UITapGestureRecognizer) {
        print("tap working",countDownStopped)
        
        if countDownStopped
        {
            lblTimer.text = "02:00"
            totalTime = 120
            startTimer()
           // apiNewUser()
        }
    }
    
    @objc func tapChangeCin(sender:UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func startTimer() {
        lblTimer.textColor = UIColor.black
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        countDownStopped = false
    }
    
    @objc func updateTime() {

        lblTimer.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
        lblTimer.text = "Resend OTP"
        countDownStopped = true
        if #available(iOS 11.0, *) {
            lblTimer.textColor = UIColor.init(named: "ColorRed")
        } else {
           lblTimer.textColor = UIColor.red
        }
    }
    
    
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clicked_verify(_ sender: UIButton) {
        
        if((edtReqNo.text?.trimmingCharacters(in: NSCharacterSet.whitespaces).count)!  == 0)
        {
            var alert = UIAlertView(title: nil, message: "Enter Request Number", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else if((edtOtp.text?.trimmingCharacters(in: NSCharacterSet.whitespaces).count)!  == 0)
        {
            var alert = UIAlertView(title: nil, message: "Enter Otp", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        else{
            self.apiValidateOtp()
        }
        
    }
    
    func apiValidateOtp(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
               let vcSetPassword = storyBoard.instantiateViewController(withIdentifier: "ResetPasswordController") as! ResetPasswordController
               self.navigationController!.pushViewController(vcSetPassword, animated: true)
    }
    
    
  
}
