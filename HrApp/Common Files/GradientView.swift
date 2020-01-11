//
//  GradientView.swift
//  HrApp
//
//  Created by Goldmedal on 10/01/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//
import UIKit
import Foundation
@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var startColor:   UIColor = UIColor.init(named: "secondaryStartGradient") ?? UIColor.blue { didSet { updateColors() }}
    @IBInspectable var centerColor:   UIColor = UIColor.init(named: "secondaryCenterGradient") ?? UIColor.green { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = UIColor.init(named: "secondaryEndGradient") ?? UIColor.green { didSet { updateColors() }}
    @IBInspectable var diagonalMode:  Bool =  true { didSet { updatePoints() }}
    
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
        
        
    }
}
