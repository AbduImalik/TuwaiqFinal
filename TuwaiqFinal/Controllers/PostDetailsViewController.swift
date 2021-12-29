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
    var index = 0
    
    
    
    
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
        
        UserManager.postUser = [post]
        
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
        
        postImageView.layer.cornerRadius = 15
        
        commentTextField.layer.cornerRadius = 15
        
        
        // Get comment from api
        //loaderView.startAnimating()
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
    

    @IBAction func deleteComment(_ sender: Any) {
        
        
        
        var superview = (sender as AnyObject).superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view?.superview
        }
        guard let cell = superview as? UITableViewCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = commentTableView.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }


        
        let alert = UIAlertController(title: "Warning Title", message: "Do you want to delete the comment", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            DispatchQueue.main.async {
                
                PostAPI.deleteComment(postId: self.comments[indexPath.row].id) {
                    
                    self.commentTableView.reloadData()
                    self.getPostComment()
                    
                }
                
            }
        }

        //Add the actions to the alert controller
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        //Present the alert controller
        present(alert, animated: true, completion: nil)

        
        
    }
    
    
    
    func getPostComment(){
        PostAPI.getPostComment(id: post.id) { postComment in
            self.comments = postComment
            self.commentTableView.reloadData()
            //self.loaderView.stopAnimating()
    
        }
    }
    
    @IBAction func messageButtonClicked(_ sender: Any) {
        let comment = commentTextField.text!

        if let user = UserManager.loggedInUser {
            PostAPI.addNewCommentToPost(postId: post.id, userId: user.id, message: comment) {
                self.getPostComment()
                self.commentTextField.text = ""
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
