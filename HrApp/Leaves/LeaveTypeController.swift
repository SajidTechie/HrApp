//
//  LeaveTypeController.swift
//  HrApp
//
//  Created by Goldmedal on 02/01/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import UIKit




class LeaveTypeController: UIViewController,UITableViewDataSource, UITableViewDelegate  {
    
    
    
    @IBOutlet weak var tableView : UITableView!
     let reuseIdentifier = "leaveTypeCell"

    
    var  leaves = ["Paid Leave",
    "Annual Leave",
    "Casual Leave",
     "Sick Leave",
     "Maternity Leave",
     "Paternity Leave",
    "Others Leave",
    ]
    var  leavesDesc = ["Leave By Hours",
                   "Leave By Half Day",
                   "Leave By Whole Day",
                   "Leave By Hours",
                   "Leave By Hours",
                   "Leave By Half Day",
                   "Others Leave",
                   ]
    
    let colors = [UIColor.blue, UIColor.yellow, UIColor.magenta, UIColor.red, UIColor.brown,UIColor.black,UIColor.green]
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaves.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:LeaveTypeCell = self.tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! LeaveTypeCell
         cell.accessoryType = .disclosureIndicator
         cell.roundView.backgroundColor = self.colors[indexPath.row]
         cell.leaveTypeLbl.text = self.leaves[indexPath.row]
         cell.leaveDescriptionLbl.text = self.leavesDesc[indexPath.row]
        
        return cell
        
    }
}
