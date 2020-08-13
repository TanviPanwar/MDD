//
//  RecentTweetsViewController.swift
//  MDD
//
//  Created by iOS6 on 19/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
var islandscape =  false
class RecentTweetsViewController: UIViewController, WKNavigationDelegate  {
    //, WKNavigationDelegate
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var recentTweetTableView: UITableView!
    
    var obj = CategoryObjectModel()
    var contactObj = String()
    var contactBool = Bool()
    var newsFeedObj = String()
    var newsFeedBool = Bool()
    var weatherObj = String()
    var weatherBool = Bool()
    var popupObj = String()
    var popupBool = Bool()
    var popupTitle = String()
    var briefingObjc = String()
    var briefingBool = Bool()
    var tweetBool = Bool()
    var titleStr = String()
    var check = false
    var parentId = String()
    var childId = String()
    var catastropheid = String()
    var linkId = String()
    var weatherTitle = String()
    var homeBool = Bool()
    var homeObj = String()
    var covidSearchBool = Bool()
    var covidTitle = String()
    var covidLnk = String()


    

       
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        if Server.sharedInstance.isInternetAvailable()
        {
            
            webView.navigationDelegate = self
            var myURL: URL?
            
            
            
            if contactBool {
                
                myURL = URL(string:contactObj)
                titleLabel.text = "Contact Us"
                
            } else if newsFeedBool {
                
                myURL = URL(string:newsFeedObj)
                titleLabel.text = titleStr
                
            } else if weatherBool {
                
                myURL = URL(string:weatherObj)
                titleLabel.text = "Weather Links"
                
            } else if popupBool {
                
                myURL = URL(string:popupObj)
                titleLabel.text = popupTitle
                
            } else if briefingBool {
                
                myURL = URL(string:briefingObjc)
                titleLabel.text = "MDD Briefing"
                
            } else if homeBool {
                
                myURL = URL(string:homeObj)
                titleLabel.text = titleStr
                
            } else if covidSearchBool {
                
                print(covidLnk)
               let str = covidLnk.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                myURL = URL(string:str!)
               // print(myURL!)
                titleLabel.text = covidTitle
                
            } else {
                
                myURL = URL(string:"https://www.mdd.com/recent-tweets/?cat_id=\(obj.cat_id)")
                titleLabel.text = "Recent Tweets"
            }
            
            // myURL = URL(string:"https://test.mdd.com/recent-tweets/?cat_id=\(obj.cat_id)")
            if myURL == nil {

                Server.sharedInstance.showSnackBarAlert(desc:"No Link")


            }

            else {
                
                let myRequest = URLRequest(url: myURL!)
                webView.load(myRequest)
                
                
            }
            
        }
        
        else {
            
            DispatchQueue.main.async(execute: {
                
                Server.sharedInstance.showSnackBarAlert(desc:"Internet connection lost, please check your internet connection.")
                
            })
            
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           if check == false {
            if tweetBool || popupBool || weatherBool {
                DispatchQueue.main.async {
                    
                    self.saveStatusApi()
                    
                }
            }
           }
           
       }

    func webView(_ webView: WKWebView, didFinish navigation:
        WKNavigation!) {
        Server.sharedInstance.stopLoader()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation
        navigation: WKNavigation!) {
         Server.sharedInstance.showLoader()
    }
    
    func webView(_ webView: WKWebView, didFail navigation:
        WKNavigation!, withError error: Error) {
       Server.sharedInstance.stopLoader()
    }

    
    //MARK:-
    //MARK:- IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
      //MARK:-
      //MARK:- API Methods
      
      func saveStatusApi()
      {
 
          let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.loggedInUserID)
          
          if userId is String  {
            var params = [String: Any]()
            
            if popupBool {
                
                params = ["userid":userId!, "catastropheid": catastropheid, "parentcategoryid": parentId,"childcategoryid": childId, "linkid": linkId, "source":"ios"] as [String: Any]
                
            } else if weatherBool {
                
                params = ["userid":userId!, "catastropheid": obj.cat_id, "parentcategoryid": "Weather Links","linkid": weatherObj, "title": weatherTitle , "briefing": "1", "source":"ios"] as [String: Any]
            }
            
            else {
                
                params = ["userid":userId!, "catastropheid": obj.cat_id, "parentcategoryid": "Recent Tweets", "title":"", "linkid": "#links-3", "source":"ios", "briefing": "1"] as [String: Any]
            }

            print(params)
              
              if Server.sharedInstance.isInternetAvailable()
              {
     
                  Alamofire.request(K_Base_Url+K_SaveStatus_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
                      .responseJSON { response in
                          
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
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
    func reloadViewFromNib() {
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
    }
}
