//
//  CategoryButtonBehaviour.swift
//  MyPets
//
//  Created by alumnos on 14/02/2020.
//  Copyright © 2020 alumnos. All rights reserved.
//

import UIKit

class CategoryButtonBehaviour : UIButton {
    
    
    func setBackgroundColor(color: UIColor, for state: UIControl.State) {
        setShadow()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    
    func setupButton() {
        setShadow()
        setTitleColor(.black, for: .normal)
        
        
        layer.cornerRadius   = 15
        layer.borderColor    = UIColor.darkGray.cgColor
    }
    
    
    private func setShadow() {
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 4.0)
        layer.shadowRadius  = 4
        layer.shadowOpacity = 0.5
        clipsToBounds       = true
        layer.masksToBounds = false
    }
    
    
    func shake() {
        let shake           = CABasicAnimation(keyPath: "position")
        shake.duration      = 0.1
        shake.repeatCount   = 2
        shake.autoreverses  = true
        
        let fromPoint       = CGPoint(x: center.x - 8, y: center.y)
        let fromValue       = NSValue(cgPoint: fromPoint)
        
        let toPoint         = CGPoint(x: center.x + 8, y: center.y)
        let toValue         = NSValue(cgPoint: toPoint)
        
        shake.fromValue     = fromValue
        shake.toValue       = toValue
        
        layer.add(shake, forKey: "position")
    }
    
    
}
