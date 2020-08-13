//
//  LoginVC.swift
//  MDD
//
//  Created by IOS3 on 17/05/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire

let mainStoryBoard = UIStoryboard(name:"Main", bundle: nil)
class LoginVC: UIViewController {



    //MARK:- Outlets

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var archery_icon: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var archery_icon_top_constraint: NSLayoutConstraint!
    @IBOutlet weak var archery_icon_width_constraint: NSLayoutConstraint!
    @IBOutlet weak var archery_icon_height_constraint: NSLayoutConstraint!
    @IBOutlet weak var email_lbl_top_constraint: NSLayoutConstraint!
    @IBOutlet weak var password_lbl_top_constraint: NSLayoutConstraint!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var signup_link_view: UIView!
    @IBOutlet weak var signUp_bottom_constraint: NSLayoutConstraint!

    //MARK:- Variables
    var userObj = UserModel()
    var textfieldDelegate : TextFieldDelegate?
    var keyBoardDelegate : KeyboardDelegate?

    //MARK:- Object Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                               attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.6392156863, blue: 0.6666666667, alpha: 1)])
        passwordTF.attributedPlaceholder = NSAttributedString(string: "Password",
                                                           attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.6392156863, blue: 0.6666666667, alpha: 1)])
        self.viewDidLoadFunctions()
        
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

     viewWillApperFunctions()


    }


    func viewDidLoadFunctions(){
        assignDelegates()
        registerForKeyboardNotifications()
    }

    func viewWillApperFunctions(){

        self.navigationController?.navigationBar.isHidden = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.view.addGestureRecognizer(tapGesture)

        self.view.isUserInteractionEnabled = true


    }

    //MARK:- Functions
    
    func assignDelegates(){

        textfieldDelegate = TextFieldDelegate(view: self.view, source: "",role : "" , onCompletion: { tag in
        })

        keyBoardDelegate = KeyboardDelegate(scrollView: self.scrollView, activeField: self.emailTF , view : self.view , textView : UITextView(), scrollType : "")

        self.emailTF.delegate = textfieldDelegate
        self.passwordTF.delegate = textfieldDelegate

    }

    func registerForKeyboardNotifications() {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:- Actions
    
    @IBAction func loginBtnAction(_ sender: UIButton) {

       loginApi()

    }

    @IBAction func forgotPasswordBtnAction(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)


    }

    @IBAction func signUpBtnAction(_ sender: UIButton) {
        let vc:SignUpFirstStepVC = mainStoryBoard.instantiateViewController(withIdentifier:K_SignUp_First_Storyboard_Id) as! SignUpFirstStepVC
        self.navigationController?.pushViewController(vc, animated: true)
    }


    @objc func endEditing(){

        self.view.endEditing(true)

    }

    @objc func keyboardWasShown(notification: NSNotification){
        NotificationCenter.default.post(name: Notification.Name("KEYBOARDWILLSHOW"), object: nil , userInfo: notification.userInfo)

    }


    @objc func keyboardWillBeHidden(){
        NotificationCenter.default.post(name: Notification.Name("KEYBOARDWILLHIDE"), object: nil)
    }
    

    //MARK:- API call
  
    func loginApi() {

        let email:String = (emailTF.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let password:String = (passwordTF.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        self.view.endEditing(true)
        
        if email.isEmpty && password.isEmpty {

            Server.sharedInstance.showSnackBarAlert(desc: "Please fill in the email and password.")
            
        }  else  if  !Server.sharedInstance.isEmailValid(email:email) && password.isEmpty  {

            Server.sharedInstance.showSnackBarAlert(desc: "Enter a valid email address and please fill in the password.")
 
        } else  if  !Server.sharedInstance.isEmailValid(email:email) && password.count < 6  {
        
            Server.sharedInstance.showSnackBarAlert(desc: "Enter a valid email address and password is atleast 6 characters password.")
        
        } else if email.isEmpty {

             Server.sharedInstance.showSnackBarAlert(desc: "Please fill in the email.")
            
        } else  if  !Server.sharedInstance.isEmailValid(email:email) {

            Server.sharedInstance.showSnackBarAlert(desc: "Enter a valid email address.")
  
        }  else if password.isEmpty {

            Server.sharedInstance.showSnackBarAlert(desc: "Please fill in the password.")
    
        } else  if password.count  < 6{

            Server.sharedInstance.showSnackBarAlert(desc: "Enter atleast 6 character password.")
 
        } else {
            
            let params = ["user_email":email,"user_pass":password, "device_token": deviceToken, "device_type":"ios" ] as [String : Any]
       
            print(params)

            if Server.sharedInstance.isInternetAvailable()
            {
                Server.sharedInstance.showLoader()
                
                
                Alamofire.request(K_Base_Url+K_Login_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
                    .responseJSON { response in
                        
                        Server.sharedInstance.stopLoader()
                        
                        // check for errors
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling GET on /todos/1")
                            print(response.result.error!)
                            return
                        }
                        print(response.result.value)
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
                            
                            let userObj = Server.sharedInstance.getUserObject(dict: json["repsonse"] as! NSDictionary)
                            let userDefaults = UserDefaults.standard
                            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: userObj)
                            userDefaults.set(encodedData, forKey: DefaultsIdentifier.loggedInUserObject)
                            userDefaults.set(userObj.user_id, forKey:DefaultsIdentifier.loggedInUserID)
                            userDefaults.set(userObj.question_Id, forKey: DefaultsIdentifier.questionId)
                            userDefaults.set(userObj.security_question, forKey: DefaultsIdentifier.securityQuestion)
                            // userDefaults.set(password, forKey: DefaultsIdentifier.password)
                            userDefaults.set(userObj.name, forKey: DefaultsIdentifier.name)
                            userDefaults.set(userObj.phoneNumber, forKey: DefaultsIdentifier.phoneNumber)
                          userDefaults.set(userObj.email, forKey: DefaultsIdentifier.loggedInEmailID)
                          userDefaults.set(userObj.firstName, forKey: DefaultsIdentifier.firstName)
                            userDefaults.set(userObj.lastName, forKey: DefaultsIdentifier.lastName)
                            
                            userDefaults.synchronize()
                            
                            let loginStatus = userObj.loginStatus
                            
//                            if loginStatus == "1" {
//
//                                let vc =  UIStoryboard(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
//
//                                vc.helpBool = true
//                                self.present(vc, animated: true, completion: nil)
//
//                            }
                             if userObj.App_login == "0" {
                                
                                let vc =  UIStoryboard(name: "Main", bundle: nil) .instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
                                
                                vc.helpBool = true
                               // vc.appLogin = "0"
                                self.present(vc, animated: true, completion: nil)
                                
                                
                                // if loginStatus == "2"
                            } else {
                                
//                                let userObj = Server.sharedInstance.getUserObject(dict: json["repsonse"] as! NSDictionary)
//                                let userDefaults = UserDefaults.standard
//                                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: userObj)
//                                userDefaults.set(encodedData, forKey: DefaultsIdentifier.loggedInUserObject)
//                                userDefaults.set(userObj.user_id, forKey:DefaultsIdentifier.loggedInUserID)
                                userDefaults.set("login", forKey: DefaultsIdentifier.loggedIn)
//                                userDefaults.set(userObj.question_Id, forKey: DefaultsIdentifier.questionId)
//                                userDefaults.set(userObj.security_question, forKey: DefaultsIdentifier.securityQuestion)
                                userDefaults.set(password, forKey: DefaultsIdentifier.password)
                                userDefaults.synchronize()
                                
                                let vc:HomeVC = mainStoryBoard.instantiateViewController(withIdentifier:K_Home_Storyboard_Id) as! HomeVC
                                
                                let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuNavigation")
                                
                                let window = UIApplication.shared.delegate?.window
                                // window = UIWindow(frame: UIScreen.main.bounds)
                                window!!.rootViewController = SideMenuController(contentViewController: vc,
                                                                                 menuViewController: menuViewController)
                                Server.sharedInstance.showSnackBarAlert(desc:"Logged In Successfully.")
                                
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
    
    //MARK:- END
}
