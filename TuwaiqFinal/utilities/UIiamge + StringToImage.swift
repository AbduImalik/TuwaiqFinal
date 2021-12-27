//
//  UIiamge + StringToImage.swift
//  TuwaiqFinal
//
//  Created by Abdulmalik on 11/05/1443 AH.
//

import Foundation
import UIKit


extension UIImageView {
    
    func setImageFromUrlToImage(stringUrl : String) {
        
        if let url = URL(string: stringUrl) {
            if let data = try?Data(contentsOf: url){
                self.image = UIImage(data: data)
            }
        }
        
        
    }
    
    func makeImageViewRadius(){
        self.layer.cornerRadius = self.frame.height / 2

    }
    
}

