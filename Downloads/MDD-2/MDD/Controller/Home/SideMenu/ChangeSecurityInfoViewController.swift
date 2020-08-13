//
//  ChangeSecurityInfoViewController.swift
//  MDD
//
//  Created by iOS6 on 26/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import  Alamofire

class ChangeSecurityInfoViewController: UIViewController {
    
    @IBOutlet weak var changeSecurityQuesBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        sideMenuController?.setContentViewController(with: "\(7)", animated: Preferences.shared.enableTransitionAnimation)
        
        sideMenuController?.hideMenu()
    }
    
    @IBAction func changeSecurityQuesBtnAction(_ sender: Any) {
        
        changeSecurityQuestionApi()
        
    }

    //MARK:-
    //MARK:- API Methods
    
    func changeSecurityQuestionApi()
    {
        
        let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.loggedInUserID)
        
        if userId is String  {
            
            let params = ["user_id":userId!] as [String: Any]
            print(params)
            
            if Server.sharedInstance.isInternetAvailable()
            {
                
                DispatchQueue.main.async {
                    
                    Server.sharedInstance.showLoader()
                    
                }
                
                
                Alamofire.request(K_Base_Url+K_ChangeSecurityQuestion_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
                    .responseJSON { response in
                        
                        Server.sharedInstance.stopLoader()
                        
                        // check for errors
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling GET on /todos/1")
                            print(response.result.error!)
                            return
                        }
                        print(response.result.value!)
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
                            
                            Server.sharedInstance.showSnackBarAlert(desc: msg as String)

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
            
        else {
          
            Server.sharedInstance.showSnackBarAlert(desc:"UserId is empty.")
            
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
