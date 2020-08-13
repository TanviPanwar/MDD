//
//  MDDBriefingViewController.swift
//  MDD
//
//  Created by iOS6 on 10/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import PopupDialog


class MDDBriefingViewController: UIViewController {
    
    @IBOutlet weak var viewBtn: UIButton!
    
    var obj = CategoryObjectModel()
    var pdfLink = String()
    var check = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 2)
        self.viewBtn.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if check == false {
           mddBriefingApi()
        }
        
    }
    
    
    //Mark:-
    //MARK:- IB Actions
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func viewBtnAction(_ sender: Any) {
        
        
        downloadFileFromURL()
    }
    
    //MARK:-
    //MARK:- API Methods
    
    func mddBriefingApi()
    {
        
        
        let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.loggedInUserID)
        
        if userId is String  {
            
            let params = ["user_id":userId!, "cat_id": obj.cat_id] as [String: Any]
            print(params)
            
            if Server.sharedInstance.isInternetAvailable()
            {
  
                DispatchQueue.main.async {
  
                    Server.sharedInstance.showNewLoader(vc: self)
                    
                }
   
                Alamofire.request(K_Base_Url+K_MddBriefing_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
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
                        // let status = json["status"] as? Int
                        let status = Server.sharedInstance.checkResponseForString(jsonKey:"success", dict: json as NSDictionary)
                        let msg = Server.sharedInstance.checkResponseForString(jsonKey:"message", dict: json as NSDictionary)
                        if status.boolValue {
                            
                            
                            if let response = json["repsonse"] as? [String: Any]  {
                                
                                let desc = response["description"] as? String
                                self.pdfLink = (response["pdf_link"] as? String)!
                                
                                
                                if self.pdfLink == "" {
                                    
                                    self.viewBtn.isHidden = true
                                    
                                }
                                    
                                else {
                                    self.viewBtn.isHidden = false
                                    
                                }
                            }
                            
                            
                        }
                        else {
                            
                            DispatchQueue.main.async {
                                Server.sharedInstance.showAlertwithTitle(title:"", desc:msg as String, vc: self)
                                
                            }
                        }
                }
                
            }
                
            else {
                DispatchQueue.main.async(execute: {

                    Server.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
                })
            }
            
            
        }
            
            
        else {
            
            Server.sharedInstance.showAlertwithTitle(title:"", desc: "UserId is Empty", vc:UIApplication.topViewController()!)
   
        }
    }
    
    func downloadFileFromURL()  {
        
  
        if Server.sharedInstance.isInternetAvailable() {
            
            self.downloadPopup()
           
            Server.sharedInstance.showLoader()
                let fileUrl =  pdfLink // /\(obj.UserID)
                Alamofire.request(fileUrl, headers:nil).downloadProgress { (progress) in
                    NotificationCenter.default.post(name:.downloadProgress, object:progress )
                    print(progress.fractionCompleted , progress.fileTotalCount , progress.fileCompletedCount , progress.totalUnitCount )
                    }.responseData { (data) in
                        Server.sharedInstance.stopLoader()

                        if let contentType = data.response?.allHeaderFields["Content-Type"] as? String {
                            print("contentType ***** \(contentType)")
                            
                          
                                let filePath = self.documentsPathForFileName(name: "\(Date().ticks)" + "MddBriefing.pdf")
                            
                                do {
                                    
                                    try data.data?.write(to:filePath!)
                                    
                                }
                                catch {
                                    
                                    
                                }
   
                        }
                        
                }
            
        }
        else {
            Server.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
            
        }
        
    }
    
    func documentsPathForFileName(name: String) -> URL? {
        let fileMgr = FileManager.default
        
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        let fileURL = dirPaths[0].appendingPathComponent(name)
        return fileURL
    }
    func downloadPopup() {
        
        let alertVC :DownloadingPopup = (self.storyboard?.instantiateViewController(withIdentifier: "DownloadingPopup") as? DownloadingPopup)!
        let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
        ,tapGestureDismissal: false, panGestureDismissal: false) {
            let overlayAppearance = PopupDialogOverlayView.appearance()
            overlayAppearance.blurRadius  = 30
            overlayAppearance.blurEnabled = true
            overlayAppearance.liveBlur    = false
            overlayAppearance.opacity     = 0.4
        }
        UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
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
