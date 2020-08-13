//
//  MenuViewController.swift
//  SideMenuExample
//
//  Created by kukushi on 11/02/2018.
//  Copyright © 2018 kukushi. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import AVFoundation
import AVKit


class Preferences {
    static let shared = Preferences()
    var enableTransitionAnimation = false
}

class MenuViewController: UIViewController, updateNameDelegate {
    
    func updateName() {
        
        let userDefaults = UserDefaults.standard
        var firstName = String()
        var lastName = String()
        if (userDefaults.value(forKey: DefaultsIdentifier.firstName) != nil) {
            
            firstName = userDefaults.value(forKey: DefaultsIdentifier.firstName) as! String
            
        }
        
        if (userDefaults.value(forKey: DefaultsIdentifier.lastName) != nil) {
            
            lastName = userDefaults.value(forKey: DefaultsIdentifier.lastName) as! String
            
        }
        
        userName.text = firstName + " " + lastName
        
    }
    
    var isDarkModeEnabled = false
    var role = Int()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
            tableView.tableFooterView = UIView()

        }
    }
    
    @IBOutlet weak var selectionTableViewHeader: UILabel!
    @IBOutlet weak var selectionMenuTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var userName: UILabel!
    
    private var themeColor = UIColor.white
    
    var categoryArray = ["Hire MDD", "Profile", "Change Password", "Change Security Question", "Disclaimer","Take a Tour", "Logout"]
    var categoryImageArray = [UIImage(named: "hire"), UIImage(named: "profileIcon"), UIImage(named: "change-pass"), UIImage(named: "change-security"), UIImage(named: "disclaimer"), UIImage(named: "help"), UIImage(named: "logout")]
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        Server.sharedInstance.updateDelegate = self
        
        let userDefaults = UserDefaults.standard
        var firstName = String()
        var lastName = String()
        
        if (userDefaults.value(forKey: DefaultsIdentifier.firstName) != nil) {
            
            firstName = userDefaults.value(forKey: DefaultsIdentifier.firstName) as! String
            
        }
        
        if (userDefaults.value(forKey: DefaultsIdentifier.lastName) != nil) {
            
            lastName = userDefaults.value(forKey: DefaultsIdentifier.lastName) as! String
  
        }
        
        userName.text = firstName + " " + lastName
        
        isDarkModeEnabled = SideMenuController.preferences.basic.position == .under
        configureView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isDarkModeEnabled = SideMenuController.preferences.basic.position == .under
        configureView()
   
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "HireMDDViewController")
        }, with: "0")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController")
        }, with: "1")
        
        sideMenuController?.cache(viewControllerGenerator:{ self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController")
        }, with: "2")
 
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "ChangeSecurityInfoViewController")
        }, with: "3")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "DisclaimerViewController")
        }, with: "4")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "HelpViewController")
        }, with: "5")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
        }, with: "7")
        
      
        sideMenuController?.delegate = self
        tableView.reloadData()
        
    }

    private func configureView() {
        if isDarkModeEnabled {
            themeColor = UIColor(red: 0.03, green: 0.04, blue: 0.07, alpha: 1.00)
            selectionTableViewHeader.textColor = .white
        } else {
            selectionMenuTrailingConstraint.constant = 0 //0
            themeColor = UIColor(red: 0.98, green: 0.97, blue: 0.96, alpha: 1.00)
        }

        let sidemenuBasicConfiguration = SideMenuController.preferences.basic
        let showPlaceTableOnLeft = (sidemenuBasicConfiguration.position == .under) != (sidemenuBasicConfiguration.direction == .right)
        if showPlaceTableOnLeft {
          
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                selectionMenuTrailingConstraint.constant = SideMenuController.preferences.basic.menuWidth1 - view.frame.width
                
            }
            
            else {
                selectionMenuTrailingConstraint.constant = SideMenuController.preferences.basic.menuWidth - view.frame.width
                
            }
            
            print("**************", SideMenuController.preferences.basic.menuWidth - view.frame.width)
        }

    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let sidemenuBasicConfiguration = SideMenuController.preferences.basic
        let showPlaceTableOnLeft = (sidemenuBasicConfiguration.position == .under) != (sidemenuBasicConfiguration.direction == .right)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            selectionMenuTrailingConstraint.constant = showPlaceTableOnLeft ? SideMenuController.preferences.basic.menuWidth1 - size.width : 0
            
        }
        
       else {
        selectionMenuTrailingConstraint.constant = showPlaceTableOnLeft ? SideMenuController.preferences.basic.menuWidth - size.width : 0
        }
        
        view.layoutIfNeeded()
    }
}

