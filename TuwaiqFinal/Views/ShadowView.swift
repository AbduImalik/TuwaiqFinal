//
//  ShadowView.swift
//  TuwaiqFinal
//
//  Created by Abdulmalik on 11/05/1443 AH.
//

import UIKit

class ShadowView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpShadow()
    }
    
    func setUpShadow(){
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowRadius =  10
        self.layer.cornerRadius = 10
    }
    
}
