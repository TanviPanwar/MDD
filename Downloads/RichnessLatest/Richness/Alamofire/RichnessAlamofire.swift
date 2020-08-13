//
//  QuickServeAlamofire.swift
//  QuickSereve
//
//  Created by Sobura on 1/27/18.
//  Copyright © 2018 Sobura. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import MBProgressHUD
import NVActivityIndicatorView
import SCLAlertView

var spiningActivity:MBProgressHUD?=nil

var loadingView:UIView = UIView()
var loadingAcitivity:NVActivityIndicatorView?=nil
var curviewcontroller:UIViewController?=nil
let KEYWINDOW = UIApplication.shared.keyWindow

class RichnessAlamofire: SessionManager {
    
    struct Static {
        static var instance: RichnessAlamofire? = nil
        static var token: Int = 0
    }
    
    private static var __once: () = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60.0
        configuration.timeoutIntervalForResource = 60.0
        let manager = RichnessAlamofire(configuration: configuration)
        Static.instance = manager
        
    }()
    
    static var spiningShowed:Bool = false
    
    class var shareInstance: RichnessAlamofire {
        get {
            
            _ = RichnessAlamofire.__once
            return Static.instance!
        }
    }
    
    class  func POST(_ url: String, parameters: [String: AnyObject],showLoading:Bool,showSuccess:Bool,showError:Bool, completionHandler: @escaping
        (_ result:Bool,_ responseObject:NSDictionary) -> Void) -> Request {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        if showLoading {
            showIndicator()
        }
        
        return RichnessAlamofire.shareInstance.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).validate().responseJSON{ response in
            
            switch response.result {
            case .success(let JSON):
                
                let res = JSON as! NSDictionary
                hideIndicator()
                completionHandler(true, res)
                
            case .failure(let error):
                print(error.localizedDescription)
                hideIndicator()
                completionHandler( false,[:])
                
            }
            hideIndicator()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    class  func notificatonPost(_ url: String, parameters: [String: AnyObject],showLoading:Bool,showSuccess:Bool,showError:Bool, completionHandler: @escaping
        (_ result:Bool,_ responseObject:NSDictionary) -> Void) -> Request {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
     
        
        return RichnessAlamofire.shareInstance.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).validate().responseJSON{ response in
            
            switch response.result {
            case .success(let JSON):
                
                let res = JSON as! NSDictionary
            
                completionHandler(true, res)
                
            case .failure(let error):
                print(error.localizedDescription)
               
                completionHandler( false,[:])
                
            }
           
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    class func displaySuccess(_ message:String){
        // Display an alert message
        let myAlert = UIAlertController(title: "Success", message:message, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction);
        UIApplication.topViewController()?.present(myAlert, animated: true, completion: nil)
    }
    
    class func displayError(_ message:String){
        // Display an alert message
        let myAlert = UIAlertController(title: "Error", message:message, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction);
        UIApplication.topViewController()?.present(myAlert, animated: true, completion: nil)
    }
    
    class func displayCaution(_ message:String){
        // Display an alert message
        let myAlert = UIAlertController(title: "Caution", message:message, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
        myAlert.addAction(okAction);
        UIApplication.topViewController()?.present(myAlert, animated: true, completion: nil)
    }
    
    class  func showIndicator(_ vc:UIViewController)
    {
        curviewcontroller = vc
        
        let curframe = curviewcontroller?.view.frame
        
        loadingView = UIView(frame: (curviewcontroller?.view.frame)!)
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        loadingAcitivity = NVActivityIndicatorView(frame: CGRect(x: (curframe?.width)!/2 - 30, y: (curframe?.height)!/2-30, width: 60, height: 60), type: .ballScale, color: self.UIColorFromHex(0xEC644B), padding: CGFloat(0))
        loadingAcitivity!.startAnimating()
        loadingView.addSubview(loadingAcitivity!)
        
        vc.view.isUserInteractionEnabled = false
        
        if loadingView.superview == nil{
            vc.view.addSubview(loadingView)
        }
    }
    
    
    class  func showIndicator() {
        print(UIApplication.topViewController(), UIApplication.topViewController()?.view.frame)
        
        curviewcontroller = UIApplication.topViewController()
        let curframe = CGRect(x:0, y: 0, width: UIScreen.main.bounds.size.width, height:  UIScreen.main.bounds.size.height)
      
        loadingView = UIView(frame: curframe)
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        loadingAcitivity = NVActivityIndicatorView(frame: CGRect(x: (curframe.width)/2 - 30, y: (UIApplication.topViewController()?.view.frame.height)!/2-30, width: 60, height: 60), type: .ballClipRotate, color: self.UIColorFromHex(0xFFFFFF), padding: CGFloat(0))
        loadingAcitivity!.startAnimating()
        loadingView.addSubview(loadingAcitivity!)
        
        KEYWINDOW?.isUserInteractionEnabled = false
        
        if loadingView.superview == nil{
            UIApplication.topViewController()?.view.addSubview(loadingView)
        }
    }
    
    class func UIColorFromHex(_ rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    class func hideIndicator(){
        if loadingView.superview != nil{
            loadingAcitivity!.stopAnimating()
            KEYWINDOW?.isUserInteractionEnabled = true
            loadingView.removeFromSuperview()
        }
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

