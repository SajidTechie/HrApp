//
//  LeaveTypeController.swift
//  HrApp
//
//  Created by Goldmedal on 02/01/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import UIKit


protocol LeaveTypeSelectedDelegate: class {
    func userDidSelect(item: LeaveTypeData)
}

class LeaveTypeController: BaseViewController,UITableViewDataSource, UITableViewDelegate  {
    
    
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var noDataView: NoDataView!
     @IBOutlet weak var backButton: UIBarButtonItem!
    
    
    // making this a weak variable so that it won't create a strong reference cycle
    weak var delegate: LeaveTypeSelectedDelegate? = nil

    
    let reuseIdentifier = "leaveTypeCell"
    
    var LeaveTypeElementMain : LeaveTypeElement!
    var LeaveTypeDataMain = [LeaveTypeData]()
    
    var leaveTypeApi = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         self.noDataView.hideView(view: self.noDataView)
        
        tableView.tableFooterView = UIView()
        leaveTypeApi = AppConstants.PROD_BASE_URL + AppConstants.LEAVE_TYPE
        
        
        
        if (Utility.isConnectedToNetwork()) {
        print("Internet connection available")
        OperationQueue.main.addOperation {
            self.apiLeaveType()
            }
        }
        else {
            print("No internet connection available")
            
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            self.noDataView.showView(view: self.noDataView, from: "NET")
        }
    }
    
    
    
    @IBAction func btnBackButton(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    func apiLeaveType(){
        
        let json: [String: Any] = ["UserID": 100,"ClientID": AppConstants.CLIENT_ID,"ClientSecret": AppConstants.CLIENT_SECRET]
        
        DataManager.shared.makeAPICall(url: leaveTypeApi, params: json, method: .POST, success: { (response) in
            let data = response as? Data
            print("activeSchemeApi - - - ",self.leaveTypeApi,"------",json)
            
            DispatchQueue.main.async {
                do {
                    self.LeaveTypeElementMain = try JSONDecoder().decode(LeaveTypeElement.self, from: data!)
                    
                    if(self.LeaveTypeElementMain.statusCode == 200){
                        self.LeaveTypeDataMain = self.LeaveTypeElementMain.data ?? []
                        
                        
                        
        
                        
                    }else{
                        
                        //var errData : String = self.LeaveRecordsElementMain.errors[0].errorCode
                        
                    }
                }
                catch let errorData {
                    print(errorData.localizedDescription)
                }
                
                
                if(self.tableView != nil)
                {
                    self.tableView.reloadData()
                }
                
                                 if(self.LeaveTypeDataMain.count>0){
                                     self.noDataView.hideView(view: self.noDataView)
                                 }else{
                                     self.noDataView.showView(view: self.noDataView, from: "NDA")
                                 }
                
            }
            
        }) { (Error) in
            ViewControllerUtils.sharedInstance.removeLoader()
            print(Error?.localizedDescription)
           self.noDataView.showView(view: self.noDataView, from: "ERR")
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LeaveTypeDataMain.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:LeaveTypeCell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! LeaveTypeCell
       // cell.accessoryType = .disclosureIndicator
        //cell.roundView.backgroundColor = self.LeaveTypeDataMain[indexPath.row].leaveTypeColour
        cell.leaveTypeLbl.text = self.LeaveTypeDataMain[indexPath.row].leaveTypeID
        cell.leaveDescriptionLbl.text = self.LeaveTypeDataMain[indexPath.row].leaveTypeName
    
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // call this method on whichever class implements our delegate protocol
        delegate?.userDidSelect(item: self.LeaveTypeDataMain[indexPath.row])

               // go back to the previous view controller
        
        self.dismiss(animated: true, completion: nil)
     
         
    }
    
    
}
