//
//  Comment.swift
//  TuwaiqFinal
//
//  Created by Abdulmalik on 10/05/1443 AH.
//

import Foundation
struct Comment : Decodable {
    var id : String
    var message : String
    var owner : User
}
