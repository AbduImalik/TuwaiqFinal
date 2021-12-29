//
//  NewPostViewController.swift
//  TuwaiqFinal
//
//  Created by Abdulmalik on 18/05/1443 AH.
//

import UIKit
import NVActivityIndicatorView
class NewPostViewController: UIViewController {

    
    @IBOutlet weak var postText: UITextField!
    
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    
    @IBOutlet weak var postUrlLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func postButtonClicked(_ sender: Any) {
        if let loggedUser = UserManager.loggedInUser{
            self.loaderView.startAnimating()
            PostAPI.addNewPosts(text: postText.text!, userId: loggedUser.id , image: postUrlLabel.text!) {
                self.loaderView.stopAnimating()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addNewPost"), object: nil, userInfo: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
   
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
