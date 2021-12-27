//
//  MyProfileViewController.swift
//  TuwaiqFinal
//
//  Created by Abdulmalik on 19/05/1443 AH.
//

import UIKit
import Material
import NVActivityIndicatorView
class MyProfileViewController: UIViewController {

    // MARK: OURLETS
    
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var firstNameTextField: TextField!
    
    @IBOutlet weak var LastNameTextField: TextField!
    
    @IBOutlet weak var phoneTextField: TextField!
    
    @IBOutlet weak var EmailTextField: TextField!
    
    @IBOutlet weak var imageUrlTextField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SetUpUI()
        // Do any additional setup after loading the view.
    }
    
    func SetUpUI(){
        userImage.makeImageViewRadius()
        if let user = UserManager.loggedInUser{
            if let image = user.picture {
                userImage.setImageFromUrlToImage(stringUrl: image)
            }
            nameLabel.text = user.firstName + " " + user.lastName
            firstNameTextField.text = user.firstName
            LastNameTextField.text = user.lastName
            EmailTextField.text = user.email
            phoneTextField.text = user.phone
            imageUrlTextField.text = user.picture
            
        }
    }
    
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        guard let loggedUser = UserManager.loggedInUser else {return}
        loaderView.startAnimating()
        UserAPI.UpdateUser(userId: loggedUser.id, firstName: firstNameTextField.text!, lastName: LastNameTextField.text!, phone: phoneTextField.text!, email: EmailTextField.text!, imageUrl: imageUrlTextField.text!) { user, message in
            self.loaderView.stopAnimating()

            if let userResponse = user {
                if let image = userResponse.picture {
                    self.userImage.setImageFromUrlToImage(stringUrl: image)
                }
                self.nameLabel.text = userResponse.firstName + " " + userResponse.lastName
                self.firstNameTextField.text = userResponse.firstName
                self.LastNameTextField.text = userResponse.lastName
                self.phoneTextField.text = userResponse.phone
                self.EmailTextField.text = userResponse.email
            }
            
        }
    }
    
}
