//
//  PostDetailsViewController.swift
//  TuwaiqFinal
//
//  Created by Abdulmalik on 10/05/1443 AH.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
class PostDetailsViewController: UIViewController {
    var post : Post!
    var comments : [Comment] = []
    var likes = 0
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postLikeLabel: UILabel!

    @IBOutlet weak var newCommentSV: UIStackView!
    
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var likeImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        commentTableView.dataSource = self
        commentTableView.delegate = self

        userNameLabel.text = post.owner.firstName + " " + post.owner.lastName
        postTitleLabel.text = post.text
        postLikeLabel.text = String(post.likes)
        if let image = post.owner.picture {
            userImage.setImageFromUrlToImage(stringUrl: image)
        }
        userImage.makeImageViewRadius()
        
        postImageView.setImageFromUrlToImage(stringUrl: post.image)
        
        
        
        
        // Get comment from api
        loaderView.startAnimating()
        getPostComment()
 
        
        if UserManager.loggedInUser == nil{
            newCommentSV.isHidden = true
        }
        

    }
//    
//    @IBAction func LikeAdd(_ sender: Any) {
//        
//        likes = post.likes + 1
//        self.postLikeLabel.text = String(likes)
//        
//    }
//    
    
    
    
    func getPostComment(){
        PostAPI.getPostComment(id: post.id) { postComment in
            self.comments = postComment
            self.commentTableView.reloadData()
            self.loaderView.stopAnimating()
        }
    }
    
    @IBAction func messageButtonClicked(_ sender: Any) {
        let comment = commentTextField.text!

        if let user = UserManager.loggedInUser {
            print(user.id)
            PostAPI.addNewCommentToPost(postId: post.id, userId: user.id, message: comment) {
                self.getPostComment()
            }
        }


        
        
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension PostDetailsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentPost = comments[indexPath.row]
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        cell.commentMessageLabel.text = comments[indexPath.row].message
        cell.userNameLabel.text = comments[indexPath.row].owner.firstName + " " + comments[indexPath.row].owner.lastName
        
        //User Image
        if let userImage = currentPost.owner.picture {
            cell.userImageView.setImageFromUrlToImage(stringUrl: userImage)

        }
        cell.userImageView.makeImageViewRadius()

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
