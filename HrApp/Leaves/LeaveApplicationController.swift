import Foundation
import UIKit
import DropDown
class LeaveApplicationController: BaseViewController,UIImagePickerControllerDelegate ,UINavigationControllerDelegate,LeaveTypeSelectedDelegate,PopupDateDelegate{
    
    //Outlets...
    @IBOutlet weak var btnStartDate : UIButton!
    @IBOutlet weak var btnEndDate : UIButton!
    @IBOutlet weak var btnLeaveType : UIButton!
    @IBOutlet weak var btnSubmit : RoundButton!
    
    @IBOutlet weak var imvUpload : UIImageView!
    
    @IBOutlet weak var lblShiftDetails : UILabel!
    @IBOutlet weak var lblLeaveDuration : UILabel!
    @IBOutlet weak var lblDropdownText: UILabel!
    
    @IBOutlet weak var vwDropDown: RoundView!
    
    
    
    let dropDown = DropDown()
    var dateFormatter = DateFormatter()
    
    //Variables
    
    var fromDate: Date?
    var toDate: Date?
    var strFromDate = ""
    var strToDate = ""
    
    
    var strImvBlob = ""
    var actualAppliedLeavesCountApi = ""
    var leaveReasonsIndex = 0
    var leaveReasonsId = "-1"
    var leaveTypeId = "1"
    var appliedLeaveDays = "0"
    var actualLeaveDays = "0"
    
    
    var applyLeavesApi = ""
    var strID = ""
    
    
    //Collections...
    var ApplyLeaveElementMain : ApplyLeaveElement!
    var ApplyLeaveDataMain = [ApplyLeaveData]()
    
    var ActualAppliedLeavesElementMain : ActualAppliedLeavesElement!
    var ActualAppliedLeavesDataMain = [ActualAppliedLeavesData]()
    
    var LeaveReasonsDataMain = [LeaveReasonsData]()
    var strleaveReasonsArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyLeavesApi = AppConstants.PROD_BASE_URL + AppConstants.LEAVE_APPLY
        
