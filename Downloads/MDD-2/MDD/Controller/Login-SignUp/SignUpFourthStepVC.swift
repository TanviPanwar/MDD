//
//  SignUpFourthStepVC.swift
//  MDD
//
//  Created by IOS3 on 17/05/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire

class SignUpFourthStepVC: UIViewController , UIPickerViewDelegate ,UIPickerViewDataSource {

    //MARK:- Outlets
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var archery_top_cpnstraint: NSLayoutConstraint!
    @IBOutlet weak var securityQuestion_lbl_top_constraint: NSLayoutConstraint!
    @IBOutlet weak var security_answer_height: NSLayoutConstraint!
    @IBOutlet weak var security_answer_view: UIView!
    @IBOutlet weak var answerTF: UITextField!
    @IBOutlet weak var security_question_btn_outlet: UIButton!
    @IBOutlet weak var loginLinkView: UIView!
    @IBOutlet weak var singupBtn: UIButton!
    

    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var regionTopConst: NSLayoutConstraint!
    @IBOutlet weak var regionHeightConst: NSLayoutConstraint!
    @IBOutlet weak var regionViewTopConst: NSLayoutConstraint!
    @IBOutlet weak var regionViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var securityTopConst: NSLayoutConstraint!
    
    @IBOutlet weak var securityViewTopConst: NSLayoutConstraint!
    @IBOutlet weak var regionView: UIView!
    @IBOutlet weak var globalRegBtn: UIButton!
    @IBOutlet weak var emeaRegBtn: UIButton!
    @IBOutlet weak var apacRegBtn: UIButton!
    @IBOutlet weak var usRegBtn: UIButton!
    @IBOutlet weak var latamRegBtn: UIButton!
    @IBOutlet weak var canadaRegBtn: UIButton!
    
    //MARK:- Variables
    var picker  = UIPickerView()
    var toolBar = UIToolbar()

    var userObj = UserModel()
    var secQuestionObj = [SecurityQuestionsModel]()
    var textfieldDelegate : TextFieldDelegate?
    var keyBoardDelegate : KeyboardDelegate?
    var f_name = ""
    var l_name = ""
    var phone_num = ""
    var email = ""
    var security_ques = ""
    var question_Id = ""
    var checkResetBool = Bool()
    var selectQuesId = String()
    var deepLinkCheck = Bool()
    var securityQuesSaved = String()
    var regionArray = [String]()
    var btnTagvalue = Int()
    var globalBool = Bool()
    var emeaBool = Bool()
    var apacBool = Bool()
    var usBool = Bool()
    var latamBool = Bool()
    var canadaBool = Bool()


