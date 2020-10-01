//
//  AnnualHolidaysCell.swift
//  HrApp
//
//  Created by Goldmedal on 30/01/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import UIKit

class AnnualHolidaysCell: UITableViewCell {
    
    @IBOutlet weak var holidayNameLbl : UILabel!
    @IBOutlet weak var holidayDayLbl : UILabel!
    @IBOutlet weak var holidayDate : UILabel!
    @IBOutlet weak var holidayDescriptionLbl : UILabel!
    @IBOutlet weak var holidayBackgroundImage : UIImageView!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // add shadow on cell
              backgroundColor = .clear // very important
              layer.masksToBounds = false
              layer.shadowOpacity = 0.7
              layer.shadowRadius = 4
              layer.shadowOffset = CGSize(width: 3, height: 3)
           layer.shadowColor = UIColor.black.cgColor

              // add corner radius on `contentView`
              contentView.backgroundColor = .white
              contentView.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
