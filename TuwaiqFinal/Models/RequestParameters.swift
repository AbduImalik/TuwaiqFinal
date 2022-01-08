//
//  RequestParameters.swift
//  TuwaiqFinal
//
//  Created by Abdulmalik on 04/06/1443 AH.
//

import Foundation
struct RequestParameters: Codable {
    let text: String
    let owner: String
    let image: String
    let tags: [String]?
    
}
