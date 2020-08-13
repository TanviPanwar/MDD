//
//  SignUpFirstStepVC.swift
//  MDD
//
//  Created by IOS3 on 17/05/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class SignUpFirstStepVC: UIViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var archery_top_cpnstraint: NSLayoutConstraint!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var your_name_lbl_top_constraint: NSLayoutConstraint!


    //MARK:- Variables
    var userObj = UserModel()
    var textfieldDelegate : TextFieldDelegate?
    var keyBoardDelegate : KeyboardDelegate?


    //MARK:- Object Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTF.attributedPlaceholder = NSAttributedString(string: "First Name",
                                                           attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.6392156863, blue: 0.6666666667, alpha: 1)])
        
        lastNameTF.attributedPlaceholder = NSAttributedString(string: "Last Name",
                                                              attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.6392156863, blue: 0.6666666667, alpha: 1)])

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

        self.archery_top_cpnstraint.constant =  UIScreen.main.bounds.height/10
        self.your_name_lbl_top_constraint.constant =  UIScreen.main.bounds.height/15

    }


    func registerForKeyboardNotifications() {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    func assignDelegates(){

        textfieldDelegate = TextFieldDelegate(view: self.view, source: "",role : "" , onCompletion: { tag in
        })

        keyBoardDelegate = KeyboardDelegate(scrollView: self.scrollView, activeField: self.firstNameTF , view : self.view , textView : UITextView(), scrollType : "")

        self.firstNameTF.delegate = textfieldDelegate
        self.lastNameTF.delegate = textfieldDelegate

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
       self.goToSecondPage()
    }


    @IBAction func loginBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }


    @objc func endEditing(){

        self.view.endEditing(true)

    }


    func goToSecondPage(){
        self.view.endEditing(true)
        
        if (firstNameTF.text?.getTrimWhitespaceString().isEmpty)! {

            Server.sharedInstance.showSnackBarAlert(desc:"First name is required.")
    
        }
        else if ((firstNameTF.text?.count)! < 3) {

            Server.sharedInstance.showSnackBarAlert(desc:"First name should be atleast 3 characters name.")
 
        }
            
        else if !(lastNameTF.text?.getTrimWhitespaceString().isEmpty)! &&  ((lastNameTF.text?.count)! < 3) {
            
             Server.sharedInstance.showSnackBarAlert(desc:"Last name should be atleast 3 characters name.")
            
        } else {
            UserDefaults.standard.set("\(firstNameTF.text!)", forKey: "FNAME")
            UserDefaults.standard.set("\(lastNameTF.text!)", forKey: "LNAME")

            let vc:SignUpSecondStepVC = mainStoryBoard.instantiateViewController(withIdentifier:K_SignUp_Second_Storyboard_Id) as! SignUpSecondStepVC
            self.navigationController?.pushViewController(vc, animated: true)

        }
        
    }
    //MARK:- END
}