extension MenuViewController: SideMenuControllerDelegate {
    func sideMenuController(_ sideMenuController: SideMenuController,
                            animationControllerFrom fromVC: UIViewController,
                            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BasicTransitionAnimator(options: .transitionFlipFromLeft, duration: 0.6)
    }

    func sideMenuController(_ sideMenuController: SideMenuController, willShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller will show [\(viewController)]")
    }

    func sideMenuController(_ sideMenuController: SideMenuController, didShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller did show [\(viewController)]")
    }

    func sideMenuWillHide(_ sideMenu: SideMenuController) {
        print("[Example] Menu will hide")
    }

    func sideMenuDidHide(_ sideMenu: SideMenuController) {
        print("[Example] Menu did hide.")
    }

    func sideMenuWillReveal(_ sideMenu: SideMenuController) {
        print("[Example] Menu will show.")
    }

    func sideMenuDidReveal(_ sideMenu: SideMenuController) {
        print("[Example] Menu did show.")
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      
            return categoryArray.count
     
        
        
    }

    // swiftlint:disable force_cast
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectionCell
        
        cell.contentView.backgroundColor = UIColor.init(alpha: 1.0, red: 35, green: 35, blue: 35) //themeColor
        cell.sideMenuCellImg.tintColor = #colorLiteral(red: 0.7130157351, green: 0.008198360913, blue: 0, alpha: 1)
        let row = indexPath.row
       
        cell.titleLabel?.text = categoryArray[row]
        cell.sideMenuCellImg.image = categoryImageArray[row]
        cell.titleLabel?.textColor =   UIColor.init(alpha: 1.0, red: 193, green: 193, blue: 193)
        //isDarkModeEnabled ? .white : .black
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row

        if row == 6 {
            
            
            let alertController = UIAlertController(title: "", message:"Are you sure you want to logout?", preferredStyle: .alert)
            
            // Create OK button
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                
                logout()
                
            }
            alertController.addAction(OKAction)
            
            // Create Cancel button
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel button tapped");
            }
            alertController.addAction(cancelAction)
            
            // Present Dialog message
            self.present(alertController, animated: true, completion:nil)
            
            
            sideMenuController?.hideMenu()
            
        }
        
        else {
            
            self.sideMenuController?.setContentViewController(with: "\(row)", animated: Preferences.shared.enableTransitionAnimation)
            self.sideMenuController?.hideMenu()
            
            if let identifier = self.sideMenuController?.currentCacheIdentifier() {
                print("[Example] View Controller Cache Identifier: \(identifier)")
  
            
        }
            
        }

        }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UIDevice.current.userInterfaceIdiom == .pad ? 95 : 75
      
    }

    
        
    }

   func logout() {

    let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.loggedInUserID)
    
    if userId is String  {
        
        let params = ["user_id":userId!, "device_token": deviceToken ] as [String: Any]
        print(params)
        
        if Server.sharedInstance.isInternetAvailable()
        {
            
            DispatchQueue.main.async {
                
                Server.sharedInstance.showLoader()
                
            }
            
            
            Alamofire.request(K_Base_Url+K_Logout_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
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
                        
                        let userDefaults = UserDefaults.standard
                        userDefaults.set("", forKey: DefaultsIdentifier.loggedInUserObject)
                        userDefaults.set("", forKey:DefaultsIdentifier.loggedInUserID)
                        userDefaults.set("", forKey: DefaultsIdentifier.loggedIn)
                        userDefaults.synchronize()
                        
                        let appdelegate = UIApplication.shared.delegate as! AppDelegate
                        let storyBoard = UIStoryboard(name:"Main", bundle: nil)
                        let vc:LoginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                        let nav = UINavigationController(rootViewController: vc)
                        appdelegate.window?.rootViewController = nav
                        Server.sharedInstance.showSnackBarAlert(desc:"Logout Successfully")
                        
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


class SelectionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sideMenuCellImg: UIImageView!
    
}
