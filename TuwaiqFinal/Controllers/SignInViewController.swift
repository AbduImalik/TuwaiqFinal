//
//  SignInViewController.swift
//  TuwaiqFinal
//
//  Created by Abdulmalik on 16/05/1443 AH.
//

import UIKit

class SignInViewController: UIViewController {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func signInButtonClicked(_ sender: Any) {
        UserAPI.SignInUser(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!) { loggedInUser , errorMessage in
            
            if errorMessage != nil {
                let alert = UIAlertController(title: "error", message: errorMessage, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                self.firstNameTextField.text = ""
                self.lastNameTextField.text = ""
            }else{
                if loggedInUser != nil {
                    UserDefaults.standard.setValue(self.firstNameTextField.text!, forKey: "firstName")
                    UserManager.loggedInUser = loggedInUser
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar")
                    self.present(vc!,animated: true)
                }
            }
        }
    }
    
}
