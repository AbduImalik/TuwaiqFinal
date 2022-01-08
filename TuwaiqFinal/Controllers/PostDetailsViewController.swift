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
class PostDetailsViewController: UIViewController, UITextFieldDelegate {
    
    var post : Post!
    var comments : [Comment] = []
    var index = 0
    
    
    
    
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postLikeLabel: UILabel!

    @IBOutlet weak var newCommentSV: UIStackView!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextField.setPadding(left: 15, right: 15)
        editButton.isHidden = true
        
        if post.owner.id == UserManager.loggedInUser?.id {
            editButton.isHidden = false
        }
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
        
        
        
        //
        
        NotificationCenter.default.addObserver(self, selector: #selector(editPost), name: NSNotification.Name(rawValue: "editPost"), object: nil)
        
        

    }
   
  
    @objc func editPost(notification:Notification){
        let text = notification.userInfo?["text"] as! String
        let urlImage = notification.userInfo?["imageUrl"] as! String
        postTitleLabel.text = text
        postImageView.setImageFromUrlToImage(stringUrl: urlImage)
    }

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

        
        let alert = UIAlertController(title: "Warning", message: "Do you want to delete the comment", preferredStyle: .alert)

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
    
    
    @IBAction func editButton(_ sender: Any) {
        
        ActionPostContextMenu()
        
    }
    
    func ActionPostContextMenu(){
        let usersItem = UIAction(title: "EditPost", image: UIImage(systemName: "pencil")) { (action) in

            self.loaderView.startAnimating()
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewPostViewController") as? NewPostViewController{
                vc.postId = self.post.id
                vc.postOwner = self.post.owner.id
                vc.isCreation = false

                self.present(vc, animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fillEditPost"), object: nil, userInfo: ["postText":self.postTitleLabel.text!,"postUrl":self.post.image])

            }
            self.loaderView.stopAnimating()

         }

        let addUserItem = UIAction(title: "DeletePost", image: UIImage(systemName: "trash"),attributes: .destructive) { (action) in

             PostAPI.deletePost(postId: self.post.id) {
                 self.dismiss(animated: true, completion: nil)
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DeletePost"), object: nil, userInfo: nil)

             }

         }

         let menu = UIMenu(title: "Action", options: .displayInline, children: [usersItem , addUserItem])

        editButton.menu = menu
        editButton.showsMenuAsPrimaryAction = true

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
        
        if currentPost.owner.id == UserManager.loggedInUser?.id || post.owner.id == UserManager.loggedInUser?.id{
            cell.hiddenButtonDelete.isHidden = false
        }else{
            cell.hiddenButtonDelete.isHidden = true
        }
        
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
