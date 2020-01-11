//
//  LeaveRecordController.swift
//  HrApp
//
//  Created by Goldmedal on 08/01/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import UIKit

class LeaveRecordController: UITableViewController {

    var  leaves = ["Paid Leave",
    "Annual Leave",
    "Casual Leave",
     "Sick Leave",
     "Maternity Leave",
     "Paternity Leave",
    "Others Leave",
    ]
    
    var  leavesDates = ["2019.05.18",
      "2020.11.20",
      "2020.05.31",
       "2020.05.31",
       "2020.05.31",
       "2020.05.31",
      "2020.05.25",
      ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return leaves.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaveRecordCell", for: indexPath) as! LeaveRecordsCell
 
         cell.leaveReqLbl.text = self.leaves[indexPath.row]
         cell.leaveTypeLbl.text = self.leaves[indexPath.row]
         cell.leaveReqLbl.text = self.leaves[indexPath.row]
         cell.startDateLbl.text = self.leaves[indexPath.row]
         cell.endDateLbl.text = self.leaves[indexPath.row]
         cell.leaveStatusLbl.text = self.leaves[indexPath.row]
         cell.appliedLeaveDateLbl.text = self.leavesDates[indexPath.row]
        
        return cell
    }
  
}
