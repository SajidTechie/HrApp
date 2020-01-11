//
//  DatePickerController.swift
//  DealorsApp
//
//  Created by Goldmedal on 4/14/18.
//  Copyright © 2018 Goldmedal. All rights reserved.
//

import UIKit

class DatePickerController: UIViewController {
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblDateHeader: UILabel!

    var isFromDate = false
    var fromDate: Date?
    var toDate: Date?
    
    var initfromDate: Date?
    var inittoDate: Date?
    
    var finYear = ""
    var splitYear = [String]()
    var minYear = ""
    var maxYear = ""
    var strFromDate = ""
    var strToDate = ""
    var strInitToDate = ""

    var dateFormatter = DateFormatter()
    var selectedDate = ""
    var callFrom = ""
    
    let setStrInitFromDate = "2017-01-01"
    let setStrInitToDate = "2021-01-01"
    
    var delegate: PopupDateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("DATE - - - ",fromDate,"- - - - - ",toDate)
        
        print("DATE INIT - - - ",initfromDate,"- - - - - ",inittoDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let setInitFromDate = dateFormatter.date(from: setStrInitFromDate)
        let setInitToDate = dateFormatter.date(from: setStrInitToDate)

        if(callFrom.elementsEqual("Ledger")){

//            let currDate = Date()
//            dateFormatter.dateFormat = "dd/MM/yyyy"
//
//            let date = Date()
//            let calendar = Calendar.current
//
//            let year = calendar.component(.year, from: date)
//            let month = calendar.component(.month, from: date)
//
//            if (month >= 4) {
//                finYear = String(String(year) + "-" + String(year + 1))
//            } else {
//                finYear = String(String(year - 1) + "-" + String(year))
//            }
//
//            splitYear = finYear.components(separatedBy: "-")
//            minYear = splitYear[0]
//            maxYear = splitYear[1]
//
//            if(minYear.elementsEqual(String(year)) && month >= 4){
////                strToDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -7, to: currDate)!)
//                 strToDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 0, to: currDate)!)
//                strFromDate = "01/04/\(minYear)"
//                strInitToDate = "31/03/\(maxYear)"
//            }else{
//                strFromDate = "01/04/\(minYear)"
//                strToDate = "31/03/\(maxYear)"
//                 strInitToDate = "31/03/\(maxYear)"
//            }
//
//            initfromDate = dateFormatter.date(from: strFromDate)
//            inittoDate = dateFormatter.date(from: strInitToDate)
//            print("Init date str - - - ",strFromDate," - - - - ",strToDate)
//            print("Init date - - - ",initfromDate," - - - - ",inittoDate)
            

//            if isFromDate {
//                datePicker.minimumDate = initfromDate
//
//                if let toDate = toDate {
//                    datePicker.maximumDate = toDate
//                } else {
//                    datePicker.maximumDate = inittoDate
//                }
//            } else {
//                    datePicker.maximumDate = inittoDate
//
//                if let fromDate = fromDate {
//                    datePicker.minimumDate = fromDate
//                } else {
//                  //  datePicker.minimumDate = initfromDate
//                }
//
//            }
            
            if isFromDate {
                
                datePicker.minimumDate = initfromDate
                
                if let toDate = toDate {
                    datePicker.maximumDate = toDate
                } else {
                    datePicker.maximumDate = Date()
                }
            } else {
                datePicker.maximumDate = inittoDate
                
                if let fromDate = fromDate {
                    datePicker.minimumDate = fromDate
                } else {
                    //
                }
                // datePicker.maximumDate = Date()
            }
        }else{
            
            if isFromDate {
                datePicker.date = fromDate ?? Date()
                datePicker.minimumDate = setInitFromDate
                
                if let toDate = toDate {
                    datePicker.maximumDate = toDate
                } else {
                    datePicker.maximumDate = Date()
                }
            } else {
                datePicker.date = toDate ?? Date()
                datePicker.maximumDate = setInitToDate
                
                if let fromDate = fromDate {
                    datePicker.minimumDate = fromDate
                } else {
                    //
                }
               // datePicker.maximumDate = Date()
            }
       }
     
    }
    
 
    
    @IBAction func cancel_clicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    @IBAction func ok_clicked(_ sender: UIButton) {
        dateFormatter.dateFormat = "dd/MM/yyyy"
        selectedDate = dateFormatter.string(from: datePicker.date)
        delegate?.updateDate!(value: selectedDate, date: datePicker.date)
        dismiss(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
