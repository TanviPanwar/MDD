//
//  HelpViewController.swift
//  MDD
//
//  Created by iOS6 on 30/10/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import WebKit


class HelpViewController: UIViewController,WKNavigationDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    
    var helpBool =  Bool()
    var appLogin = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        // Do any additional setup after loading the view.
        
        if helpBool {
            
            backBtn.isHidden = false
            skipBtn.isHidden = false

        } else {
            
            backBtn.isHidden = false
            skipBtn.isHidden = true

        }
        
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear
        let url = Bundle.main.url(forResource: "SCREEN-ANIMATION2", withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webView.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: NSURL() as URL)
      //  webView.contentMode = .scaleAspectFit
        webView.scrollView.isScrollEnabled = false

    }
    
    // MARK:- IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        if helpBool {
            
            self.dismiss(animated: true, completion: nil)
            
        } else {
        
        sideMenuController?.setContentViewController(with: "\(7)", animated: Preferences.shared.enableTransitionAnimation)
        
        sideMenuController?.hideMenu()
            
        }
        
    }
    
    @IBAction func skipBtnAction(_ sender: Any) {
        
        
        
       // if appLogin == "0" {
            
            let userDefaults = UserDefaults.standard

            userDefaults.set("login", forKey: DefaultsIdentifier.loggedIn)
            userDefaults.synchronize()
            
            let vc:HomeVC = mainStoryBoard.instantiateViewController(withIdentifier:K_Home_Storyboard_Id) as! HomeVC
            
            let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuNavigation")
            
            let window = UIApplication.shared.delegate?.window
            window!!.rootViewController = SideMenuController(contentViewController: vc,
                                                             menuViewController: menuViewController)
            Server.sharedInstance.showSnackBarAlert(desc:"Logged In Successfully.")
        
    }
    
    // MARK:- WebView Delegates
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.evaluateJavaScript("document. body.style.zoom = 0.75;") { (result, error) in
            
            let css = "img { height: 100%; vertical-align: center;}"
            
            let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
            
            self.webView.evaluateJavaScript(js, completionHandler: nil)
            
        }
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
