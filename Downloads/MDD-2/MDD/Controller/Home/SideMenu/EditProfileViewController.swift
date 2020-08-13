//
//  EditProfileViewController.swift
//  MDD
//
//  Created by iOS6 on 05/11/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire



class EditProfileViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    
    @IBOutlet weak var globalRegBtn: UIButton!
    @IBOutlet weak var emeaRegBtn: UIButton!
    @IBOutlet weak var apacRegBtn: UIButton!
    @IBOutlet weak var usRegBtn: UIButton!
    @IBOutlet weak var latamRegBtn: UIButton!
    @IBOutlet weak var canadaRegBtn: UIButton!
    
    
    var regionArray = [String]()
    var btnTagvalue = Int()
    var globalBool = Bool()
    var emeaBool = Bool()
    var apacBool = Bool()
    var usBool = Bool()
    var latamBool = Bool()
    var canadaBool = Bool()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: DefaultsIdentifier.firstName) != nil) {
            
            firstNameTextField.text =  userDefaults.value(forKey: DefaultsIdentifier.firstName) as? String
            
        }
        
        if (userDefaults.value(forKey: DefaultsIdentifier.lastName) != nil) {
            
            lastNameTextField.text =  userDefaults.value(forKey: DefaultsIdentifier.lastName) as? String
            
        }
        
        if (userDefaults.value(forKey: DefaultsIdentifier.loggedInEmailID) != nil) {
            
            emailTextField.text =  userDefaults.value(forKey: DefaultsIdentifier.loggedInEmailID) as? String
            
        }
        
        getUserDetailApi()
        
    }
    
    func UpdateUI() {
        
        if regionArray.contains("GLOBAL") {
            
            globalRegBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            globalBool = true
        }
        if regionArray.contains("EMEA") {
            
            emeaRegBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            emeaBool = true
        }
        if regionArray.contains("APAC") {
            
            apacRegBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            apacBool = true
        }
        if regionArray.contains("US") {
            
            usRegBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            usBool = true
        }
        if regionArray.contains("LATAM") {
            
            latamRegBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            latamBool = true
        }
        if regionArray.contains("CANADA") {
            
            canadaRegBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            canadaBool = true
        }
        
    }
    
    // MARK:- IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        
        sideMenuController?.setContentViewController(with: "\(7)", animated: Preferences.shared.enableTransitionAnimation)
        
        sideMenuController?.hideMenu()
        
    }
    
    @IBAction func editProfileBtnAction(_ sender: Any) {
  
        firstNameTextField.isUserInteractionEnabled = true
        lastNameTextField.isUserInteractionEnabled = true
        globalRegBtn.isEnabled = true
        emeaRegBtn.isEnabled = true
        apacRegBtn.isEnabled = true
        usRegBtn.isEnabled = true
        latamRegBtn.isEnabled = true
        canadaRegBtn.isEnabled = true

        firstNameTextField.becomeFirstResponder()
        
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
    
    @IBAction func updateBtnAction(_ sender: Any) {
        
        updateProfileApi()
        
    }
   
    //MARK:-
    //MARK:- API Methods
    
    func getUserDetailApi() {
        
        var userId = String()
        
        let userDefaults = UserDefaults.standard

        
        if (userDefaults.value(forKey: DefaultsIdentifier.loggedInUserID) != nil) {
            
            userId =  userDefaults.value(forKey: DefaultsIdentifier.loggedInUserID) as! String
            
        }
        
        var parameters = [String: Any]()
        parameters = [ "user_id":userId]
        
        if Server.sharedInstance.isInternetAvailable()
        {
            Server.sharedInstance.showLoader()
            
            
            Alamofire.request(K_Base_Url + K_GetProfile_Url, method: .post,  parameters: parameters, encoding: URLEncoding.default, headers:nil)
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
                    let status = Server.sharedInstance.checkResponseForString(jsonKey:"status", dict: json as NSDictionary)
                    let msg = Server.sharedInstance.checkResponseForString(jsonKey:"message", dict: json as NSDictionary)
                    if status.boolValue {
                   
                        if let data = json["data"] as? [String: Any] {
                            
                          let objc =  Server.sharedInstance.GetProfileObjects(dict: data)
                            
                            self.regionArray = objc.regionArray
                            self.UpdateUI()
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
    
    func updateProfileApi() {
        
        let firstName:String = (firstNameTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let lastName:String = (lastNameTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
 
        var userId = String()
        
        let userDefaults = UserDefaults.standard

        
        if (userDefaults.value(forKey: DefaultsIdentifier.loggedInUserID) != nil) {
            
            userId =  userDefaults.value(forKey: DefaultsIdentifier.loggedInUserID) as! String
            
        }
        
        self.view.endEditing(true)
        
        if firstName.isEmpty {
            //            Server.sharedInstance.showAlertwithTitle(title:"", desc:"Please enter email", vc: self)
            Server.sharedInstance.showSnackBarAlert(desc:"Please enter first name.")
            
            
        } else if firstName.count < 3 {
            
            Server.sharedInstance.showSnackBarAlert(desc:"First name should be atleast 3 characters name.")
            
        } else if !(lastName.isEmpty) && lastName.count < 3 {
            
              Server.sharedInstance.showSnackBarAlert(desc:"last name should be atleast 3 characters name.")
            
        } else  if regionArray.count == 0 {
                   
             Server.sharedInstance.showSnackBarAlert(desc:"Select atleast one region of focus.")
         } else {
            
            let Str = regionArray.map { String($0) }
            .joined(separator: ",")
            let regionStr = Str.trimmingCharacters(in: CharacterSet.whitespaces)
            var parameters = [String: Any]()
            parameters = ["first_name": firstName, "last_name":lastName, "user_id":userId, "region":regionStr]
            
            if Server.sharedInstance.isInternetAvailable()
            {
                Server.sharedInstance.showLoader()
                
                
                Alamofire.request(K_Base_Url + K_EditProfile_Url, method: .post,  parameters: parameters, encoding: URLEncoding.default, headers:nil)
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
                            
                            userDefaults.set(firstName, forKey: DefaultsIdentifier.firstName)
                            userDefaults.set(lastName, forKey: DefaultsIdentifier.lastName)
                            userDefaults.synchronize()
                            
                            Server.sharedInstance.updateDelegate?.updateName()
                            Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                            self.sideMenuController?.setContentViewController(with: "\(7)", animated: Preferences.shared.enableTransitionAnimation)
                            
                            self.sideMenuController?.hideMenu()

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
