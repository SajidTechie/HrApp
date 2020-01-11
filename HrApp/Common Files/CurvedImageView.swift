//
//  CurvedImageView.swift
//  HrApp
//
//  Created by Goldmedal on 31/12/19.
//  Copyright © 2019 Goldmedal. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CurvedImageView: UIImageView {
    
  //  @IBInspectable var cornerRadius: CGFloat = 8
    
    @IBInspectable var shadowOffsetWidth: Int = 0
  //  @IBInspectable var shadowOffsetHeight: Int = 3
 //  @IBInspectable var shadowColor: UIColor? = UIColor.black
 //  @IBInspectable var shadowOpacity: Float = 0.5
    
    
    
    @IBInspectable var cornerRadius: CGFloat = 0
           {
           didSet {
               self.layer.cornerRadius = cornerRadius
           }
       }
       
    
    
    
   // override func layoutSubviews() {
     //   layer.cornerRadius = cornerRadius
     //   let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
  //      layer.masksToBounds = false
      //  layer.shadowColor = shadowColor?.cgColor
      //  layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
      //  layer.shadowOpacity = shadowOpacity
       // layer.shadowPath = shadowPath.cgPath
   // }
    
}
