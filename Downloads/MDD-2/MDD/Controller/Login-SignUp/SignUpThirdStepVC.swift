//
//  SignUpThirdStepVC.swift
//  MDD
//
//  Created by IOS3 on 17/05/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class SignUpThirdStepVC: UIViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var archery_top_cpnstraint: NSLayoutConstraint!
    @IBOutlet weak var your_email_lbl_top_constraint: NSLayoutConstraint!
    @IBOutlet weak var emailNameTF: UITextField!

    //MARK:- Variables
    var userObj = UserModel()
    var textfieldDelegate : TextFieldDelegate?
    var keyBoardDelegate : KeyboardDelegate?


    //MARK:- Object Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailNameTF.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                           attributes: [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5921568627, alpha: 1)])

        viewDidLoadFunctions()

    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.viewWillAppearFunctions()

    }

    //MARK:- Functions

    func viewDidLoadFunctions(){
        registerForKeyboardNotifications()
        assignDelegates()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.view.addGestureRecognizer(tapGesture)

        self.view.isUserInteractionEnabled = true
    }




    func viewWillAppearFunctions() {

        setupUI()

    }

    func setupUI(){

        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

    }


    func registerForKeyboardNotifications() {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    func assignDelegates(){

        textfieldDelegate = TextFieldDelegate(view: self.view, source: "",role : "" , onCompletion: { tag in
        })

        keyBoardDelegate = KeyboardDelegate(scrollView: self.scrollView, activeField: self.emailNameTF , view : self.view , textView : UITextView(), scrollType : "")

        self.emailNameTF.delegate = textfieldDelegate
      

    }


    @objc func keyboardWasShown(notification: NSNotification){
        NotificationCenter.default.post(name: Notification.Name("KEYBOARDWILLSHOW"), object: nil , userInfo: notification.userInfo)

    }


    @objc func keyboardWillBeHidden(){
        NotificationCenter.default.post(name: Notification.Name("KEYBOARDWILLHIDE"), object: nil)
    }
    
    
    //MARK:- Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func nextBtnAction(_ sender: Any) {
       self.goToFourthPage()
    }


    @IBAction func loginBtnAction(_ sender: Any) {
        let appdelegate =  UIApplication.shared.delegate as! AppDelegate
        let vc:LoginVC = mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let nav = UINavigationController(rootViewController: vc)
        appdelegate.window?.rootViewController = nav
    }


    @objc func endEditing(){

        self.view.endEditing(true)

    }


    func goToFourthPage(){
        self.view.endEditing(true)
        if (emailNameTF.text?.getTrimWhitespaceString().isEmpty)! {

             Server.sharedInstance.showSnackBarAlert(desc:"Email is required.")
            
            
        } else  if  !Server.sharedInstance.isEmailValid(email:(emailNameTF.text?.getTrimWhitespaceString())!) {

             Server.sharedInstance.showSnackBarAlert(desc:"Enter a valid email id.")
            
            
        }else{

            UserDefaults.standard.set("\(emailNameTF.text!)", forKey: "EMAIL")

            let vc:SignUpFourthStepVC = mainStoryBoard.instantiateViewController(withIdentifier:K_SignUp_Fourth_Storyboard_Id) as! SignUpFourthStepVC
            self.navigationController?.pushViewController(vc, animated: true)

        }
    }

    //MARK:- END

}
