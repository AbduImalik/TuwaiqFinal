//
//  PostAPI.swift
//  TuwaiqFinal
//
//  Created by Abdulmalik on 15/05/1443 AH.
//

import Foundation
import Alamofire
import SwiftyJSON

class PostAPI : API {

    static func getAllPost(page:Int,tags:String?,completionHandler : @escaping ([Post],Int) -> ()) {
        
        var url = baseUrl + "/post"
        if var tag = tags {
            tag = tag.trimmingCharacters(in: .whitespaces)
            url = baseUrl + "/tag/\(tag)/post"
        }
        
        let param = [
            
            "page":"\(page)"
        ]

        AF.request(url,parameters: param,encoder: URLEncodedFormParameterEncoder.default, headers: headers).responseJSON { respose in
            let jsonData = JSON(respose.value!)
            let data = jsonData["data"]
            let total = jsonData["total"].intValue
            let decoder = JSONDecoder()
            do{
                let posts = try decoder.decode([Post].self, from: data.rawData())
                completionHandler(posts,total)
            }catch let error{
                print(error)
            }
        }
    }
    
    static func addNewPosts(text:String, userId:String ,image:String,tags:[String], completionHander : @escaping () -> ()){
        

        let url = "\(baseUrl)/post/create"
        
        let param2 = RequestParameters(text: text, owner: userId, image: image, tags: tags)

        AF.request(url,method: .post,parameters: param2,encoder: JSONParameterEncoder.default, headers: headers).validate().responseJSON { respose in
            switch respose.result {
            case .success:
                completionHander()
            case .failure(let error):
                print(error)
            }

        }
        
    }

    
    static func getPostComment(id : String, completionHandler : @escaping ([Comment]) -> ()){
        
        let url = "\(baseUrl)/post/\(id)/comment"
                
        AF.request(url, headers: headers).responseJSON { respose in
            let jsonData = JSON(respose.value!)
            let data = jsonData["data"]
            let decoder = JSONDecoder()
            do{

                let comments = try decoder.decode([Comment].self, from: data.rawData())
                completionHandler(comments)
            }catch let error{
                print(error)
            }
        }
    }
    
    static func addNewCommentToPost(postId:String, userId:String,message:String, completionHander : @escaping () -> ()){
        

        let url = "\(baseUrl)/comment/create"
        let param = [
        
            "post": postId,
            "message": message,
            "owner": userId
        
        ]
        
        AF.request(url,method: .post,parameters: param,encoder: JSONParameterEncoder.default, headers: headers).validate().responseJSON { respose in
            switch respose.result {
            case .success:
                completionHander()
            case .failure(let error):
                print(error)
            }

        }
        
    }
    
    
    static func getAllTags(completionHandler : @escaping ([String]) -> ()) {
        
        let url = baseUrl + "/tag"

        AF.request(url, headers: headers).responseJSON { respose in
            let jsonData = JSON(respose.value!)
            let data = jsonData["data"]
            let decoder = JSONDecoder()
            do{
                let tags = try decoder.decode([String].self, from: data.rawData())
                completionHandler(tags)
            }catch let error{
                print(error)
            }
        }
    }

    static func deleteComment(postId:String,completionHander : @escaping () -> ()){
        

        let url = "\(baseUrl)/comment/\(postId)"
        let param = [
        
            "post": postId,
        
        ]
        
        AF.request(url,method: .delete,parameters: param,encoder: JSONParameterEncoder.default, headers: headers).validate().responseJSON { respose in
            switch respose.result {
            case .success:
                completionHander()
            case .failure(let error):
                print(error)
            }

        }
        
    }

    static func deletePost(postId:String,completionHander : @escaping () -> ()){
        

        let url = "\(baseUrl)/post/\(postId)"
        let param = [
        
            "id": postId,
        
        ]
        
        AF.request(url,method: .delete,parameters: param,encoder: JSONParameterEncoder.default, headers: headers).validate().responseJSON { respose in
            switch respose.result {
            case .success:
                completionHander()
            case .failure(let error):
                print(error)
            }

        }
        
    }
    
    static func editPost(postId:String,text:String, userId:String ,image:String, completionHander : @escaping () -> ()){
        

        let url = "\(baseUrl)/post/\(postId)"
        let param = [
        

            "owner": userId,
            "text":text,
            "image": image
        ]
        
        AF.request(url,method: .put,parameters: param,encoder: JSONParameterEncoder.default, headers: headers).validate().responseJSON { respose in
            switch respose.result {
            case .success:
                completionHander()
            case .failure(let error):
                print(error)
            }

        }
        
    }
    
    
}
