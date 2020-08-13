//
//  LoginViewController.swift
//  Richness
//
//  Created by Sobura on 6/6/18.
//  Copyright © 2018 Sobura. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

var placeholderColor = UIColor(displayP3Red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0)

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var loginButton: GradientButton!
    
    var fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    override func viewDidLayoutSubviews() {
        
        emailTextField.setPlaceholder(text: "email", placeholdercolor: placeholderColor)
        passwordTextField.setPlaceholder(text: "password", placeholdercolor: placeholderColor)
        loginButton.layer.cornerRadius = loginButton.frame.height/2
        loginButton.layer.masksToBounds = true
    }
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    @IBAction func onTapSignup(_ sender: UIButton) {
        
        let nextView = mainstoryboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.present(nextView, animated: true, completion: nil)
    }
    
    @IBAction func onTapLoginIn(_ sender: GradientButton) {
        
        if emailTextField.text == "" || passwordTextField.text == ""
        {
            self.showError(errMsg: "Please input email and password.")
            return
        }
        
        if (passwordTextField.text?.count)! < 6
        {
            self.showError(errMsg: "Please input Password with at least 6 letters.")
            return
        }
        
        if self.isValidEmail(testStr: emailTextField.text!) == false
        {
            self.showError(errMsg: "Invalid Email! Please check your Email again.")
            return
        }
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        
        let params = [
            "email" : emailTextField.text!,
            "password" : passwordTextField.text!,
            "key" : key,
            "referrer": "1"
        ]
        print(params)
        
        RichnessAlamofire.POST(LOGIN_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                
                print(responseObject)
                if (responseObject.object(forKey: "id") != nil) {
                    
                    var userid = responseObject["id"] as? String ?? ""
                    if userid == ""{
                        userid = String(describing: responseObject["id"] as? Int)
                    }
                    var ranking = responseObject["ranking"] as? String ?? ""
                    if ranking == ""{
                        ranking = String(describing: responseObject["ranking"] as? Int)
                    }
                    
                    RichnessUserDefault.setUserID(val: String(userid))
//                    RichnessUserDefault.setUserID(val: "123")
                    RichnessUserDefault.setFirstUser(val: true)
                    RichnessUserDefault.setUserRanking(val: ranking)
//                    RichnessUserDefault.setUserRanking(val: "0")

                    let nextView = mainstoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                    let nav = UINavigationController(rootViewController:nextView )
                    self.present(nav, animated: true, completion: nil)
                }
                else{
                    let error = responseObject.object(forKey: "no_user") as? String
                    if (error == "#997") {
                        self.showError(errMsg: user_error_unknown)
                    }
                    else {
                        self.showError(errMsg: error_on_server)
                    }
                }
            }
            else
            {
                self.showError(errMsg: error_on_server)
            }
        }
    }
    
    @IBAction func onTapFacebook(_ sender: UIButton) {
        
        fbLoginManager = FBSDKLoginManager()
        //permissions  ["email", "user_friends","public_profile"]
        fbLoginManager.logIn(withReadPermissions: ["email","public_profile"], from: self) { result, error in
            if error != nil
            {
                print("sdfsdf")
            }
            else if(result?.isCancelled)!
            {
                print("dfdfsdf")
            }
            else
            {
                self.fbLogin()
            }
        }
    }
    
    @IBAction func onTapInstagram(_ sender: UIButton) {
        
        let nextView = mainstoryboard.instantiateViewController(withIdentifier: "InstagramLoginViewController") as! InstagramLoginViewController
        self.present(nextView, animated: true, completion: nil)
    }
    
    func fbLogin() {
        if FBSDKAccessToken.current() != nil {
            
            RichnessAlamofire.showIndicator()
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { connection, result, error in
                RichnessAlamofire.hideIndicator()
                if error == nil {
                    if result != nil {
                        
                        let response = result as AnyObject
                        let email = response.object(forKey: "email") as! String
                        let name = response.object(forKey: "name") as! String
                        let facebookID: NSString = (response.object(forKey: "id")
                            as? NSString)!
                        let pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
                        
                        let currentDate = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd-MM-yyyy HH"
                        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
                        
                        let params = [
                            
                            "referrer" : 2,
                            "name" : name,
                            "email" : email,
                            "social_id" : facebookID,
                            "image" : pictureURL,
                            "key" : key
                            ] as [String : Any]
                        print(params)
                        
                        RichnessAlamofire.POST(SOCIALLOGIN_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
                        ) { (result, responseObject)
                            in
                            if(result){
                                print(responseObject)
                                if (responseObject.object(forKey: "id") != nil) {
                                    
                                    var userid = responseObject["id"] as? String ?? ""
                                    if userid == ""{
                                        userid = String(describing: responseObject["id"] as? Int)
                                    }
                                    var ranking = responseObject["ranking"] as? String ?? ""
                                    if ranking == ""{
                                        ranking = String(describing: responseObject["ranking"] as? Int)
                                    }
                                    
                                    RichnessUserDefault.setUserID(val: String(userid))
                                    //                    RichnessUserDefault.setUserID(val: "123")
                                    RichnessUserDefault.setFirstUser(val: true)
                                    RichnessUserDefault.setUserRanking(val: ranking)
                                    
                                    let nextView = mainstoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                                    let nav = UINavigationController(rootViewController: nextView)
                                    self.present(nav, animated: true, completion: nil)
                                }
                                else{
                                    let error = responseObject.object(forKey: "no_user") as? String
                                    if (error == "#997") {
                                        self.showError(errMsg: user_error_unknown)
                                    }
                                    else {
                                        self.showError(errMsg: error_on_server)
                                    }
                                }
                            }
                            else
                            {
                                self.showError(errMsg: error_on_server)
                            }
                        }
                    }
                }
            })
        }
    }

}
