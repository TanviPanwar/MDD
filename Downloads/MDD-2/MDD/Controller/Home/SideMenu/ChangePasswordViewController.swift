//
//  ChangePasswordViewController.swift
//  MDD
//
//  Created by iOS6 on 26/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

class ChangePasswordViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var oldPasssowrdTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionGivenTextField: UITextField!
    @IBOutlet weak var questionGivenLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var answerTextView: IQTextView!
    
    @IBOutlet weak var changePasswordBtn: UIButton!
    
      var checkLoginBool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        oldPasssowrdTextField.attributedPlaceholder = NSAttributedString(string: "Old Password",
                                                               attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.6392156863, blue: 0.6666666667, alpha: 1)])
        
        newPasswordTextField.attributedPlaceholder = NSAttributedString(string: "New Password",
                                                              attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.6392156863, blue: 0.6666666667, alpha: 1)])
        

        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: DefaultsIdentifier.securityQuestion) != nil) {
            
            questionGivenLabel.text = (userDefaults.value(forKey: DefaultsIdentifier.securityQuestion) as! String)
            
        }
    }
    
    
    //MARK:-
    //MARK:- TextField Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == answerTextView {
            
            textView.textContainer.maximumNumberOfLines = 4
            textView.textContainer.lineBreakMode = .byTruncatingTail
            
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @IBAction func changePasswordBtnAction(_ sender: Any) {
        
        changePasswordApi()
        
    }
    
    
    //MARK:-
    //MARK:- IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        if checkLoginBool {
            
            self.dismiss(animated: true, completion: nil)
        }
        
        else {
            sideMenuController?.setContentViewController(with: "\(7)", animated: Preferences.shared.enableTransitionAnimation)
            
            sideMenuController?.hideMenu()
            
        }
        
    }
    
    
    //MARK:-
    //MARK:- API Methods
    
    func changePasswordApi() {
        
        let oldPass:String = (oldPasssowrdTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
         let newPass:String = (newPasswordTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
         let answer:String = (answerTextView.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        var questionId = String()
        var userId = String()
    
        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: DefaultsIdentifier.questionId) != nil) {
            
            questionId = userDefaults.value(forKey: DefaultsIdentifier.questionId) as! String
            
        }
        
        if (userDefaults.value(forKey: DefaultsIdentifier.loggedInUserID) != nil) {
            
            userId =  userDefaults.value(forKey: DefaultsIdentifier.loggedInUserID) as! String
            
        }
        
        self.view.endEditing(true)
        
        if oldPass.isEmpty && newPass.isEmpty && answer.isEmpty {
           
            Server.sharedInstance.showSnackBarAlert(desc:"Please enter your old password, new password, and answer.")
            
            
        }
            
        else if newPass.isEmpty && answer.isEmpty {
            
            Server.sharedInstance.showSnackBarAlert(desc:"Please enter your new password and answer.")
            
            
        }
        
        else if oldPass.isEmpty && answer.isEmpty {
            
            Server.sharedInstance.showSnackBarAlert(desc:"Please enter your old password and answer.")
            
            
        }
            
        else if oldPass.isEmpty  && newPass.isEmpty  {
            
            Server.sharedInstance.showSnackBarAlert(desc:"Please enter your old and new password.")
            
            
        }
            
        else if oldPass.isEmpty {
           
            Server.sharedInstance.showSnackBarAlert(desc:"Please enter your old password.")
            
        }
            
        else if newPass.isEmpty {
            
            Server.sharedInstance.showSnackBarAlert(desc:"Please enter your new password.")
            
        }
            
        else if answer.isEmpty {
           
            Server.sharedInstance.showSnackBarAlert(desc:"Please enter your answer.")
            
        }
            
        else if !(newPass.isEmpty) && isValidPassword(password: newPass) == false {

            Server.sharedInstance.showSnackBarAlert(desc:"New password should contain at least one numeric value, one uppercase letter and contain 6 characters.")

        } else {
            
            
            var parameters = [String: Any]()
            parameters = ["old_password": oldPass, "new_password":newPass, "security_q_change":questionId , "security_ans_change":answer, "user_id":userId]
            
            if Server.sharedInstance.isInternetAvailable()
            {
                Server.sharedInstance.showLoader()
                
                
                Alamofire.request(K_Base_Url + K_ChangePassword_Url, method: .post,  parameters: parameters, encoding: URLEncoding.default, headers:nil)
                    .responseJSON { response in
                        
                        Server.sharedInstance.stopLoader()
                        
                        // check for errors
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling GET on /todos/1")
                            print(response.result.error!)
                            return
                        }
                        
                        // make sure we got some JSON since that's what we expect
                        guard let json = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                            }
                            return
                        }
                        
                        print(json)
                        // let status = json["status"] as? Int
                        let status = Server.sharedInstance.checkResponseForString(jsonKey:"success", dict: json as NSDictionary)
                        let msg = Server.sharedInstance.checkResponseForString(jsonKey:"message", dict: json as NSDictionary)
                        if status.boolValue {
                            
                            if self.checkLoginBool {

                                userDefaults.set("login", forKey: DefaultsIdentifier.loggedIn)
                                userDefaults.set(newPass, forKey: DefaultsIdentifier.password)
                                userDefaults.synchronize()
                                
                                let vc:HomeVC = mainStoryBoard.instantiateViewController(withIdentifier:K_Home_Storyboard_Id) as! HomeVC
                                
                                let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuNavigation")
                                
                                let window = UIApplication.shared.delegate?.window
                                // window = UIWindow(frame: UIScreen.main.bounds)
                                window!!.rootViewController = SideMenuController(contentViewController: vc,
                                                                                 menuViewController: menuViewController)
                                Server.sharedInstance.showSnackBarAlert(desc:"Logged In Successfully.")

                                
                            }
                            
                            else {
                            
                            Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                            self.sideMenuController?.setContentViewController(with: "\(7)", animated: Preferences.shared.enableTransitionAnimation)
                            
                            self.sideMenuController?.hideMenu()
                                
                            }
   
                        }
                        else {
                            
                            DispatchQueue.main.async {
                                Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                                
                            }
                        }
                }
                
            }
                
            else {
                DispatchQueue.main.async(execute: {

                    Server.sharedInstance.showSnackBarAlert(desc:"Internet connection lost, please check your internet connection.")
                })
            }
            
        }
        
        
    }
    
    
    public func isValidPassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*\\d)[A-Za-z\\dd$@$!%*?&#]{6,}$"
        //"^(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$" //"^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
