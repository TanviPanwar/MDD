//
//  InstagramLoginViewController.swift
//  Richness
//
//  Created by Sobura on 7/6/18.
//  Copyright © 2018 Sobura. All rights reserved.
//

import Foundation
import UIKit

class InstagramLoginViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        signInRequest()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request:URLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        return checkRequestForCallbackURL(request: request)
    }
    
    func signInRequest() {
        
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [INSTAGRAM_API.INSTAGRAM_AUTHURL,INSTAGRAM_API.INSTAGRAM_CLIENT_ID,INSTAGRAM_API.INSTAGRAM_REDIRECT_URI, INSTAGRAM_API.INSTAGRAM_SCOPE])
        let urlRequest = URLRequest.init(url: URL.init(string: authURL)!)
        webView.loadRequest(urlRequest)
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(INSTAGRAM_API.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            getAuthToken(authToken: requestURLString.substring(from: range.upperBound))
            return false;
        }
        return true
    }
    func getAuthToken(authToken: String) {
        let url = String(format : "https://api.instagram.com/v1/users/self/?access_token=%@", authToken)
        let request : NSMutableURLRequest = NSMutableURLRequest(url : URL(string: url)!)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let session = URLSession(configuration : URLSessionConfiguration.default)
        
        session.dataTask(with: request as URLRequest){(data, response,error) -> Void in
            
            if let data = data{
                
                let json = try? JSONSerialization.jsonObject(with:  data, options: []) as! NSDictionary
                
                let strFullName = (json?.value(forKey: "data") as AnyObject).value(forKey: "full_name") as? String ?? ""
                let socialId = (json?.value(forKey: "data") as AnyObject).value(forKey: "id") as? String ?? ""
                let profile_picture = (json?.value(forKey: "data") as AnyObject).value(forKey: "profile_picture") as? String ?? ""
                
                print(strFullName)
                print(socialId)
                print(profile_picture)
                self.socialLogin(name: strFullName, id: socialId, profileImg: profile_picture)
            }
        }.resume()
    }
    
    func socialLogin(name : String, id : String, profileImg : String) {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        
        let params = [
            
            "referrer" : 3,
            "name" : name,
            "social_id" : id,
            "image" : profileImg,
            "key" : key,
            "bio" : "instagram"
            ] as [String : Any]
        print(params)
        
        RichnessAlamofire.POST(SOCIALLOGIN_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                
                print(responseObject)
                
                if (responseObject.object(forKey: "id") != nil) {
                    
                    var userid = responseObject["id"] as? String ?? ""
                    if userid == ""{
                        userid = String(describing: responseObject["id"] as? Int)
                    }
                    var ranking = responseObject["ranking"] as? String ?? ""
                    if ranking == ""{
                        ranking = String(describing: responseObject["ranking"] as? Int)
                    }
                    
                    RichnessUserDefault.setUserID(val: String(userid))
                    //                    RichnessUserDefault.setUserID(val: "123")
                    RichnessUserDefault.setFirstUser(val: true)
                    RichnessUserDefault.setUserRanking(val: ranking)
                    
                    let nextView = mainstoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                    let nav = UINavigationController(rootViewController: nextView)
                    self.present(nav, animated: true, completion: nil)
                }
                else{
                    let error = responseObject.object(forKey: "no_user") as? String
                    if (error == "#997") {
                        self.showError(errMsg: user_error_unknown)
                    }
                    else {
                        self.showError(errMsg: error_on_server)
                    }
                }
            }
            else
            {
                self.showError(errMsg: error_on_server)
            }
        }
    }
}
