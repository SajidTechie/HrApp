//
//  PunchInController.swift
//  HrApp
//
//  Created by Goldmedal on 04/01/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import UIKit

class PunchInPopup: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var strImvPunchBlob = ""
    
    @IBOutlet weak var lblTimer : UILabel!
    @IBOutlet weak var lblPunchTime : UILabel!
    @IBOutlet weak var lblPunchAddress : UILabel!
    @IBOutlet weak var btnSubmit : RoundButton!
    @IBOutlet weak var edtRemark : UITextField!
    @IBOutlet weak var imvSetImage : UIImageView!
    
    var insertPunchDataElement : PunchInsertElement!
    var errorData : [ErrorsData]?
    var insertPunchData : [PunchInsertData]?
    var insertPunchApi = ""
    
    var punchTime = String()
    var punchLocationAddress = String()
    
    var mLat = String()
    var mLong = String()
    var userId = String()
    
    var countdownTimer: Timer!
    var totalTime = 60
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTimer()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imvSetImage.isUserInteractionEnabled = true
        imvSetImage.addGestureRecognizer(tapGestureRecognizer)
        
        insertPunchApi = AppConstants.PROD_BASE_URL + AppConstants.INSERT_PUNCH_DATA
        
        let loginData =  UserDefaults.standard.value(forKey: "loginData") as? Dictionary ?? [:]
        userId = loginData["EmployeeID"] as? String ?? "-"
        
        var todaysDate = Date()
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "hh:mm:ss a"
        punchTime = timeformatter.string(from: todaysDate)
        
        lblPunchTime.text = punchTime
        lblPunchAddress.text = punchLocationAddress
    }
    
    
    func startTimer() {
        lblTimer.textColor = UIColor.black
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
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
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("punch")
        chooseImage()
    }
    
    
    @IBAction func clicked_close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clicked_submit(_ sender: UIButton) {
        print("submit")
        if (Utility.isConnectedToNetwork()) {
            self.apiInsertPunch()
        }
        else{
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
    }
    
    
    func chooseImage(){
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            self.openGallary(type: 1)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            self.openGallary(type: 2)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func openGallary(type: Int) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = (type == 1) ? .camera : .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        let ImageData:Data = compressImage(selectedImage)
        imvSetImage.image = UIImage(data:ImageData)
        strImvPunchBlob = ImageData.base64EncodedString()
        
        // Dismiss the picker.
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func compressImage (_ image: UIImage) -> Data {
        
        let actualHeight:CGFloat = image.size.height
        let actualWidth:CGFloat = image.size.width
        let imgRatio:CGFloat = actualWidth/actualHeight
        let maxWidth:CGFloat = 1024.0
        let resizedHeight:CGFloat = maxWidth/imgRatio
        let compressionQuality:CGFloat = 0.5
        
        let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        let imageData:Data = img.jpegData(compressionQuality: compressionQuality)!
        UIGraphicsEndImageContext()
        
        return imageData
        
    }
    
    
    func apiInsertPunch(){
        ViewControllerUtils.sharedInstance.showLoader()
        
        let json: [String: Any] =  [
            "UserID": userId,
            "ClientID": AppConstants.CLIENT_ID,
            "ClientSecret": AppConstants.CLIENT_SECRET,
            "Image": strImvPunchBlob,
            "Remark": (edtRemark.text ?? "-")!,
            "IP": Utility.getIPAddress(),
            "Latitude": mLat,
            "Longitude": mLong,
            "DeviceId": Utility.getDeviceId(),
            "PunchType": "Mobile",
            "DeviceType": AppConstants.DEVICE_TYPE
        ]
        
        let manager =  DataManager.shared
        
        manager.makeAPICall(url: insertPunchApi, params: json, method: .POST, success: { (response) in
            let data = response as? Data
            print("insertPunchApi - - - - - ",self.insertPunchApi,"-----",json)
            
            do {
                self.insertPunchDataElement = try JSONDecoder().decode(PunchInsertElement.self, from: data!)
                self.insertPunchData = self.insertPunchDataElement.data
                
                let statusCode = self.insertPunchDataElement?.statusCode
                
                self.errorData = self.insertPunchDataElement?.errors
                
                var errMsg = ""
                if(!(self.errorData?.isEmpty ?? true)){
                    errMsg = self.errorData?[0].errorMsg ?? "No Data Available"
                }
                
                var punchDateTime = self.insertPunchData?[0].punchDateTime ?? ""
                
                if (statusCode == 200 && (self.insertPunchData?.count ?? 0) > 0 && !punchDateTime.isEmpty)
                {
                    weak var pvc = self.presentingViewController
                    self.dismiss(animated: true, completion: {
                        let storyBoard: UIStoryboard = UIStoryboard(name: "SuccessPunchInPopup", bundle: nil)
                        let successPopup = storyBoard.instantiateViewController(withIdentifier: "SuccessPunchInPopup") as! SuccessPunchInPopup
                        successPopup.punchType = "IN"
                        successPopup.strPunchTime = punchDateTime
                        UserDefaults.standard.set(punchDateTime, forKey: "punchInTime")
                        pvc?.present(successPopup, animated: true, completion: nil)
                    })
                   
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
    
}
