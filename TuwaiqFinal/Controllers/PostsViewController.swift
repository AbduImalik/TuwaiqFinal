//
//  ViewController.swift
//  TuwaiqFinal
//
//  Created by Abdulmalik on 09/05/1443 AH.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
class PostsViewController: UIViewController {
    
    var page = 0
    var total = 0
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var postsTableView: UITableView!
    
    

    
    
    @IBOutlet weak var postLabel: UILabel!
    
    @IBOutlet weak var tagButtonBack: UIButton!
    
    @IBOutlet weak var postAddButton: UIButton!
    
    var posts : [Post] = []
    var tags : String?
    override func viewDidLoad() {
        postsTableView.dataSource = self
        postsTableView.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //
        NotificationCenter.default.addObserver(self, selector: #selector(userProfileTap), name: NSNotification.Name(rawValue: "userStackViewTap"), object: nil)
        
        //
        NotificationCenter.default.addObserver(self, selector: #selector(addNewPost), name: NSNotification.Name(rawValue: "addNewPost"), object: nil)
        
        //
        
        NotificationCenter.default.addObserver(self, selector: #selector(deletePost), name: NSNotification.Name(rawValue: "DeletePost"), object: nil)
        
        //
        NotificationCenter.default.addObserver(self, selector: #selector(editPost), name: NSNotification.Name(rawValue: "editPost"), object: nil)
        
        //
        
        
        // getAllPosts
        getPost()

        
        if let myTag = tags {
            postLabel.text = "#\(myTag)"
            postAddButton.isHidden = true

        }else{
            tagButtonBack.isHidden = true
        }
        
        if (UserManager.loggedInUser == nil) {
            postAddButton.isHidden = true
            
            // disable tab bar profile edit
            let tabBarControllerItems = self.tabBarController?.tabBar.items

            if let arrayOfTabBarItems = tabBarControllerItems! as AnyObject as? NSArray{

                let tabBarItemONE = arrayOfTabBarItems[2] as! UITabBarItem
                tabBarItemONE.isEnabled = false


            }
        }
        
    }
    
    @objc func editPost(notification:Notification){
        self.posts = []
        self.page = 0
        getPost()
    }
    
    @objc func addNewPost(notification:Notification){
        self.posts = []
        self.page = 0
        getPost()
    }
    
    @objc func deletePost(notification:Notification){
        self.posts = []
        self.page = 0
        getPost()
    }
    
    func getPost(){
        loaderView.startAnimating()
        PostAPI.getAllPost(page: page, tags:tags) { getResponse,total  in
            self.total = total
            self.posts.append(contentsOf: getResponse)
            self.postsTableView.reloadData()
            self.loaderView.stopAnimating()
        }

    }
    
    @IBAction func tagBackButtonClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    

    // Actions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logoutSegue" {
            UserManager.loggedInUser = nil
        }
            
    }
    
    @objc func userProfileTap(notification : Notification){
        if let cell = notification.userInfo?["cell"] as? UITableViewCell {
            if let indexPath = postsTableView.indexPath(for: cell) {
                let post = posts[indexPath.row]
                let vc = storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
                vc.user = post.owner
                present(vc, animated: true, completion: nil)
                
                
            }
        }

    }
    
}

extension PostsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = posts[indexPath.row]
        cell.postTextLabel.text = post.text
        
        if let tag = post.tags {
            cell.tags = tag
        }
        
        // Post Image
        let stringImage = post.image
        cell.postImageView.setImageFromUrlToImage(stringUrl: stringImage)
        
        
//        if let urlImage = URL(string: stringImage) {
//            if let data = try?Data(contentsOf: urlImage) {
//                cell.postImageView.image = UIImage(data: data)
//
//            }
//        }
        
        // UserIamge
        
        let stringUserImage = post.owner.picture
        cell.postUserImageView.makeImageViewRadius()
        if let image = stringUserImage {
            cell.postUserImageView.setImageFromUrlToImage(stringUrl: image)

        }
        
        cell.postNameLabel.text = post.owner.firstName + " " + post.owner.lastName
        cell.postLikeLabel.text = String(post.likes)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectPost = posts[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "PostDetailsViewController") as! PostDetailsViewController
        vc.post = selectPost
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.row == posts.count - 1 && posts.count < total {
            page+=1
            getPost()
        }
    }
    
}


