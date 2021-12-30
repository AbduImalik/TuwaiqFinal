//
//  MyAlertViewController.swift
//  TuwaiqFinal
//
//  Created by Abdulmalik on 26/05/1443 AH.
//

import Foundation
import CleanyModal

class MyAlertViewController: CleanyAlertViewController {
    init(title: String?, message: String?, imageName: String? = nil, preferredStyle: CleanyAlertViewController.Style = .alert) {
        let styleSettings = CleanyAlertConfig.getDefaultStyleSettings()
        styleSettings[.tintColor] = .systemBlue
        styleSettings[.destructiveColor] = .red
        super.init(title: title, message: message, imageName: imageName, preferredStyle: preferredStyle, styleSettings: styleSettings)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
