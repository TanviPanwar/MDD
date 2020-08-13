//
//  ForgotQuestionsViewController.swift
//  MDD
//
//  Created by iOS6 on 06/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire

class ForgotQuestionsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
     
    @IBOutlet weak var securityQuestionTextField: UITextField!
    @IBOutlet weak var securityAnswerTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
   
    @IBOutlet var pickerInputView: UIView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cancelToolBarBtn: UIBarButtonItem!
    @IBOutlet weak var doneToolBarBtn: UIBarButtonItem!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var questionArray = ["hi", "bye", "there", "where"]
    var email = String()
    var securityQues = String()
    var securityId = String()
    var QuestionArray = [UserModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        securityQuestionTextField.text = securityQues
        
        securityAnswerTextField.attributedPlaceholder = NSAttributedString(string: "Please give an answer.",
                                                            attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.6392156863, blue: 0.6666666667, alpha: 1)])
  
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            
            pickerInputView.frame = CGRect(x: 0, y: 0, width: pickerInputView.frame.size.width, height: 300)
            
            cancelToolBarBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)], for: .normal)
            doneToolBarBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)], for: .normal)

            
        }
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:-
    //MARK:- Custom Methods
    
    @objc func showPicker()
    {
        securityQuestionTextField.inputView = pickerInputView
        securityQuestionTextField.inputAccessoryView = nil
       
    }
    
    //MARK:-
    //MARK:- TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == securityQuestionTextField {

            print("You edit myTextField")
        }
            
       
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK:-
    //MARK:- IB Action
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        sumbitForgotApi()
      
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        
        let row = pickerView.selectedRow(inComponent: 0)
        securityQuestionTextField.text = QuestionArray[row].security_q
        
        self.view.endEditing(true)
        
    }
    
 
    //MARK:-
    //MARK:- PickerView DataSources
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
       return QuestionArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.text = QuestionArray[row].security_q
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            
            pickerLabel.font = UIFont.systemFont(ofSize: 30)
        }
        pickerLabel.lineBreakMode = .byWordWrapping
        pickerLabel.numberOfLines = 0
        pickerLabel.sizeToFit()
        
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
         if UIDevice.current.userInterfaceIdiom == .pad {
            
            return 50.0
        }
        
      return 30.0
    }
    
    
    //MARK:-
    //MARK:- API Methods
    
    func getQuestionsApi() {
        
         let headers = [
                "Content-Type": "application/x-www-form-urlencoded",
                "Accept": "application/x-www-form-urlencoded"
            ]
            
            if Server.sharedInstance.isInternetAvailable()
            {
                Server.sharedInstance.showLoader()
                
                
                Alamofire.request(K_Base_Url + K_Security_Question_Url, method: .get,  parameters: nil, encoding: JSONEncoding.default, headers:nil)
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
                            
                            
                           if let response = json["repsonse"] as? NSArray , response.count > 0 {
                                
                                let responseArray = Server.sharedInstance.GetQuestionListObjects(array: response)
                            
                                  self.QuestionArray.append(contentsOf: responseArray)
                            
                                   }
                            
                           else {
                            
                            Server.sharedInstance.showSnackBarAlert(desc:msg as String)
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
    
    func sumbitForgotApi() {
        
        let securityQues: String = (securityQuestionTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let securityAns: String = (securityAnswerTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        self.view.endEditing(true)
        
        if securityQues.isEmpty && securityAns.isEmpty {
            
            Server.sharedInstance.showSnackBarAlert(desc:"Question and answer is required.")

            
        }
            
        else if (securityQues.isEmpty ) && (securityAns.count < 3) {
            
            Server.sharedInstance.showSnackBarAlert(desc:"Question is required and answer should be atleast 3 characters.")

        }
        
       else if securityQues.isEmpty {
            
            Server.sharedInstance.showSnackBarAlert(desc:"Question is required.")
    
        }
            
        else  if (securityAns.isEmpty) {
            
            Server.sharedInstance.showSnackBarAlert(desc:"Answer is required.")
   
        }
        else if (securityAns.count < 3) {
            
            Server.sharedInstance.showSnackBarAlert(desc:"Answer should be atleast 3 characters name.")
  
        }
            
        else {
            
            var parameters = [String: Any]()
            let row = pickerView.selectedRow(inComponent: 0)
            parameters = ["email":email, "security_q_forgot":securityId, "security_ans_forgot":securityAns]
            
            if Server.sharedInstance.isInternetAvailable()
            {
                Server.sharedInstance.showLoader()
                
                Alamofire.request(K_Base_Url + K_Forgot_Password_Question_Url, method: .post,  parameters: parameters, encoding: URLEncoding.default, headers:nil)
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
                            
                            DispatchQueue.main.async {
                                Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                                let appdelegate =  UIApplication.shared.delegate as! AppDelegate
                                let vc:LoginVC = mainStoryBoard.instantiateViewController(withIdentifier: K_Login_Stroyboard_Id) as! LoginVC
                                let nav = UINavigationController(rootViewController: vc)
                                appdelegate.window?.rootViewController = nav
                                self.navigationController?.popViewController(animated: true)
                                
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
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
