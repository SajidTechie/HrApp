//
//  CalendarLeaveController.swift
//  HrApp
//
//  Created by Goldmedal on 1/6/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarLeaveController: BaseViewController,FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance {
 
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnChangeDate: UIButton!
    
    let fillDefaultColors = ["2020/01/02": UIColor.purple, "2020/01/06": UIColor.green, "2020/01/13": UIColor.cyan, "2020/01/29": UIColor.yellow, "2020/01/03": UIColor.purple, "2020/01/07": UIColor.green, "2020/01/19": UIColor.cyan, "2020/01/20": UIColor.yellow, "2020/01/04": UIColor.purple, "2020/01/11": UIColor.green, "2020/01/22": UIColor.cyan, "2020/01/26": UIColor.magenta]
    
    fileprivate lazy var dateFormatter1: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy/MM/dd"
           return formatter
       }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calendar.dataSource = self
        calendar.delegate = self
    }
    
      
       func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
           let key = self.dateFormatter1.string(from: date)
           if let color = self.fillDefaultColors[key] {
               return color
           }
           return nil
       }
       
       func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
           let key = self.dateFormatter1.string(from: date)
           if let color = self.fillDefaultColors[key] {
               return color
           }
           return nil
       }
    
    @IBAction func onDateChange(_ sender: Any) {
        
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        let leaveApplicationStoryBoard: UIStoryboard = UIStoryboard(name: "Leaves", bundle: nil)
                           let vcLeaveApplication = leaveApplicationStoryBoard.instantiateViewController(withIdentifier: "LeaveApplicationController") as! LeaveApplicationController
                                                           self.navigationController!.pushViewController(vcLeaveApplication, animated: true)
    }
    
    @IBAction func onEdit(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "PunchInOut", bundle: nil)
                                 let vcMap = storyBoard.instantiateViewController(withIdentifier: "MapPunchInOutController") as! MapPunchInOutController
                                 self.navigationController!.pushViewController(vcMap, animated: true)
    }

}
