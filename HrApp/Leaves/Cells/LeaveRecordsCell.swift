//
//  LeaveRecordsCell.swift
//  HrApp
//
//  Created by Goldmedal on 08/01/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import UIKit

class LeaveRecordsCell: UITableViewCell {

    @IBOutlet weak var leaveReqLbl : UILabel!
    @IBOutlet weak var leaveTypeLbl : UILabel!
     @IBOutlet weak var startDateLbl : UILabel!
     @IBOutlet weak var endDateLbl : UILabel!
     @IBOutlet weak var leaveStatusLbl : UILabel!
     @IBOutlet weak var appliedLeaveDateLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
