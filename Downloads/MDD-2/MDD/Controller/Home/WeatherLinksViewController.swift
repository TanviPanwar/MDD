//
//  WeatherLinksViewController.swift
//  MDD
//
//  Created by iOS6 on 02/08/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire

class WeatherLinksViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource {
    
    //MARK:- Outlets
    @IBOutlet var weatherLinkTableView: UITableView!
    @IBOutlet weak var msgLabel: UILabel!
    
    var objc = CategoryObjectModel()
    var weatherLinkArray = [CategoryObjectModel]()
    var check = false

    
    
    //MARK:- Object Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if check == false {
            weatherLinkApi()
        }
        
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
 
    //MARK:- TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherLinkArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? CGFloat(200) : CGFloat(118)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedsTableViewCell", for: indexPath) as! NewsFeedsTableViewCell
        cell.borderView.layer.borderColor = UIColor.lightGray.cgColor
        cell.borderView.layer.borderWidth = 0.8
        cell.borderView.layer.cornerRadius = 4
        cell.borderView.clipsToBounds = true
        
        cell.newsChannelTitleLbl.text = weatherLinkArray[indexPath.row].title
        cell.newsLbl.text = weatherLinkArray[indexPath.row].descriptionText
        cell.newsBottomLbl.text = weatherLinkArray[indexPath.row].link_text
        
        cell.feedImageView.sd_setImage(with: URL(string : weatherLinkArray[indexPath.row].image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let str =  self.weatherLinkArray[indexPath.row].link_url
        if str == "#" {
            
            Server.sharedInstance.showSnackBarAlert(desc: "No weather link found")
            
        } else {

            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecentTweetsViewController") as! RecentTweetsViewController
            
            vc.weatherObj = self.weatherLinkArray[indexPath.row].link_url
            vc.weatherTitle = self.weatherLinkArray[indexPath.row].title
            vc.obj = objc
            vc.weatherBool = true
            self.present(vc, animated: true, completion: nil)
        
    }
        
      
    }
 
    //MARK:-
    //MARK:- API Methods
    
    func weatherLinkApi()
    {
        
        let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.loggedInUserID)
        
        if userId is String  {
            
            let params = ["user_id":userId!, "cat_id": objc.cat_id, "source": "ios"] as [String: Any]
            print(params)
            
            if Server.sharedInstance.isInternetAvailable()
            {
                
                DispatchQueue.main.async {
                    
                    Server.sharedInstance.showLoader()
                    
                }
                
                
                Alamofire.request(K_Base_Url+K_WeatherLink_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
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
                                let responseArray = Server.sharedInstance.GetNewsFeedListObjects(array: response)
                                
                                self.weatherLinkArray.append(contentsOf: responseArray)
                                
                                self.weatherLinkTableView.reloadData()
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
    
}
