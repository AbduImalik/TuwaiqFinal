//
//  User.swift
//  TuwaiqFinal
//
//  Created by Abdulmalik on 09/05/1443 AH.
//

import Foundation
struct User : Decodable{
    var id : String
    var firstName : String
    var lastName : String
    var picture : String?
    var phone : String?
    var email : String?
    var gender : String?
    var location : Location?
}
