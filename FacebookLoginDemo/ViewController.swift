//
//  ViewController.swift
//  FacebookLoginDemo
//
//  Created by Chhaileng Peng on 6/22/18.
//  Copyright © 2018 Chhaileng Peng. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SVProgressHUD

class ViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let loginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        loginButton.readPermissions = ["public_profile", "email", "user_gender"]
        loginButton.delegate = self
       
        hideInfo(hide: true)
        
        if FBSDKAccessToken.current() != nil {
            SVProgressHUD.show()
            self.requestUserInfo()
        }
        
        self.view.addSubview(loginButton)
        
    }
    
}

extension ViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error == nil {
            self.requestUserInfo()
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        hideInfo(hide: true)
    }
    
    func hideInfo(hide: Bool) {
        self.profileImageView.isHidden = hide
        self.nameLabel.isHidden = hide
        self.genderLabel.isHidden = hide
        self.emailLabel.isHidden = hide
    }
    
    
    func requestUserInfo() {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id,name,gender,email"]).start(completionHandler: { (connection, results, err) in
            
            if err == nil {
                let user: [String:Any] = results as! [String:Any]
                
                self.nameLabel.text = user["name"] as? String
                self.genderLabel.text = user["gender"] as? String
                self.emailLabel.text = user["email"] as? String
                
                let id = user["id"] as? String
                let url = URL(string: "https://graph.facebook.com/\(String(describing: id!))/picture?type=large")
                let data = try? Data(contentsOf: url!)
                self.profileImageView.image = UIImage(data: data!)
                self.hideInfo(hide: false)
                SVProgressHUD.dismiss()
            }
            
        })
    }
    
    
}















