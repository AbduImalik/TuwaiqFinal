//
//  setPaddingLabel.swift
//  TuwaiqFinal
//
//  Created by Abdulmalik on 28/05/1443 AH.
//

import Foundation
import UIKit

extension UILabel {
    func setPaddingLabel(margin: CGFloat = 10) {
        if let textString = self.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = margin
            paragraphStyle.headIndent = margin
            paragraphStyle.tailIndent = -margin
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}
