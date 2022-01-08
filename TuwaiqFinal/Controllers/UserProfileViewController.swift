//
//  UserProfileViewController.swift
//  TuwaiqFinal
//
//  Created by Abdulmalik on 12/05/1443 AH.
//

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView
class UserProfileViewController: UIViewController {
    var user : User!
    
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var userTittle: UILabel!
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userGender: UILabel!
    @IBOutlet weak var userCountry: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        // requeset
        loaderView.startAnimating()
        UserAPI.getUserAPI(id: user.id) { userResponse in
            self.loaderView.stopAnimating()
            self.user = userResponse
            self.setupUI()
        }
        
        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    

    func setupUI(){
        userTittle.text = user.firstName
        userName.text = user.firstName + " " + user.lastName
        userimage.makeImageViewRadius()
        if let image = user.picture {
            userimage.setImageFromUrlToImage(stringUrl: image)

        }
        userPhone.text = user.phone
        userGender.text = user.gender
        userEmail.text = user.email
        
        if let location = user.location {
            userCountry.text = location.country! + " " + location.city!
        }
    }
}
