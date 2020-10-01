//
//  AnnualHolidaysController.swift
//  HrApp
//
//  Created by Goldmedal on 30/01/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import UIKit

class AnnualHolidaysController: BaseViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var noDataView: NoDataView!
    let reuseIdentifier = "annualHolidaysCell"
    
    var HolidayListElementMain : HolidayListElement!
    var HolidayListDataMain = [HolidayListData]()
    
    var annualHolidaysApi = ""
    let cellSpacingHeight: CGFloat = 15
    
    var holidayImages = [UIImage(named: "RepublicDay"),UIImage(named: "Holi"),
    UIImage(named: "LabourDay"),UIImage(named: "Rakshabandhan"),
    UIImage(named: "IndependenceDay"),UIImage(named: "GaneshChaturthi"),
    UIImage(named: "GandhiJayanti"),UIImage(named: "Dussehra"),
    UIImage(named: "Diwali"),UIImage(named: "BhaiDooj"),]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        
        self.noDataView.hideView(view: self.noDataView)
        
        tableView.tableFooterView = UIView()
        annualHolidaysApi = AppConstants.PROD_BASE_URL + AppConstants.UPCOMING_HOLIDAY
        
        
        if (Utility.isConnectedToNetwork()) {
            print("Internet connection available")
            
            apiAnnualHolidays()
            
        }
        else {
            print("No internet connection available")
            
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            self.noDataView.showView(view: self.noDataView, from: "NET")
        }
    }
    
    
    func apiAnnualHolidays(){
        
        let json: [String: Any] = ["ClientID": AppConstants.CLIENT_ID,"ClientSecret": AppConstants.CLIENT_SECRET,"HolidayType":"ALL"]
        
        DataManager.shared.makeAPICall(url: annualHolidaysApi, params: json, method: .POST, success: { (response) in
            let data = response as? Data
            
            
            DispatchQueue.main.async {
                do {
                    self.HolidayListElementMain = try JSONDecoder().decode(HolidayListElement.self, from: data!)
                    
                    if(self.HolidayListElementMain.statusCode == 200){
                        self.HolidayListDataMain = self.HolidayListElementMain.data ?? []
                        
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
                
                if(self.HolidayListDataMain.count>0){
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
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.HolidayListDataMain.count
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AnnualHolidaysCell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! AnnualHolidaysCell
        
        cell.holidayNameLbl.text = self.HolidayListDataMain[indexPath.section].holidayName
        
        if((self.HolidayListDataMain[indexPath.section]
            .holidayFromDate?.elementsEqual(self.HolidayListDataMain[indexPath.section]
                .holidayToDate ?? "")) == true){
            cell.holidayDayLbl.text = self.HolidayListDataMain[indexPath.section].fromDateDay
            cell.holidayDate.text = self.HolidayListDataMain[indexPath.section].fromDateFormat
        }else{
            
            cell.holidayDayLbl.text = "\(self.HolidayListDataMain[indexPath.section].fromDateDay ?? "-") - \(self.HolidayListDataMain[indexPath.section].toDateDay ?? "-")"
            cell.holidayDate.text = "\(self.HolidayListDataMain[indexPath.section].fromDateFormat ?? "-") - \(self.HolidayListDataMain[indexPath.section].toDateFormat ?? "-")"
        }
        cell.holidayDescriptionLbl.text = self.HolidayListDataMain[indexPath.section].description ?? "No info available"
       
        if(indexPath.section < self.holidayImages.count){
            cell.holidayBackgroundImage.image = self.holidayImages[indexPath.section]
        }
        
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
        
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
    
}