        actualAppliedLeavesCountApi = AppConstants.PROD_BASE_URL + AppConstants.LEAVE_ACTUAL_APPLIED_COUNT
        
        
        let loginData =  UserDefaults.standard.value(forKey: "loginData") as? Dictionary ?? [:]
        strID = loginData["EmployeeID"] as? String ?? "-"
        
        
        //Retrieving LeaveReason Data locally - - - - -
        if let leaveReasonsData = UserDefaults.standard.object(forKey: "leaveReasonsData") as? Data {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode([LeaveReasonsData].self, from: leaveReasonsData) {
                print("RETRIEVED REASON ARR ------- ",decodedData)
                
                if(decodedData.count>0){
                    self.LeaveReasonsDataMain.removeAll()
                    
                    let firstElement = LeaveReasonsData(leaveReasonID: "-1", remarks: "Select")
                    self.LeaveReasonsDataMain.append(firstElement)
                    self.LeaveReasonsDataMain.append(contentsOf: decodedData)
                    
                    
                    for i in 0...(self.LeaveReasonsDataMain.count-1)
                    {
                        self.strleaveReasonsArr.append(self.LeaveReasonsDataMain[i].remarks ?? "-")
                    }
                    
                    self.dropDown.dataSource = self.strleaveReasonsArr
                    self.lblDropdownText.text = self.dropDown.dataSource[0]
                    self.leaveReasonsId =  (self.LeaveReasonsDataMain[0].leaveReasonID ?? "-1")!
                    self.dropDown.dismissMode = .onTap
                    
                }else{
                    var alert = UIAlertView(title: "Error", message: "No Data Available", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
        
        
        //Setting up Click Listeners...
        
        let reasonsDropDown = UITapGestureRecognizer(target: self, action: #selector(self.clickDropdown))
        vwDropDown.isUserInteractionEnabled = true
        vwDropDown.addGestureRecognizer(reasonsDropDown)
        
        let viewDetails = UITapGestureRecognizer(target:self, action:#selector(self.tapShiftDetails))
        lblShiftDetails.isUserInteractionEnabled = true
        lblShiftDetails.addGestureRecognizer(viewDetails)
        
        let uploadImg = UITapGestureRecognizer(target: self, action: #selector(self.tapUploadImage))
        imvUpload.isUserInteractionEnabled = true
        imvUpload.addGestureRecognizer(uploadImg)
        
    }
    
    
    //API CALL  - - - - -
    
    func apiApplyLeaves(){
        ViewControllerUtils.sharedInstance.showLoader()
        let json: [String: Any] = ["UserID":strID,"ClientID": AppConstants.CLIENT_ID,"ClientSecret":            AppConstants.CLIENT_SECRET,"LeaveTypeID": leaveTypeId,"FromDate":strFromDate, "ToDate":strToDate, "LeaveImage":strImvBlob,"LeaveReasonID":leaveReasonsId,"AppliedLeavesDay":appliedLeaveDays,"ActualLeavesDay":actualLeaveDays
        ]
        
        DataManager.shared.makeAPICall(url: applyLeavesApi, params: json, method: .POST, success: { (response) in
            let data = response as? Data
            
            
            DispatchQueue.main.async {
                do {
                    self.ApplyLeaveElementMain = try JSONDecoder().decode(ApplyLeaveElement.self, from: data!)
                    
                    if(self.ApplyLeaveElementMain.statusCode == 200){
                        self.ApplyLeaveDataMain = self.ApplyLeaveElementMain.data ?? []
                        
                        self.clearAllFields()
                    }else{
                    }
                    
                    ViewControllerUtils.sharedInstance.removeLoader()
                }
                catch let errorData {
                    print(errorData.localizedDescription)
                    ViewControllerUtils.sharedInstance.removeLoader()
                }
            
            }
            
        }) { (Error) in
            ViewControllerUtils.sharedInstance.removeLoader()
            print(Error?.localizedDescription)
            
        }
        
    }
    
    func apiGetActualAppliedLeavesCnt(){
        
        ViewControllerUtils.sharedInstance.showLoader()
        
        let json: [String: Any] = ["FromDate":strFromDate,"Todate":strToDate,"ClientID": AppConstants.CLIENT_ID,"ClientSecret": AppConstants.CLIENT_SECRET]
        
        DataManager.shared.makeAPICall(url: actualAppliedLeavesCountApi, params: json, method: .POST, success: { (response) in
            let data = response as? Data
            
            
            DispatchQueue.main.async {
                do {
                    self.ActualAppliedLeavesElementMain = try JSONDecoder().decode(ActualAppliedLeavesElement.self, from: data!)
                    
                    if(self.ActualAppliedLeavesElementMain.statusCode == 200){
                        self.ActualAppliedLeavesDataMain = self.ActualAppliedLeavesElementMain.data ?? []
                        
                        self.actualLeaveDays = self.ActualAppliedLeavesDataMain[0].actualLeaveday ?? "0"
                        self.appliedLeaveDays = self.ActualAppliedLeavesDataMain[0].appliedLeaveDays ?? "0"
                        
                        
                        self.lblLeaveDuration.text = "\(String(self.actualLeaveDays)) Day(s)"
                        
                    }else{
                    }
                    ViewControllerUtils.sharedInstance.removeLoader()
                }
                catch let errorData {
                    print(errorData.localizedDescription)
                    ViewControllerUtils.sharedInstance.removeLoader()
                }
                
            }
            
        }) { (Error) in
            ViewControllerUtils.sharedInstance.removeLoader()
            print(Error?.localizedDescription)
            
        }
        
    }
    
    //Reset everything on Api success
    func clearAllFields(){
        
        
        self.strFromDate = ""
        self.strToDate = ""
        
        self.strImvBlob = ""
        self.leaveReasonsIndex = 0
        self.leaveReasonsId = "-1"
        self.appliedLeaveDays = "0"
        self.actualLeaveDays = "0"
        
        
        self.lblLeaveDuration.text = "-"
        self.lblDropdownText.text = self.dropDown.dataSource[0]
        dropDown.selectRow(at: 0)
        self.imvUpload.image = UIImage(named: "imageUpload")
        self.btnStartDate.setTitle("Select", for: .normal)
        self.btnEndDate.setTitle("Select", for: .normal)
        
        
    }
    
    //Button Clicks...
    @objc func tapShiftDetails(sender:UITapGestureRecognizer) {
        
        print("SHIFT DETAILS TAPPED")
        
    }
    
    @objc func tapUploadImage(sender:UITapGestureRecognizer) {
        
        print("UPLOAD IMAGE TAPPED")
        
        chooseImage()
        
    }
    
    @IBAction func tapSubmit(_ sender: Any) {
        print("SUBMIT TAPPED")
        
        if(strFromDate.elementsEqual("")){
            var alert = UIAlertView(title: nil, message: "Please Select Start Date", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else if(strToDate.elementsEqual("")){
            var alert = UIAlertView(title: nil, message: "Please Select End Date", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else if(leaveReasonsId.elementsEqual("-1")){
            var alert = UIAlertView(title: nil, message: "Please Select Leave Reason", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        else if(actualLeaveDays.elementsEqual("0")){
            var alert = UIAlertView(title: nil, message: "Actual Leave Days cannot be zero", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
            if (Utility.isConnectedToNetwork()) {
                       apiApplyLeaves()
                  }
                  else{
                      var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
                      alert.show()
                  }
           
        }
    }
    
    
    @IBAction func tapLeaveType(_ sender: Any) {
        print("LeaveType TAPPED")
        
        let vcLeaveType = self.storyboard?.instantiateViewController(withIdentifier: "LeaveTypeController") as! LeaveTypeController
        let navController = UINavigationController(rootViewController: vcLeaveType)
        vcLeaveType.delegate = self
        //   self.navigationController?.pushViewController(vcLeaveType, animated: true)
        self.navigationController?.present(navController, animated: true, completion: nil)
        
    }
    
    
    
    
    @IBAction func tapStartDate(_ sender: UIButton) {
        print("StartDate TAPPED")
        
        sender.isSelected = true
        let sb = UIStoryboard(name: "DatePicker", bundle: nil)
        
        let popup = sb.instantiateInitialViewController()  as? DatePickerController
        popup?.fromDate = fromDate
        popup?.callFrom = "applyLeaves"
        popup?.toDate = toDate
        popup?.isFromDate = true
        popup?.delegate = self
        self.present(popup!, animated: true)
    }
    
    @IBAction func tapEndDate(_ sender: UIButton) {
        print("EndDate TAPPED")
        
        
        sender.isSelected = true
        let sb = UIStoryboard(name: "DatePicker", bundle: nil)
        
        let popup = sb.instantiateInitialViewController()  as? DatePickerController
        popup?.delegate = self
        popup?.toDate = toDate
        popup?.callFrom = "applyLeaves"
        popup?.fromDate = fromDate
        popup?.isFromDate = false
        self.present(popup!, animated: true)
        
        
        
        
        
    }
    
    
    //DropDown Click...
    @objc func clickDropdown(_ sender:UITapGestureRecognizer){
        
        dropDown.show()
        
        // The view to which the drop down will appear on
        dropDown.anchorView = vwDropDown
        
        
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.lblDropdownText.text = item
            
            self.leaveReasonsIndex = index
            print("LEAVE REASONS INDEX - - -",self.leaveReasonsIndex)
            self.leaveReasonsId = (self.LeaveReasonsDataMain[self.leaveReasonsIndex].leaveReasonID ?? "-1")!
            print("LEAVE REASONS ID - - -",self.leaveReasonsId)
            
            self.dropDown.hide()
        }
    }
    
    
    //Delegate called when leave type is selected...
    func userDidSelect(item: LeaveTypeData) {
        
        self.leaveTypeId = item.leaveTypeID ?? "1"
        self.btnLeaveType.setTitle(item.leaveTypeName, for: .normal)
    }
    
    
    
    
    //Function called when Startdate and EndDate is selected...
    func updateDate(value: String, date: Date) {
        if btnStartDate.isSelected {
            btnStartDate.setTitle(value, for: .normal)
            btnStartDate.isSelected = false
            fromDate = date
            strFromDate = Utility.formattedDateFromString(dateString: value, withFormat: "yyyy-MM-dd")!
        }
        else
        {
            btnEndDate.setTitle(value, for: .normal)
            btnEndDate.isSelected = false
            toDate = date
            strToDate = Utility.formattedDateFromString(dateString: value, withFormat: "yyyy-MM-dd")!
            
        }
        
        
        if(strFromDate.elementsEqual("")){
            var alert = UIAlertView(title: nil, message: "Please Select Start Date", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else if(strToDate.elementsEqual("")){
            var alert = UIAlertView(title: nil, message: "Please Select End Date", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
            if (Utility.isConnectedToNetwork()) {
                                 self.apiGetActualAppliedLeavesCnt()
                             }
                             else{
                                 var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
                                 alert.show()
                             }
        }
    }
    
    
    // - - - - - - - - -  Function to select image - - - -  - - --  - - - -
    func chooseImage(){
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            self.openGallery(type: 1)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            self.openGallery(type: 2)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func openGallery(type: Int) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = (type == 1) ? .camera : .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    //Callback called when image is selected from camera or photo gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        let ImageData:Data = Utility.compressImage(selectedImage)
        imvUpload.image = UIImage(data:ImageData)
        strImvBlob = ImageData.base64EncodedString()
        
        // Dismiss the picker.
        picker.dismiss(animated: true, completion: nil)
    }
    
}
