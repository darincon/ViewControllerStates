//
//  UnderlinedTextField.swift
//  UIStates
//
//  Created by Diego Rincon on 4/15/17.
//  Copyright © 2017 Scirestudios. All rights reserved.
//

import UIKit

class UnderlinedTextField: UITextField {
    
    let underlineColor: UIColor
    let underlineThickness: CGFloat
    
    private let borderLayer: CALayer
    
    init(underlineColor: UIColor, thickness: CGFloat) {
        self.borderLayer = CALayer()
        self.underlineColor = underlineColor
        self.underlineThickness = thickness
        
        super.init(frame: CGRect.zero)
        
        borderLayer.borderColor = underlineColor.cgColor
        borderLayer.borderWidth = thickness
        
        layer.addSublayer(borderLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        borderLayer.frame = CGRect(x: 0.0, y: frame.height - underlineThickness, width: frame.width, height: underlineThickness)
    }
}
