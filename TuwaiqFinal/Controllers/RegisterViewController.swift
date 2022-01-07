//
//  RegisterViewController.swift
//  TuwaiqFinal
//
//  Created by Abdulmalik on 15/05/1443 AH.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneNoTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func setUpUI(){
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        emailTextField.text = ""
        
    }
    
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        UserAPI.registerUser(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, email: emailTextField.text!, phone: phoneNoTextField.text!) { user,errorMessage in
            if errorMessage != nil {
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                self.setUpUI()
            }else{
                let alert = UIAlertController(title: "Success", message: "User Create", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { alert in
                    self.dismiss(animated: true, completion: nil)
                    self.setUpUI()
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }

        }
    }
    
}
