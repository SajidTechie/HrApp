//
//  LeaveRecordController.swift
//  HrApp
//
//  Created by Goldmedal on 08/01/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import UIKit

class LeaveRecordController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
   
    var LeaveRecordsElementMain : LeaveRecordsElement!
    var LeaveRecordsDataMain = [LeaveRecordsData]()
    
    var leaveRecordsApi = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        tableView.tableFooterView = UIView()
        leaveRecordsApi = AppConstants.PROD_BASE_URL + AppConstants.LEAVE_RECORDS
        apiLeaveRecords()
    }
    
    
    
    func apiLeaveRecords(){
        
        let json: [String: Any] = ["UserID": 100,"ClientID": "HRM_347362","ClientSecret": "8njmLe/g9ih+6wLxYx/O4D56N+1q7sR71CzZb4uJLhIeFQNiIzMnxm1kZAIUHyxtwM+CIkYw9ct7CCebDTIQPh9oyOBPz/bpdf+7oM6cU="]
        
        DataManager.shared.makeAPICall(url: leaveRecordsApi, params: json, method: .POST, success: { (response) in
            let data = response as? Data
            print("activeSchemeApi - - - ",self.leaveRecordsApi,"------",json)
            
            DispatchQueue.main.async {
                do {
                    self.LeaveRecordsElementMain = try JSONDecoder().decode(LeaveRecordsElement.self, from: data!)
                    
                    
                    if(self.LeaveRecordsElementMain.statusCode == 200){
                        self.LeaveRecordsDataMain = self.LeaveRecordsElementMain.data ?? []
                        
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
                
                //                 if(self.ActiveSchemeArray.count>0){
                //                     self.noDataView.hideView(view: self.noDataView)
                //                 }else{
                //                     self.noDataView.showView(view: self.noDataView, from: "NDA")
                //                 }
                
            }
            
        }) { (Error) in
            ViewControllerUtils.sharedInstance.removeLoader()
            print(Error?.localizedDescription)
            // self.noDataView.showView(view: self.noDataView, from: "ERR")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LeaveRecordsDataMain.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveRecordCell", for: indexPath) as! LeaveRecordsCell
        
        cell.leaveReqLbl.text = self.LeaveRecordsDataMain[indexPath.row].employeeID ?? "-"
        cell.leaveTypeLbl.text = self.LeaveRecordsDataMain[indexPath.row].leaveType ?? "-"
        //cell.leaveReqLbl.text = self.LeaveRecordsDataMain[indexPath.row].
        cell.startDateLbl.text = self.LeaveRecordsDataMain[indexPath.row].startDate ?? "-"
        cell.endDateLbl.text = self.LeaveRecordsDataMain[indexPath.row].endDate ?? "-"
        cell.leaveStatusLbl.text = self.LeaveRecordsDataMain[indexPath.row].status ?? "-"
        cell.appliedLeaveDateLbl.text = self.LeaveRecordsDataMain[indexPath.row].appliedDate ?? "-"
       
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
