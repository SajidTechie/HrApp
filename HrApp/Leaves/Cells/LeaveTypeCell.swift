//
//  LeaveTypeCell.swift
//  HrApp
//
//  Created by Goldmedal on 02/01/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import UIKit

class LeaveTypeCell: UITableViewCell {
    
    @IBOutlet weak var leaveTypeLbl : UILabel!
    @IBOutlet weak var roundView : RoundView!
    @IBOutlet weak var leaveDescriptionLbl : UILabel!
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
