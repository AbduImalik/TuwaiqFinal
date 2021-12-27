//
//  UserAPI.swift
//  TuwaiqFinal
//
//  Created by Abdulmalik on 15/05/1443 AH.
//

import Foundation
import Alamofire
import SwiftyJSON
class UserAPI : API{
    
    static func getUserAPI(id:String, completionHander : @escaping (User) ->()){
        

        let url = "\(baseUrl)/user/\(id)"
        AF.request(url, headers: headers).responseJSON { respose in
            let jsonData = JSON(respose.value!)
            let data = jsonData
            let decoder = JSONDecoder()
            do{
                let user = try decoder.decode(User.self, from: data.rawData())
                completionHander(user)
            }catch let error{
                print(error)
            }
        }
        
    }
    
    static func registerUser(firstName:String,lastName:String,email:String, completionHander :  @escaping (User?, String?) ->()){
        

        let url = "\(baseUrl)/user/create"
        let param = [
        
            "firstName": firstName,
            "lastName": lastName,
            "email": email
        
        ]
        AF.request(url,method: .post,parameters: param,encoder: JSONParameterEncoder.default, headers: headers).validate().responseJSON { respose in
            switch respose.result {
            case .success:
                print("success")
                let jsonData = JSON(respose.value!)
                let decoder = JSONDecoder()
                print(decoder)
                do{
                    let user = try decoder.decode(User.self, from: jsonData.rawData())
                    completionHander(user,nil)
                }catch let error{
                    print(error)
                }
            case .failure:
                let jsonData = JSON(respose.data!)
                let data = jsonData["data"]
                let emailError = data["email"].stringValue
                let firstNameError = data["firstName"].stringValue
                let lastNameError = data["lastName"].stringValue
                
                let errorMessage = emailError + " " + firstNameError + " " + lastNameError
                completionHander(nil, errorMessage)

            }

        }
        
    }
    
    static func SignInUser(firstName:String,lastName:String,completionHander :  @escaping (User?, String?) ->()){
        

        let url = "\(baseUrl)/user"
        let param = [
        
            "created" : "1"
        
        ]
        AF.request(url,method: .get,parameters: param,encoder: URLEncodedFormParameterEncoder.default, headers: headers).validate().responseJSON { respose in
            switch respose.result {
            case .success:
                print("success")
                let jsonData = JSON(respose.value!)
                let data = jsonData["data"]
                let decoder = JSONDecoder()
                print(decoder)
                do{
                    let users = try decoder.decode([User].self, from: data.rawData())
                    var foundUser : User?
                    for user in users {
                        if user.firstName == firstName && user.lastName == lastName {
                            foundUser = user
                            break
                        }
                    }
                    	
                    if let user = foundUser {
                        completionHander(user,nil)
                    }else{
                        completionHander(nil,"firstName or lastName don't match any user")
                    }
                }catch let error{
                    print(error)
                }
            case .failure:
                let jsonData = JSON(respose.data!)
                let data = jsonData["data"]
                let firstNameError = data["firstName"].stringValue
                let lastNameError = data["lastName"].stringValue
                
                let errorMessage = firstNameError + " " + lastNameError
                completionHander(nil, errorMessage)

            }

        }
        
    }

    
    static func UpdateUser(userId:String,firstName:String,lastName:String,phone:String,email:String,imageUrl:String, completionHander :  @escaping (User?, String?) ->()){
        

        let url = "\(baseUrl)/user/\(userId)"
        let param = [
            
            "firstName": firstName,
            "lastName": lastName,
            "phone": phone,
            "email": email,
            "picture": imageUrl
        
        ]
        AF.request(url,method: .put,parameters: param,encoder: JSONParameterEncoder.default, headers: headers).validate().responseJSON { respose in
            switch respose.result {
            case .success:
                print("success")
                let jsonData = JSON(respose.value!)
                let decoder = JSONDecoder()
                do{
                    let user = try decoder.decode(User.self, from: jsonData.rawData())
                    completionHander(user,nil)
                }catch let error{
                    print(error)
                }
            case .failure:
                let jsonData = JSON(respose.data!)
                let data = jsonData["data"]
                let firstNameError = data["firstName"].stringValue
                let lastNameError = data["lastName"].stringValue
                
                let errorMessage = firstNameError + " " + lastNameError
                completionHander(nil, errorMessage)

            }

        }
        
    }


    
}
