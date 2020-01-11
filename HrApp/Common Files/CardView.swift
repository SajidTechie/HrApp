//
//  CardView.swift
//  HrApp
//
//  Created by Goldmedal on 30/12/19.
//  Copyright © 2019 Goldmedal. All rights reserved.
//
import UIKit

@IBDesignable
class CardView: UIView {
    
    @IBInspectable   var cornerRadius: CGFloat = 0
          {
          didSet {
              self.layer.cornerRadius = cornerRadius
          }
      }

    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = true
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    
}
