//
//  ForgotPasswordViewController.swift
//  MDD
//
//  Created by iOS6 on 06/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
  
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                            attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.6392156863, blue: 0.6666666667, alpha: 1)])
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:-
    //MARK:- IB Action
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        forgotPasswordApi()

        
    }
    
    //MARK:-
    //MARK:- API Methods
    
    func forgotPasswordApi() {
        
        let email:String = (emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        self.view.endEditing(true)
        
        if email.isEmpty {
            
            Server.sharedInstance.showSnackBarAlert(desc:"Please enter your email address.")

            
        }
        else if !Server.sharedInstance.isEmailValid(email: email) {
            
            Server.sharedInstance.showSnackBarAlert(desc:"This is not a valid email address.")

            
        } else {
  
            var parameters = [String: Any]()
            parameters = ["email":email]
            
            if Server.sharedInstance.isInternetAvailable()
            {
                Server.sharedInstance.showLoader()
                
                
                Alamofire.request(K_Base_Url + K_Forgot_Password_Email_Url, method: .post,  parameters: parameters, encoding: URLEncoding.default, headers:nil)
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
                        let status = Server.sharedInstance.checkResponseForString(jsonKey:"success", dict: json as NSDictionary)
                        let msg = Server.sharedInstance.checkResponseForString(jsonKey:"message", dict: json as NSDictionary)
                        if status.boolValue {
                            
                            let response = json["repsonse"] as! NSDictionary
                            let securityQuestion = response["SecurityQuestion"] as! String
                            let securityQuestion_Id = response["SecurityQuestion_Id"] as! String

                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotQuestionsViewController") as! ForgotQuestionsViewController
                            
                            vc.email = email
                            vc.securityQues = securityQuestion
                            vc.securityId = securityQuestion_Id
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                            
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
