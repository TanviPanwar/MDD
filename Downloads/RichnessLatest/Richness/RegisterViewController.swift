//
//  ViewController.swift
//  Richness
//
//  Created by Sobura on 6/5/18.
//  Copyright © 2018 Sobura. All rights reserved.
//

import UIKit
import SCLAlertView

class RegisterViewController: UIViewController {

    @IBOutlet weak var nickNameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var confirmPasswordTextField: CustomTextField!
    @IBOutlet weak var registerButton: GradientButton!
    @IBOutlet weak var uncheckImgView: UIImageView!
    @IBOutlet weak var checkImgView: UIImageView!
    
    var isChecked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isChecked {
            registerButton.isUserInteractionEnabled = true
        }
        else{
            registerButton.isUserInteractionEnabled = false
        }
     
    }
    
    override func viewDidLayoutSubviews() {
        
        nickNameTextField.setPlaceholder(text: "name", placeholdercolor: placeholderColor)
        emailTextField.setPlaceholder(text: "email", placeholdercolor: placeholderColor)
        passwordTextField.setPlaceholder(text: "password", placeholdercolor: placeholderColor)
        confirmPasswordTextField.setPlaceholder(text: "confirm password", placeholdercolor: placeholderColor)
        registerButton.layer.cornerRadius = registerButton.frame.height/2
        registerButton.layer.masksToBounds = true
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    @IBAction func onTapCheck(_ sender: UIButton) {
        
        if isChecked {
            
            isChecked = false
            checkImgView.isHidden = true
            registerButton.isUserInteractionEnabled = false
        }
        else{
            
            isChecked = true
            checkImgView.isHidden = false
            registerButton.isUserInteractionEnabled = true
        }
    }
    @IBAction func onTapRegister(_ sender: Any) {
        
        if nickNameTextField.text == ""
        {
            self.showError(errMsg: "Please insert your Name..")
            return
        }
        
        if emailTextField.text == ""
        {
            self.showError(errMsg: "Please insert your Email.")
            return
        }
        if passwordTextField.text == ""
        {
            self.showError(errMsg: "Please insert Password.")
            return
        }
        if confirmPasswordTextField.text == ""
        {
            self.showError(errMsg: "Please insert Confirm Password.")
            return
        }
        
        if passwordTextField.text != confirmPasswordTextField.text
        {
            self.showError(errMsg: "Password does not match")
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
            "nick_name" : nickNameTextField.text!,
            "key" : key,
            "referrer" : "email"
        ]
        print(params)
        
        RichnessAlamofire.POST(REGISTER_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                
                print(responseObject)
                if (responseObject.object(forKey: "id") as? Int) != nil{
                    
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    let btncolor = UIColor(displayP3Red: 34/255, green: 181/255, blue: 115/255, alpha: 1.0)
                    
                    alertView.addButton("OK", backgroundColor: btncolor, textColor: .white, showTimeout: nil, action: {
                        self.leftToRight()
                        self.dismiss(animated: false, completion: nil)
                    })
                    alertView.showSuccess("Success", subTitle: register_success)
                }
            }
            else
            {
                let error = responseObject.object(forKey: "error") as? String
                if (error == "#997") {
                   self.showError(errMsg: register_error_already)
                }
                else {
                    self.showError(errMsg: error_on_server)
                }
            }
        }
    }
    
    @IBAction func onTapSignIn(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

