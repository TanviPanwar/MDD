//
//  NotificationViewController.swift
//  Richness
//
//  Created by IOS3 on 13/02/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import Foundation
import UIKit
//import PullToRefresh
import SDWebImage
import Player
import  IQKeyboardManagerSwift
import AVFoundation
import AVKit

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var notificationTableView: UITableView!

    var start_index = 0
    var notificationArray : [User] = []
    var obj = User()
    var boolSent : Bool = true
    var profileBool : Bool = true

    override func viewDidLoad()

    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getNotificationListApi()
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.isHidden = true
        }
        
    }

    // MARK:-
    //MARK:-  IB Actions

    @IBAction func cancelBtnAction(_ sender: Any) {

        self.dismiss(animated: true, completion: nil
        )
    }

    // MARK:-
    //MARK:-  TableView DataSources

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return notificationArray.count

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableViewAutomaticDimension

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
         cell.profileImage.tag = indexPath.row
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(imageTapped(tapGestureRecognizer:)))
        
        cell.profileImage.isUserInteractionEnabled = true
        cell.profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        
       // cell.descriptionLabel.sizeToFit()

        if notificationArray.count > 0 {
//            cell.profileImage.sd_setImage(with: URL(string : notificationArray[indexPath.row].image_profile))
            
            cell.profileImage.sd_setImage(with: URL(string : notificationArray[indexPath.row].image_profile), placeholderImage:  UIImage(named: "img_placeholder"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
            }
            
            
            
            cell.nameLabel.text = notificationArray[indexPath.row].name
            cell.descriptionLabel.text = notificationArray[indexPath.row].text_to_show
        }

        cell.onViewButtonTapped = {

            let vc:HashTagSelectionViewController = self.storyboard?.instantiateViewController(withIdentifier:"HashTagSelectionViewController") as! HashTagSelectionViewController
            vc.modalPresentationStyle = .overCurrentContext
            //vc.homeArray = self.notificationArray
            vc.user_ID = self.notificationArray[indexPath.row].post_notificated
            vc.boolHashRecived = self.boolSent
           // vc.delegate = self
            self.present(vc, animated:true, completion:nil)
            

        }



        return cell





    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

            if indexPath.row == notificationArray.count - 1 && notificationArray.count > 19
            {
                //start_index += 1
                start_index = notificationArray.count
                self.getNotificationListApi()
            }

    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        let vc:UserProfileViewController = self.storyboard?.instantiateViewController(withIdentifier:"UserProfileViewController") as! UserProfileViewController
//        vc.objc = notificationArray[indexPath.row].post_notificated
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK:-
    //MARK:-  Tap Gesture Methods
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tag = (tapGestureRecognizer.view)?.tag
//        let indexPath = NSIndexPath(row: tag!, section: 0)
//
//        let cell = self.notificationTableView.cellForRow(at: indexPath as IndexPath) as! NotificationCell
        
        if notificationArray[tag!].id_user == RichnessUserDefault.getUserID() {
           
            let vc:ProfileVC = self.storyboard?.instantiateViewController(withIdentifier:"ProfileVC") as! ProfileVC
            vc.boolRecived = profileBool
             let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
            
        }
        
        else {
            let vc:UserProfileViewController = self.storyboard?.instantiateViewController(withIdentifier:"UserProfileViewController") as! UserProfileViewController
            vc.objc = notificationArray[tag!].id_user
             let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
       
        
    }

    // MARK:-
    //MARK:-  Api Methods

    func getNotificationListApi() {

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        let params = [ "start_index" : self.start_index,
                       "user_id" : RichnessUserDefault.getUserID(),
                       "key" : key
            ] as [String : Any]
        print(params)

        //start_index += 1

        RichnessAlamofire.POST(GETNOTIFICATION_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                print(responseObject)
                // self.tableView.endRefreshing(at: .bottom)
                if(responseObject.object(forKey: "result") != nil){
                    let result = responseObject.object(forKey: "result") as? [NSDictionary]
                    self.notificationTableView.isHidden = false
                    self.statusLabel.isHidden = true
                    print(result)

                    for item in result!{

                        let userDatamodel = User()

                        userDatamodel.id = item["id"] as? String ?? ""
                        if (userDatamodel.id == ""){
                            userDatamodel.id = String(describing: item["id"] as? Int)
                        }

                        userDatamodel.country = item["country"] as? String ?? ""
                        userDatamodel.description = item["description"] as? String ?? ""
                        userDatamodel.id_user = item["id_user"] as? String ?? ""
                        userDatamodel.post_notificated = item["post_notificated"] as? String ?? ""
                        userDatamodel.image_profile = item["image_profile"] as? String ?? ""
                        userDatamodel.likes = item["likes"] as? String ?? ""
                        userDatamodel.name = item["name"] as? String ?? ""
                        userDatamodel.total_comments = item["total_comments"] as? String ?? ""
                        userDatamodel.ranking = item["ranking"] as? String ?? ""
                        userDatamodel.text_to_show = item["text_to_show"] as? String ?? ""
                        userDatamodel.datetime = item["datetime"] as? String ?? ""
                        userDatamodel.is_followed = item["is_followed"] as? Int ?? 0
                        userDatamodel.notification_type = item["notification_type"] as? String ?? ""


                        // if !userDatamodel.image.isEmpty{

                        self.notificationArray.append(userDatamodel)
                        // }

                    }
                    // if self.start_index == 0{
                    DispatchQueue.main.async {

                        self.notificationTableView.reloadData()
                    }
                    //                    }
                    //
                    //                   else if let cell = self.profileTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? ProfileDataCell{
                    //                         DispatchQueue.main.async {
                    //                   cell.userDataCollectionView.reloadData()
                    //                    }
                    //                    }
                }

                else
                {
                    if self.start_index == 0
                    {
                        self.notificationTableView.isHidden = true
                        self.statusLabel.isHidden = false
                        self.statusLabel.text = "No Followers"
                    }
                }
            }
            else
            {
                let error = responseObject.object(forKey: "error") as? String
                if (error == "#997") {
                    self.showError(errMsg: user_error_unknown)
                }
                else {
                    //self.showError(errMsg: error_on_server)
                }
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
