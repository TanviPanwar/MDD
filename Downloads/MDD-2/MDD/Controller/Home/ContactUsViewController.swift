//
//  ContactUsViewController.swift
//  MDD
//
//  Created by iOS6 on 19/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import Contacts


class ContactUsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var titileLabel: UILabel!
    
    var obj = CategoryObjectModel()
    var contactArray = [ContactObjectModel]()
    var check = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //contactDetailApi()
        
        titileLabel.text = "Contact a member of our \(obj.cat_name) CAT 365 Team"
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if check == false {
            contactDetailApi()
        }
        
    }
    
    //MARK:-
    //MARK:- IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)

    }
    
    //MARK:-
    //MARK:- TableView DataSources
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return contactArray.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ContactUsTableViewCell", for: indexPath) as! ContactUsTableViewCell
        
        cell.memberNameLabel.text = contactArray[indexPath.row].title
         cell.partnerLabel.text = contactArray[indexPath.row].designations
         cell.memberTelePhoneLabel.text = contactArray[indexPath.row].phone_number
         cell.memberFLabel.text = contactArray[indexPath.row].fax_number
         cell.memberEmailLabel.text = contactArray[indexPath.row].email_address
        cell.memberImageView.sd_setImage(with: URL(string : contactArray[indexPath.row].image_url), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
            
        }
        
       
        cell.onMoreInfoButtonTapped = {
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecentTweetsViewController") as! RecentTweetsViewController
            
            vc.contactObj = self.contactArray[indexPath.row].more_info
            vc.contactBool = true
            self.present(vc, animated: true, completion: nil)
            
            
        }
        
        cell.onDownloadVcareButtonTapped = {
            
           
            DispatchQueue.main.async {
                self.saveStatusApi(title: self.contactArray[indexPath.row].title, link: self.contactArray[indexPath.row].vcard_link)
                           
                Server.sharedInstance.showLoader()

            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                
                do {
                    
                    let url = URL(string: self.contactArray[indexPath.row].vcard_link)
                    let data = try Data(contentsOf: url!)
                    self.saveVCardContacts(vCard: data)
                } catch {
                    print(error)
                    Server.sharedInstance.stopLoader()
                    Server.sharedInstance.showSnackBarAlert(desc: error.localizedDescription)
                    // return nil
                }
               
            })
  
        }
        
        
        return cell
    }
    
    
    //MARK:-
    //MARK:- API Methods
    
    func contactDetailApi()
    {
        
        
        let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.loggedInUserID)
        
        if userId is String  {
            
            let params = ["user_id":userId!, "cat_id": obj.cat_id] as [String: Any]
            print(params)
            
            if Server.sharedInstance.isInternetAvailable()
            {
                
                DispatchQueue.main.async {
                    
                    Server.sharedInstance.showLoader()
                    
                }
                
                
                Alamofire.request(K_Base_Url+K_ContactUs_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
                    .responseJSON { response in
                        
                        Server.sharedInstance.stopLoader()
                        self.check = true
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
                        let status = Server.sharedInstance.checkResponseForString(jsonKey:"success", dict: json as NSDictionary)
                        let msg = Server.sharedInstance.checkResponseForString(jsonKey:"message", dict: json as NSDictionary)
                        if status.boolValue {

                            if let response = json["repsonse"] as? NSArray , response.count > 0 {
                                
                                self.msgLabel.isHidden = true
                                let responseArray = Server.sharedInstance.GetContactListObjects(array: response)
                                
                               self.contactArray.append(contentsOf: responseArray)
                               
                                self.contactTableView.reloadData()
                            }
                            
                            
                        }
                        else {
                            
                            DispatchQueue.main.async {
                                
                                self.msgLabel.isHidden = false
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
    
    func saveStatusApi(title: String, link: String)
    {
        
        
        let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.loggedInUserID)
        
        if userId is String  {
            
            let params = ["userid":userId!, "catastropheid": obj.cat_id, "parentcategoryid": "Contact US", "title":title, "linkid": link, "source":"ios", "briefing": "1"] as [String: Any]
            print(params)
            
            if Server.sharedInstance.isInternetAvailable()
            {
           
                
                Alamofire.request(K_Base_Url+K_SaveStatus_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
                    .responseJSON { response in
                        
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
                        let status = Server.sharedInstance.checkResponseForString(jsonKey:"status", dict: json as NSDictionary)
                        let msg = Server.sharedInstance.checkResponseForString(jsonKey:"message", dict: json as NSDictionary)
                        if status == "success" {
                            
                        }
                        else {
                            
                        }
                }
                
            }
                
            else {
                DispatchQueue.main.async(execute: {
                    
                    Server.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
                })
            }
            
            
        } else {
            
            //              Server.sharedInstance.showAlertwithTitle(title:"", desc: "UserId is Empty", vc:UIApplication.topViewController()!)
            
        }
    }
    
    
    func saveVCardContacts (vCard : Data) { // assuming you have alreade permission to acces contacts
 
        if #available(iOS 9.0, *) {
            
            let contactStore = CNContactStore()
            
            do {
                
                let saveRequest = CNSaveRequest() // create saveRequests
                
                let contacts = try CNContactVCardSerialization.contacts(with: vCard) // get contacts array from vCard
                
//                for person in contacts{
//
//                    saveRequest.add(person as! CNMutableContact, toContainerWithIdentifier: nil) // add contacts to saveRequest
//
//
//
//                }
                
                var mutablePerson: CNMutableContact
                for person in contacts {
                    mutablePerson = person.mutableCopy() as! CNMutableContact
                    saveRequest.add(mutablePerson, toContainerWithIdentifier: nil)
                }
                
                try contactStore.execute(saveRequest) // save to contacts
                
                Server.sharedInstance.stopLoader()
                Server.sharedInstance.showSnackBarAlert(desc: "Contact saved successfully.")

                
            } catch  {
                
                Server.sharedInstance.stopLoader()
                Server.sharedInstance.showSnackBarAlert(desc: "Unable to show the new contact.")

                print("Unable to show the new contact") // something went wrong
                
            }
            
        }else{
            
            
            Server.sharedInstance.stopLoader()
            Server.sharedInstance.showSnackBarAlert(desc: "Contact not supported.")

            print("CNContact not supported.") //
            
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
