//
//  PopupDateDelegate.swift
//  
//
//  Created by Goldmedal on 4/23/18.
//

import Foundation

@objc protocol PopupDateDelegate {
    @objc optional func updateDate(value: String, date: Date)
    @objc optional func updateValue(value: String,from: String)
    @objc optional func updatePositionValue(value: String,position: Int,from: String)
    @objc optional func showValue(value: String)
    @objc optional func showBtnColor(value: Bool)
    @objc optional func showParty(value: String,userId: String)
    @objc optional func refreshApi()
}
