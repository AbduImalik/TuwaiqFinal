//
//  NewPostViewController.swift
//  TuwaiqFinal
//
//  Created by Abdulmalik on 18/05/1443 AH.
//

import UIKit
import NVActivityIndicatorView
class NewPostViewController: UIViewController {
    
    var postId:String?
    var postOwner:String?
    var isCreation = true
    @IBOutlet weak var postText: UITextField!
    
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    
    @IBOutlet weak var postUrlLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !isCreation {
            NotificationCenter.default.addObserver(self, selector: #selector(fillPost), name: NSNotification.Name(rawValue: "fillEditPost"), object: nil)
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func fillPost(notification:Notification){
        let text = notification.userInfo?["postText"] as! String
        self.postText.text = text
        let imageUrl = notification.userInfo?["postUrl"] as! String
        self.postUrlLabel.text = imageUrl
    }

    
    @IBAction func postButtonClicked(_ sender: Any) {
        
        if let loggedUser = UserManager.loggedInUser{
            if isCreation {
                self.loaderView.startAnimating()
                PostAPI.addNewPosts(text: postText.text!, userId: loggedUser.id , image: postUrlLabel.text!) {
                    self.loaderView.stopAnimating()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addNewPost"), object: nil, userInfo: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }else{
                self.loaderView.startAnimating()
                PostAPI.editPost(postId: postId!, text: postText.text!, userId: postOwner!, image: postUrlLabel.text!){
                    
                    if let text = self.postText.text {
                        if let imageUrl = self.postUrlLabel.text{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "editPost"), object: nil, userInfo: ["text":text,"imageUrl":imageUrl])

                        }
                    }
                    
                    
                    self.dismiss(animated: true)
                    
                }
            }

        }
        
        

   
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
