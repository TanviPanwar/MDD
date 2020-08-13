//
//  SignUpSecondStepVC.swift
//  MDD
//
//  Created by IOS3 on 17/05/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class SignUpSecondStepVC: UIViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var archery_top_cpnstraint: NSLayoutConstraint!
    @IBOutlet weak var your_phone_lbl_top_constraint: NSLayoutConstraint!
    @IBOutlet weak var phoneTF: UITextField!
 
    //MARK:- Variables
    var userObj = UserModel()
    var textfieldDelegate : TextFieldDelegate?
    var keyBoardDelegate : KeyboardDelegate?


    //MARK:- Object Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneTF.attributedPlaceholder = NSAttributedString(string: "Phone Number",
                                                           attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6470588235, green: 0.6431372549, blue: 0.6431372549, alpha: 1)])


        self.viewDidLoadFunctions()

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

        keyBoardDelegate = KeyboardDelegate(scrollView: self.scrollView, activeField: self.phoneTF , view : self.view , textView : UITextView(), scrollType : "")

        self.phoneTF.delegate = textfieldDelegate
      

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

        goToThirdPage()

    }


    @IBAction func loginBtnAction(_ sender: Any) {
        let appdelegate =  UIApplication.shared.delegate as! AppDelegate
        let vc:LoginVC = mainStoryBoard.instantiateViewController(withIdentifier: K_Login_Stroyboard_Id) as! LoginVC
        let nav = UINavigationController(rootViewController: vc)
        appdelegate.window?.rootViewController = nav
    }


    @objc func endEditing(){

        self.view.endEditing(true)

    }

    func goToThirdPage(){
        self.view.endEditing(true)
  
        if !((phoneTF.text?.getTrimWhitespaceString().isEmpty)!) && (phoneTF.text?.count)! < 8  {
          
                            Server.sharedInstance.showSnackBarAlert(desc:"Phone number should be atleast 8 characters number.")
            
    }
            
      else {
            UserDefaults.standard.set("\(phoneTF.text!)", forKey: "PHONENUM")


            let vc:SignUpThirdStepVC = mainStoryBoard.instantiateViewController(withIdentifier:K_SignUp_Third_Storyboard_Id) as! SignUpThirdStepVC
            self.navigationController?.pushViewController(vc, animated: true)

      }
    }
    //MARK:- END

}