    //MARK:- Object Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answerTF.attributedPlaceholder = NSAttributedString(string: "Security Answer",
                                                           attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.6392156863, blue: 0.6666666667, alpha: 1)])
        
        picker.delegate = self
        picker.dataSource = self
        
        //checkResetBool
        if deepLinkCheck {
            
            loginLinkView.isHidden = true
          //  backBtn.isHidden = true
            singupBtn.setTitle("Submit", for: .normal)
            
            DispatchQueue.main.async {
             
               // self.regionView.autoresizingMask = false
                self.regionTopConst.constant = 0
                self.regionHeightConst.constant = 0
                self.regionViewTopConst.constant = 0
                self.regionViewHeightConst .constant = 0
                self.regionLabel.isHidden = true
                self.regionView.isHidden = true
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    self.securityTopConst.constant = 90
                    
                } else {
                    
                    self.securityTopConst.constant = 60
                    
                }
//
                print(self.securityTopConst.constant)
                self.regionView.layoutIfNeeded()
                self.regionLabel.layoutIfNeeded()
            }
        }
        else {
            
            loginLinkView.isHidden = false
          //  backBtn.isHidden = false
            singupBtn.setTitle("Sign Up", for: .normal)

            if UIDevice.current.userInterfaceIdiom == .pad {
                
                regionHeightConst.constant = 56
                regionViewHeightConst .constant = 85
                self.securityTopConst.constant = 260

                
            } else {
                regionHeightConst.constant = 46
                regionViewHeightConst .constant = 75
                self.securityTopConst.constant = 209

                
            }
            
            regionTopConst.constant = 60
            regionViewTopConst.constant = 6

            regionLabel.isHidden = false
            regionView.isHidden = false
           // securityTopConst.constant = 22
         

            
        }

        viewDidLoadFunctions()

    }
    
    


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.viewWillAppearFunctions()

    }

    //MARK:- PickerView Delegate methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return secQuestionObj.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.text = secQuestionObj[row].question
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
    

    private func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: "some string", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        return attributedString
    }


    //MARK:- Functions

    func viewDidLoadFunctions(){
        assignDelegates()
        registerForKeyboardNotifications()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.view.addGestureRecognizer(tapGesture)
        self.view.isUserInteractionEnabled = true
    }


    func viewWillAppearFunctions() {

        getSecurityQuestionsList()
        setupUI()


        if UserDefaults.standard.string(forKey: "FNAME") != nil && UserDefaults.standard.string(forKey: "FNAME") != ""{
            self.f_name = UserDefaults.standard.string(forKey: "FNAME")!
        }

        if UserDefaults.standard.string(forKey: "LNAME") != nil && UserDefaults.standard.string(forKey: "LNAME") != ""{
            self.l_name = UserDefaults.standard.string(forKey: "LNAME")!
        }

        if UserDefaults.standard.string(forKey: "PHONENUM") != nil && UserDefaults.standard.string(forKey: "PHONENUM") != ""{
            self.phone_num = UserDefaults.standard.string(forKey: "PHONENUM")!
        }

        if UserDefaults.standard.string(forKey: "EMAIL") != nil && UserDefaults.standard.string(forKey: "EMAIL") != ""{
            self.email = UserDefaults.standard.string(forKey: "EMAIL")!
        }

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

        keyBoardDelegate = KeyboardDelegate(scrollView: self.scrollView, activeField: self.answerTF , view : self.view , textView : UITextView(), scrollType : "")

        self.answerTF.delegate = textfieldDelegate


    }
   
    //MARK:- Actions
   
    @IBAction func backBtnAction(_ sender: Any) {
        
        if deepLinkCheck {
            
            let vc:HomeVC = mainStoryBoard.instantiateViewController(withIdentifier:K_Home_Storyboard_Id) as! HomeVC
            
            let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuNavigation")
            
            let window = UIApplication.shared.delegate?.window
            window!!.rootViewController = SideMenuController(contentViewController: vc,
                                                             menuViewController: menuViewController)
        }
            
        else {
            
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func signUpBtnAction(_ sender: Any) {
        
        if deepLinkCheck {
            
            resetQuestionApi()
        }
        
        else {
            signupApi()
   
        }
  
    }


    @IBAction func seclectCountryBtnAction(_ sender: Any) {

        self.view.endEditing(true)

        picker = UIPickerView.init()
        picker.delegate = self
        picker.backgroundColor = UIColor.white

        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 200)
        self.view.addSubview(picker)

        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 50))
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onDoneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissPickerViews))

        if UIDevice.current.userInterfaceIdiom == .pad
        {

            picker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 400, width: picker.frame.size.width, height: 400)

            toolBar.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 400, width: UIScreen.main.bounds.size.width, height: 60)
            
            cancelButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)], for: .normal)
            doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)], for: .normal)

        }
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        self.toolBar.barTintColor = #colorLiteral(red: 0.9763852954, green: 0.9765252471, blue: 0.9763546586, alpha: 1)
        self.view.addSubview(toolBar)
        
    }

    @IBAction func loginBtnAction(_ sender: Any) {
        let appdelegate =  UIApplication.shared.delegate as! AppDelegate
        let vc:LoginVC = mainStoryBoard.instantiateViewController(withIdentifier:K_Login_Stroyboard_Id) as! LoginVC
        let nav = UINavigationController(rootViewController: vc)
        appdelegate.window?.rootViewController = nav
    }
    
    @IBAction func selectRegionBtnAction(_ sender: UIButton) {
        
        btnTagvalue = sender.tag
  
        if btnTagvalue == 1 && globalBool == false {
            
            globalRegBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            regionArray.append("GLOBAL")
            self.globalBool = true
          
        } else  if btnTagvalue == 1 && globalBool == true {
            
            globalRegBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            self.globalBool = false

            if regionArray.contains("GLOBAL") {
                
               let index = regionArray.index(of: "GLOBAL")
                regionArray.remove(at: index!)
            }

            
        }
        
        
        if btnTagvalue == 2 && emeaBool == false {
            
            emeaRegBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            regionArray.append("EMEA")
            self.emeaBool = true
          
        } else  if btnTagvalue == 2 &&  emeaBool == true {
            
            emeaRegBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            self.emeaBool = false
            if regionArray.contains("EMEA") {
                
               let index = regionArray.index(of: "EMEA")
                regionArray.remove(at: index!)
            }

            
        }
        
        if btnTagvalue == 3 && apacBool == false {
            
            apacRegBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            regionArray.append("APAC")
            self.apacBool = true
          
        } else  if btnTagvalue == 3 && apacBool == true {
            
            apacRegBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            self.apacBool = false
            if regionArray.contains("APAC") {
                
               let index = regionArray.index(of: "APAC")
                regionArray.remove(at: index!)
            }

            
        }
        
        if btnTagvalue == 4 && usBool == false {
            
            usRegBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            regionArray.append("US")
            self.usBool = true
          
        } else if btnTagvalue == 4 && usBool == true {
            
            usRegBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            self.usBool = false
            if regionArray.contains("US") {
                
               let index = regionArray.index(of: "US")
                regionArray.remove(at: index!)
            }

            
        }
        
        if btnTagvalue == 5 && latamBool == false {
            
            latamRegBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            regionArray.append("LATAM")
            self.latamBool = true
          
        } else if btnTagvalue == 5 && latamBool == true {
            
            latamRegBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            self.latamBool = false
            if regionArray.contains("LATAM") {
                
               let index = regionArray.index(of: "LATAM")
                regionArray.remove(at: index!)
            }

            
        }
        
        if btnTagvalue == 6 && canadaBool == false {
            
            canadaRegBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            regionArray.append("CANADA")
            self.canadaBool = true
          
        } else  if btnTagvalue == 6 && canadaBool == true {
            
            canadaRegBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            self.canadaBool = false
            if regionArray.contains("CANADA") {
                
               let index = regionArray.index(of: "CANADA")
                regionArray.remove(at: index!)
            }

            
        }
        
        print(regionArray)
        
    }
    

    
       //MARK:- Custom methods

    @objc func endEditing(){

        self.view.endEditing(true)

    }


    @objc func keyboardWasShown(notification: NSNotification){
        NotificationCenter.default.post(name: Notification.Name("KEYBOARDWILLSHOW"), object: nil , userInfo: notification.userInfo)

    }


    @objc func keyboardWillBeHidden(){
        NotificationCenter.default.post(name: Notification.Name("KEYBOARDWILLHIDE"), object: nil)
    }

    @objc func onDoneButtonTapped() {
        
        let row = picker.selectedRow(inComponent: 0)
        selectQuesId = secQuestionObj[row].id
        securityQuesSaved = secQuestionObj[row].question
        security_question_btn_outlet.setTitle(secQuestionObj[row].question, for: .normal)
        self.security_question_btn_outlet.setTitleColor(UIColor.white, for: .normal)
        dismissPickerViews()
    }


    @objc func dismissPickerViews(){
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }

    //MARK:- API calls
    func getSecurityQuestionsList(){
        
        if Server.sharedInstance.isInternetAvailable()
        {
            
            Server.sharedInstance.showLoader()
            
            Server.sharedInstance.getAPI(url: K_Base_Url + K_Security_Question_Url, completionHandler: {(responseDict, error) in
                
                Server.sharedInstance.stopLoader()
                if responseDict != nil {
                    let status = (responseDict!["success"] as! Bool?)!
                    let msg =  (responseDict!["message"] as! String?) ?? ""
                    if status  {
                        
                        self.security_question_btn_outlet.isEnabled = true
                        self.security_question_btn_outlet.isUserInteractionEnabled = true
                        let securityObj = Server.sharedInstance.getSecurityQuestionsList(array: responseDict!["repsonse"] as! NSArray)
                        
                        for ques in securityObj{
                            self.secQuestionObj.append(ques)
                        }
                        self.security_ques = securityObj[0].question
                        self.question_Id = self.secQuestionObj[0].id
                        
                        self.picker.reloadAllComponents()
                        
                    }else {
                        DispatchQueue.main.async {
                            self.security_question_btn_outlet.isEnabled = false
                            self.security_question_btn_outlet.isUserInteractionEnabled = false

                            Server.sharedInstance.showSnackBarAlert(desc:msg)
                        }
                    }
                } else {
                    
                    self.security_question_btn_outlet.isEnabled = false
                    self.security_question_btn_outlet.isUserInteractionEnabled = false
                    Server.sharedInstance.showSnackBarAlert(desc:"Server Error, An error occurred while processing your request.")
                }
            })
            
        }
            
        else {
            DispatchQueue.main.async(execute: {

                self.security_question_btn_outlet.isEnabled = false
                self.security_question_btn_outlet.isUserInteractionEnabled = false
                Server.sharedInstance.showSnackBarAlert(desc:"Internet Connection Lost,Check internet connection.")
                
            })
        }
    }



    func signUpAPI(){
        self.view.endEditing(true)
        if (answerTF.text!.getTrimWhitespaceString().isEmpty) {
            Server.sharedInstance.showAlertwithTitle(title:"", desc:"Question is required.", vc: self)
        }
        else {
            let params = ["fname":"abhi" ,"lname":"panwar" , "phoneNumber" : "9807896788" , "email" : "shivam123@gmail.com" , "security_q" : "\(security_ques)" , "security_answer" : "sunita"] as [String : AnyObject]

            Server.sharedInstance.showLoader()
            Server.sharedInstance.postAPI(url:K_Base_Url+K_Register_Url , params: params, completionHandler: { (responseDict, error) in
                Server.sharedInstance.stopLoader()
                print(responseDict)
                if responseDict != nil {
                    let status = Server.sharedInstance.checkResponseForString(jsonKey:"success", dict: responseDict!)
                    let msg = Server.sharedInstance.checkResponseForString(jsonKey:"message", dict: responseDict!)
                    if status.boolValue {

                        DispatchQueue.main.async {
                            Server.sharedInstance.showSnackBarAlert(desc:"Internet Connection Lost, Check internet connection")
                            let appdelegate =  UIApplication.shared.delegate as! AppDelegate
                            let vc:LoginVC = mainStoryBoard.instantiateViewController(withIdentifier: K_Login_Stroyboard_Id) as! LoginVC
                            let nav = UINavigationController(rootViewController: vc)
                            appdelegate.window?.rootViewController = nav
                            self.navigationController?.pushViewController(nav, animated: true)

                        
                        }

                    }
                    else {
                        DispatchQueue.main.async {
                            Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                        }

                    }

                }
                else {

                    Server.sharedInstance.showServerError(viewController:self)

                }

            })


        }
    }
    
    
    
    func signupApi()
    {
        
        self.view.endEditing(true)
        
        let ques = security_question_btn_outlet.currentTitle
        
        
        if regionArray.count == 0 {
            
              Server.sharedInstance.showSnackBarAlert(desc:"Select atleast one region of focus.")
        }
        
        else if (ques! == "--Please select security question--" ) && (answerTF.text!.getTrimWhitespaceString().isEmpty) {
            
            Server.sharedInstance.showSnackBarAlert(desc:"Question and answer is required.")

            
        }
            
        else if (ques! == "--Please select security question--" ) && (answerTF.text!.count < 3) {
            
            Server.sharedInstance.showSnackBarAlert(desc:"Question is required and answer should be atleast 3 characters name.")

            
        }
        
        else if (ques! == "--Please select security question--" ) {

            Server.sharedInstance.showSnackBarAlert(desc:"Question is required.")

            
        }
            
        else  if (answerTF.text!.getTrimWhitespaceString().isEmpty) {

            Server.sharedInstance.showSnackBarAlert(desc:"Answer is required.")

            
        }
            
        else  if (answerTF.text!.count < 3) {

            Server.sharedInstance.showSnackBarAlert(desc:"Answer should be atleast 3 characters name.")

            
        }
        else {
            
            let Str = regionArray.map { String($0) }
            .joined(separator: ",")
            let regionStr = Str.trimmingCharacters(in: CharacterSet.whitespaces)

            let params = ["fname":(f_name.getTrimWhitespaceString()) ,"lname":(l_name.getTrimWhitespaceString()) , "phoneNumber" : "\(phone_num.getTrimWhitespaceString())" , "email" : (email.getTrimWhitespaceString()) , "security_q" : selectQuesId , "security_answer" : "\(self.answerTF.text!.getTrimWhitespaceString())", "device_token": deviceToken, "device_type":"ios", "region":regionStr] as [String : Any]
            print(params)
        
            
            if Server.sharedInstance.isInternetAvailable()
            {
              Server.sharedInstance.showLoader()
                
                
                Alamofire.request(K_Base_Url+K_Register_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
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
    
    func resetQuestionApi()
    {
        
        self.view.endEditing(true)
        
        let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.loggedInUserID)
        
        if userId is String  {
        
        let ques = security_question_btn_outlet.currentTitle
        
        if (ques! == "--Please select Security Question--" ) && (answerTF.text!.getTrimWhitespaceString().isEmpty) {
            
            Server.sharedInstance.showSnackBarAlert(desc:"Question and answer is required.")
            
            
        }
            
        else if (ques! == "--Please select security question--" ) && (answerTF.text!.count < 3) {
            
            Server.sharedInstance.showSnackBarAlert(desc:"Question is required and answer should be atleast 3 characters name.")
            
            
        }
            
        else if (ques! == "--Please select security question--" ) {
            
            Server.sharedInstance.showSnackBarAlert(desc:"Question is required.")
            
            
        }
            
        else  if (answerTF.text!.getTrimWhitespaceString().isEmpty) {
            
            Server.sharedInstance.showSnackBarAlert(desc:"Answer is required.")
   
        }
            
        else  if (answerTF.text!.count < 3) {
            
            Server.sharedInstance.showSnackBarAlert(desc:"Answer should be atleast 3 characters name")
            
            
        }
        else {
            
            let params = ["user_id":userId!, "security_ques_id" :selectQuesId , "security_answer" : "\(self.answerTF.text!.getTrimWhitespaceString())"] as [String : Any]
            print(params)
            
            
            if Server.sharedInstance.isInternetAvailable()
            {
                Server.sharedInstance.showLoader()
                
                
                Alamofire.request(K_Base_Url+K_ResetSecurityQuestion_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
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
                            
                            DispatchQueue.main.async {
                                
                               let userDefaults = UserDefaults.standard
                                userDefaults.set(self.selectQuesId, forKey: DefaultsIdentifier.questionId)
                                userDefaults.set(self.securityQuesSaved, forKey: DefaultsIdentifier.securityQuestion)
                                userDefaults.synchronize()
                                
                                let vc:HomeVC = mainStoryBoard.instantiateViewController(withIdentifier:K_Home_Storyboard_Id) as! HomeVC
                                
                                let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuNavigation")
                                
                                let window = UIApplication.shared.delegate?.window
                                // window = UIWindow(frame: UIScreen.main.bounds)
                                window!!.rootViewController = SideMenuController(contentViewController: vc,
                                                                                 menuViewController: menuViewController)
                                
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
        
    }
        
        else {
                        
            Server.sharedInstance.showSnackBarAlert(desc:"UserId is empty.")
            
        }
        
}

    //MARK:- END

}
