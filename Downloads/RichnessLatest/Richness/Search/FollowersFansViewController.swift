//
//  FollowersFansViewController.swift
//  Richness
//
//  Created by IOS3 on 04/02/19.
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

class FollowersFansViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var follwerFanTableView: UITableView!

    var startfollwer_index = 0
    var startfan_index = 0

    var followerArray : [SearchUser] = []
    var fansArray : [SearchUser] = []
    var commonArray : [SearchUser] = []
    var obj = User()
    var getTag = Int()
    var profileBool : Bool = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if getTag == 3 {
            self.topicLabel.text = "Following"
            self.getFollowers()
        }
        else {
            self.topicLabel.text = "Fans"
            self.getFans()
        }
        follwerFanTableView.estimatedRowHeight = 100
        
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.isHidden = true
        }
        
        // Do any additional setup after loading the view.
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

        if getTag == 3
        {
            return followerArray.count
        }
        else
        {
            return fansArray.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        if selectedTag == usersBtn.tag
////        {
//            return 100
////        }
////        else
////        {
////            return 66
////        }
        print(UITableViewAutomaticDimension)
        return UITableViewAutomaticDimension
       // return UITableViewAutomaticDimension

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersFanCell", for: indexPath) as! FollowersFanCell
        



        if getTag == 3 {

            commonArray = followerArray

        }

        else {
            commonArray = fansArray
        }

            //cell.profileImage.sd_setImage(with: URL(string : commonArray[indexPath.row].image_profile))
        
        cell.profileImage.sd_setImage(with: URL(string : commonArray[indexPath.row].image_profile), placeholderImage: UIImage(named: "img_placeholder"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
            
        }

        
        
            cell.nameLabel.text = commonArray[indexPath.row].user_name
            cell.descriptionLabel.text = commonArray[indexPath.row].descriptionText

            if commonArray[indexPath.row].user_follow == 1{
                cell.followUnfollowBtn.setTitle("Unfollow", for: .normal)
            }

            else if commonArray[indexPath.row].user_follow == 0{
                cell.followUnfollowBtn.setTitle("Follow", for: .normal)
            }

            cell.onFollowUnfollowButtonTapped = {

                if cell.followUnfollowBtn.currentTitle == "Follow" {

                    cell.followUnfollowBtn.setTitle("Unfollow", for: .normal)
                }
                else {

                    cell.followUnfollowBtn.setTitle("follow", for: .normal)
                }

                self.followerApi(index : indexPath.row )
            }



            return cell





    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if getTag == 3
        {

            if indexPath.row == followerArray.count - 1 && followerArray.count > 19
            {

                self.getFollowers()
            }

        }

        else
        {
            if indexPath.row == fansArray.count - 1 && fansArray.count > 19
            {

                self.getFans()
            }

        }


    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {



        if commonArray[indexPath.row].id_user == RichnessUserDefault.getUserID() {
            
            let vc:ProfileVC = self.storyboard?.instantiateViewController(withIdentifier:"ProfileVC") as! ProfileVC
             vc.boolRecived = profileBool
         let nav = UINavigationController(rootViewController: vc)
         self.present(nav, animated: true, completion: nil)
            
        }
       else {
            let vc:UserProfileViewController = self.storyboard?.instantiateViewController(withIdentifier:"UserProfileViewController") as! UserProfileViewController
            vc.objc = commonArray[indexPath.row].id_user
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
    }




    // MARK:-
    //MARK:-  Api Methods

    func getFollowers() {

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
       // let searchStr:String = (searchTextView.text?.trimmingCharacters(in: CharacterSet.whitespaces))!

        let params = [
            "start_index" : self.startfollwer_index,
            "user_id" : obj.id_user,
            "key" : key
            ] as [String : Any]
        print(params)

        startfollwer_index = 1

        RichnessAlamofire.POST(GETFOLLOWERS_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                print(responseObject)
                // self.tableView.endRefreshing(at: .bottom)
                if(responseObject.object(forKey: "result") != nil){
                    let result = responseObject.object(forKey: "result") as? [NSDictionary]
                    self.follwerFanTableView.isHidden = false
                    self.statusLabel.isHidden = true

                    print(result)
                    for item in result!{

                        let followerFanmodel = SearchUser()

                        followerFanmodel.id_user = item["id_user"] as? String ?? ""
                        if (followerFanmodel.id_user == ""){
                            followerFanmodel.id_user = String(describing: item["id_user"] as? Int)
                        }

                        followerFanmodel.user_name = item["name"] as? String ?? ""
                        followerFanmodel.descriptionText = item["description"] as? String ?? ""
                        followerFanmodel.image_profile = item["image_profile"] as? String ?? ""
                        followerFanmodel.user_follow = item["follow"] as? Int ?? 1
                        self.followerArray.append(followerFanmodel)

                    }
                    DispatchQueue.main.async {

                        self.follwerFanTableView.reloadData()
                    }
                }

                else
                {
                    if self.startfollwer_index == 1
                    {
                        self.follwerFanTableView.isHidden = true
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
                    self.showError(errMsg: error_on_server)
                }
            }
        }
    }

    func getFans() {

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        // let searchStr:String = (searchTextView.text?.trimmingCharacters(in: CharacterSet.whitespaces))!

        let params = [
            "start_index" : self.startfan_index,
            "user_id" : obj.id_user,
            "key" : key
            ] as [String : Any]
        print(params)

        startfan_index = 1

        RichnessAlamofire.POST(GETFANS_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                print(responseObject)
                // self.tableView.endRefreshing(at: .bottom)
                if(responseObject.object(forKey: "result") != nil){
                    let result = responseObject.object(forKey: "result") as? [NSDictionary]
//                    self.follwerFanTableView.isHidden = false
//                    self.statusLabel.isHidden = true

                    print(result)
                    if result!.isEmpty {

                        if self.startfan_index == 1
                        {
                            self.follwerFanTableView.isHidden = true
                            self.statusLabel.isHidden = false
                            self.statusLabel.text = "No Fans"
                        }

                    }

                    else {
                        for item in result!{

                            self.follwerFanTableView.isHidden = false
                            self.statusLabel.isHidden = true

                            let followerFanmodel = SearchUser()
                            followerFanmodel.id_user = item["id_user"] as? String ?? ""
                            if (followerFanmodel.id_user == ""){
                                followerFanmodel.id_user = String(describing: item["id_user"] as? Int)
                            }

                            followerFanmodel.user_name = item["name"] as? String ?? ""
                            followerFanmodel.descriptionText = item["description"] as? String ?? ""
                            followerFanmodel.image_profile = item["image_profile"] as? String ?? ""
                            followerFanmodel.user_follow = item["is_followed"] as? Int ?? 0
                            self.fansArray.append(followerFanmodel)

                        }


                    DispatchQueue.main.async {

                        self.follwerFanTableView.reloadData()
                    }
                }
            }

                else
                {
                    if self.startfan_index == 1
                    {
                        self.follwerFanTableView.isHidden = true
                        self.statusLabel.isHidden = false
                        self.statusLabel.text = "No Fans"
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
                    self.showError(errMsg: error_on_server)
                }
            }
        }
    }

    func followerApi(index: Int)
    {
        if getTag == 3 {

            commonArray = followerArray
        }

        else {

            commonArray = fansArray
        }

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)

        let params = [
            "user_id" : RichnessUserDefault.getUserID(),
            "user_followed": commonArray[index].id_user,
            "key" : key
            ] as [String : Any]
        print(params)

        RichnessAlamofire.POST(ADDFOLLOWRES_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){

                print(responseObject)

            }
            else
            {
                let error = responseObject.object(forKey: "error") as? String
                if (error == "#997") {
                    self.showError(errMsg: user_error_unknown)
                }
                else {
                    self.showError(errMsg: error_on_server)
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
