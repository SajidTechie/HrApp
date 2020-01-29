//
//  GradientButton.swift
//  HrApp
//
//  Created by Goldmedal on 10/01/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import UIKit
import Foundation
@IBDesignable
class GradientButton: RoundButton {


    @IBInspectable var startColor:   UIColor = UIColor.init(named: "primaryStartGradient") ?? UIColor.cyan { didSet { updateColors() }}
    @IBInspectable var centerColor:   UIColor = UIColor.init(named: "primaryCenterGradient") ?? UIColor.green { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = UIColor.init(named: "primaryEndGradient") ?? UIColor.blue { didSet { updateColors() }}


    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }


    
    func updatePoints() {
        if diagonalMode {
            
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint   = CGPoint(x: 1, y: 0)
        }
    }
    
    
  
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor,centerColor.cgColor, endColor.cgColor]
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        
        updatePoints()
        updateColors()
        updateAppearance()
        
    }
     func updateAppearance() {
    self.contentVerticalAlignment = .center
     self.setTitleColor(UIColor.white, for: .normal)
     self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
     self.titleLabel?.textColor = UIColor.white
    }
}
