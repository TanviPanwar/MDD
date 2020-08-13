//
//  UserProfileViewController.swift
//  Richness
//
//  Created by IOS3 on 01/02/19.
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

class UserProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
 
    
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    // @IBOutlet weak var userCollectionView: UICollectionView!
    
    var start_index = 0
    //var obj = SearchUser()
    var objc = String() //SearchUser()
    var mainObjc = String() //User()
    var userDataArray : [User] = []
    var width = CGFloat()
    var cellTag = Int()
    var dataArray = [User]()
    var boolRecived = Bool()
    var profileObj = User()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        width = (UIScreen.main.bounds.size.width - 2)/3
        //userProfileTableView.reloadData()
        getUserDetails()
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    deinit {
        
    }
    
    // MARK:-
    //MARK:-  TableView DataSources
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return 2
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        if indexPath.row == 0 {
//
//            return 346
//
//        }
//
//        else {
//
//            if (userDataArray.count)/3 != 0
//            {
//                let reminder: CGFloat = (CGFloat((userDataArray.count)/3 + 1))
//                let height = reminder * (width + 60)
//
//                return height + 40
//            }
//
//            else if userDataArray.count < 3
//            {
//
//                return width + 60 + 40
//            }else {
//                let reminder: CGFloat = CGFloat((userDataArray.count)/3)
//                let height = reminder * (width + 60)
//                return height + 40
//
//            }
//        }
//
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if indexPath.row == 0 {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as! UserProfileCell
//            if userDataArray.count > 0 {
//
//                cell.userWallImage.sd_setImage(with: URL(string :userDataArray[0].image_profile))
//                //  cell.userProfileImage.sd_setImage(with: URL(string : userDataArray[0].image_profile))
//
//                cell.userProfileImage.sd_setImage(with: URL(string : userDataArray[0].image_profile), placeholderImage: UIImage(named: "img_placeholder"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
//                    //                                if image != nil {
//                    //
//                    //                                }
//                    //
//                    //                                else {
//                    //
//                    //                                    //cell.imageView.image = UIImage(named: "img_placeholder")
//                    //                                }
//                }
//
//
//                cell.userNameLabel.text = userDataArray[0].name
//                cell.userDescriptionLabel.text = userDataArray[0].description
//                cell.userLikesBtn.setTitle("\(userDataArray[0].total_like)" + " " + "Likes", for: .normal)
//                cell.userFollowerBtn.setTitle("\(userDataArray[0].total_follower)" + " " + "Followers", for: .normal)
//                cell.userFansBtn.setTitle("\(userDataArray[0].total_fans)" + " " + "Fans", for: .normal)
//
//                if userDataArray[0].is_followed == 1
//                {
//                    cell.followUnfollowBtn.setTitle("Unfollow", for: .normal)
//
//                }
//
//                else if userDataArray[0].is_followed == 0
//                {
//                    cell.followUnfollowBtn.setTitle("Follow", for: .normal)
//
//                }
//
//
//
//
//
//
//                cell.onCancelButtonTapped = {
//
//                    self.dismiss(animated: true, completion: nil)
//                }
//
//                cell.onSearchButtonTapped = {
//                    self.view.endEditing(true)
//
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
//
//                    vc.modalPresentationStyle = .overCurrentContext
//                    let nav = UINavigationController(rootViewController: vc )
//                    self.present(nav, animated:true, completion:nil)
//
//                }
//
//                cell.onFolllowUnfollowButtonTapped = {
//
//                    if cell.followUnfollowBtn.currentTitle == "Follow" {
//
//                        cell.followUnfollowBtn.setTitle("Unfollow", for: .normal)
//
//                    }
//
//                    else {
//
//                        cell.followUnfollowBtn.setTitle("Follow", for: .normal)
//
//                    }
//
//                    self.followerApi(index : indexPath.row )
//
//                }
//
//                cell.onFolllowerButtonTapped = {
//                    self.cellTag = cell.userFollowerBtn.tag
//
//                    let vc:FollowersFansViewController = self.storyboard?.instantiateViewController(withIdentifier:"FollowersFansViewController") as! FollowersFansViewController
//                    vc.modalPresentationStyle = .overCurrentContext
//                    vc.obj = self.userDataArray[0]
//                    vc.getTag = self.cellTag
//                    let nav = UINavigationController(rootViewController: vc)
//                    self.present(nav, animated:true, completion:nil)
//
//
//                }
//
//                cell.onFansButtonTapped = {
//                    self.cellTag = cell.userFansBtn.tag
//
//                    let vc:FollowersFansViewController = self.storyboard?.instantiateViewController(withIdentifier:"FollowersFansViewController") as! FollowersFansViewController
//                    vc.modalPresentationStyle = .overCurrentContext
//                    vc.obj = self.userDataArray[0]
//                    vc.getTag = self.cellTag
//                    let nav = UINavigationController(rootViewController: vc)
//                    self.present(nav, animated:true, completion:nil)
//
//                }
//
//            }
//
//
//            else {
//                cell.userLikesBtn.setTitle("0 Likes", for: .normal)
//                cell.userFollowerBtn.setTitle("0 Followers", for: .normal)
//                cell.userFansBtn.setTitle("0 Fans", for: .normal)
//
//
//                cell.onFolllowUnfollowButtonTapped = {
//
//                    print("no")
//                }
//
//                cell.onFansButtonTapped = {
//
//                    print("no")
//                }
//            }
//
//
//
//
//            return cell
//
//
//        }
//
//        else {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "UserDataCell", for: indexPath) as! UserDataCell
//            //           if userDataArray.count > 0
//            //           {
//            //
//            //            cell.userLikesBtn.setTitle("\(userDataArray[0].total_like)" + " " + "Likes", for: .normal)
//            //            cell.userFollowerBtn.setTitle("\(userDataArray[0].total_follower)" + " " + "Followers", for: .normal)
//            //            cell.userFansBtn.setTitle("\(userDataArray[0].total_fans)" + " " + "Fans", for: .normal)
//            //           }
//            //
//            //           else {
//            //            cell.userLikesBtn.setTitle("0 Likes", for: .normal)
//            //            cell.userFollowerBtn.setTitle("0 Followers", for: .normal)
//            //            cell.userFansBtn.setTitle("0 Fans", for: .normal)
//            //            }
//
//
//
//            cell.userDataCollectionView.reloadData()
//
//
//            //             cell.onFolllowerButtonTapped = {
//            //               self.cellTag = cell.userFollowerBtn.tag
//            //
//            //                let vc:FollowersFansViewController = self.storyboard?.instantiateViewController(withIdentifier:"FollowersFansViewController") as! FollowersFansViewController
//            //                 vc.modalPresentationStyle = .overCurrentContext
//            //                vc.obj = self.userDataArray[0]
//            //                vc.getTag = self.cellTag
//            //                self.present(vc, animated:true, completion:nil)
//            //
//            //
//            //            }
//            //
//            //            cell.onFansButtonTapped = {
//            //                 self.cellTag = cell.userFansBtn.tag
//            //
//            //                let vc:FollowersFansViewController = self.storyboard?.instantiateViewController(withIdentifier:"FollowersFansViewController") as! FollowersFansViewController
//            //                vc.modalPresentationStyle = .overCurrentContext
//            //                vc.obj = self.userDataArray[0]
//            //                vc.getTag = self.cellTag
//            //                self.present(vc, animated:true, completion:nil)
//            //
//            //
//            //            }
//
//            return cell
//        }
//    }
    
    
    // MARK:-
    //MARK:-  CollectionView DataSources
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height:360 )
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as! ProfileHeaderView
            headerView.cancelBtn.isHidden = false
           
            headerView.userProfileImage.layer.borderWidth = 1
            headerView.userProfileImage.layer.masksToBounds = false
            headerView.userProfileImage.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.737254902, blue: 0.5843137255, alpha: 1)
            headerView.userProfileImage.layer.cornerRadius =  headerView.userProfileImage.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
            headerView.userProfileImage.clipsToBounds = true
                if self.profileObj.is_followed == 1
                {
                    headerView.followUnfollowBtn.setTitle("Unfollow", for: .normal)
                    
                }
                    
                else if self.profileObj.is_followed == 0
                {
                    headerView.followUnfollowBtn.setTitle("Follow", for: .normal)
                    
                }
                headerView.userWallImage.sd_setImage(with: URL(string : self.profileObj.image_profile))
//                headerView.userProfileImage.sd_setImage(with: URL(string : userDataArray[indexPath.row].image_profile))
                   headerView.userProfileImage?.sd_setImage(with: URL(string :self.profileObj.image_profile), placeholderImage:UIImage(named:"img_placeholder"), options:[], completed: nil)
                headerView.userNameLabel.text = self.profileObj.name
                headerView.userDescriptionLabel.text = self.profileObj.description
                headerView.userLikesBtn.setTitle("\(self.profileObj.total_like)" + " " + "Likes", for: .normal)
                headerView.userFollowerBtn.setTitle("\(self.profileObj.total_follower)" + " " + "Followers", for: .normal)
                headerView.userFansBtn.setTitle("\(self.profileObj.total_fans)" + " " + "Fans", for: .normal)
           
            return headerView
            
        case UICollectionElementKindSectionFooter:
            
            return  UICollectionReusableView()
            
        default:
            
            assert(false, "Unexpected element kind")
        }
         return  UICollectionReusableView()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width:width, height: width + 60)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionCell", for: indexPath) as! ProfileCollectionCell
        
        if  userDataArray[indexPath.row].type == "0" {
            
            cell.videoView.isHidden = true
            cell.playVideoImage.isHidden = true
            cell.imageView.isHidden = false
            
            
            if !self.userDataArray[indexPath.row].image.isEmpty {
                if let imageFromCache = imageCache.object(forKey: self.userDataArray[indexPath.row].image as AnyObject) as? UIImage {
                    if cell.imageView.image == nil {
                        cell.imageView.image = imageFromCache
                    }
                    
                } else {
                    cell.imageView.imageFromServerURL(urlString: self.userDataArray[indexPath.row].image) { (image) in
                        if image != nil {
                            imageCache.setObject(image!, forKey: self.userDataArray[indexPath.row].image as AnyObject)
                            if cell.imageView.image == nil {
                                cell.imageView.image = image
                            }
                        }
                    }
                    
                }
                
            } else {
                cell.imageView.isHidden = true
            }
            
            
            //            cell.imageView.imageFromServerURL(urlString:self.userDataArray[indexPath.row].image , collectionView: profileCollectionView, indexpath: indexPath)
            //            if self.userDataArray[indexPath.row].savedImage != nil {
            //                 cell.imageView.image = self.userDataArray[indexPath.row].savedImage
            //            } else {
            //                ProjectManager.shared.getImageFromSDWebimage(urlStr:self.userDataArray[indexPath.row].image) { (image) in
            //                cell.imageView.image = image
            //                self.userDataArray[indexPath.row].savedImage = image
            //              }
            //            }
            
            
            
            
            
        }
        else if userDataArray[indexPath.row].type == "1" {
            
            cell.imageView.isHidden = false
            cell.playVideoImage.isHidden = false
            cell.videoView.isHidden = true
            if cell.imageView.image == nil {
                
                if !self.userDataArray[indexPath.row].image.isEmpty {
                    if let imageFromCache = imageCache.object(forKey: self.userDataArray[indexPath.row].image as AnyObject) as? UIImage {
                        if cell.imageView.image == nil {
                            cell.imageView.image = imageFromCache
                        }
                        
                    } else {
                        cell.imageView.imageFromVideoServerURL(urlString: self.userDataArray[indexPath.row].image) { (image) in
                            if image != nil {
                                imageCache.setObject(image!, forKey: self.userDataArray[indexPath.row].image as AnyObject)
                                if cell.imageView.image == nil {
                                    cell.imageView.image = image
                                }
                            } else {
                                
                            }
                        }
                        
                    }
                    
                } else {
                    cell.imageView.isHidden = true
                }
                
            }
            //             cell.imageView.imageFromVideoServerURL(urlString:self.userDataArray[indexPath.row].image , collectionView: profileCollectionView, indexpath: indexPath)
            //            if userDataArray[indexPath.row].savedImage == nil {
            //                if userDataArray[indexPath.row].image .hasPrefix("https") {
            //                    ProjectManager.shared.getThumnailImageFromVideo(urlStr:  userDataArray[indexPath.row].image) { (image) in
            //                       imageCache
            //                        cell.imageView?.image = image
            //                    }
            //
            //                } else {
            //
            //                    cell.imageView?.image = userDataArray[indexPath.row].savedImage
            //
            //                }
            //
            //            }
        }
        
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        print("start_index is:\(self.start_index)")
        if indexPath.row == self.userDataArray.count - 1 && self.userDataArray.count > 19 {
            if self.start_index != -1 {
                self.getUserDetails()
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc:ProfileGalleryViewController = self.storyboard?.instantiateViewController(withIdentifier:"ProfileGalleryViewController") as! ProfileGalleryViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.cellIndex = indexPath.row
        vc.homeArray = userDataArray
        vc.start_index = start_index
        vc.user_ID = userDataArray[indexPath.row].id_user
        if self.parent is MainViewController {
            self.parent?.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        //            .present(vc, animated:true, completion:nil)
        
    }
    
    
    @IBAction func followUnfollowBtnAction(sender:GradientButton) {
         if userDataArray.count > 0 {
            let viw = profileCollectionView.supplementaryView(forElementKind:UICollectionElementKindSectionHeader, at: IndexPath(item:0, section: 0)) as? ProfileHeaderView
            if viw?.followUnfollowBtn.currentTitle == "Follow" {
            
                viw?.followUnfollowBtn.setTitle("Unfollow", for: .normal)
            
        }
            
        else {
            
                viw?.followUnfollowBtn.setTitle("Follow", for: .normal)
            
        }
       
           self.followerApi(index : 0 )
        }
        
        
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil
        )
    }
    
    @IBAction func searchBtnAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        let nav = UINavigationController(rootViewController: vc )
        self.present(nav, animated:true, completion:nil)
    }
    
   
    @IBAction func userFollwerBtnAction(_ sender: Any) {
        
        if userDataArray.count > 0 {
            let vc:FollowersFansViewController = self.storyboard?.instantiateViewController(withIdentifier:"FollowersFansViewController") as! FollowersFansViewController
            vc.modalPresentationStyle = .overCurrentContext
            
            vc.obj = self.userDataArray[0]
            vc.getTag = 3
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated:true, completion:nil)
        }
    }
    
    @IBAction func userFansBtnAction(_ sender: Any) {
        
        if userDataArray.count > 0 {
            let vc:FollowersFansViewController = self.storyboard?.instantiateViewController(withIdentifier:"FollowersFansViewController") as! FollowersFansViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.obj = self.userDataArray[0]
            vc.getTag = self.cellTag
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated:true, completion:nil)
        }
    }
    
    // MARK:-
    //MARK:-  Api Methods
    
    
    func getUserDetails() {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        let params = [ "start_index" : self.start_index,
                       "user_id" : RichnessUserDefault.getUserID(),
                       "id" :  objc,
                       "key" : key
            ] as [String : Any]
        print(params)
        
        // start_index += 1
        
        RichnessAlamofire.POST(GETTIMELINE_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                print(responseObject)
                // self.tableView.endRefreshing(at: .bottom)
                if(responseObject.object(forKey: "result") != nil){
                    let result = responseObject.object(forKey: "result") as? [NSDictionary]
                    
                    print(result)
                     if (result!.count) > 0{
                    for item in result!{
                        
                        let userDatamodel = User()
                        
                        userDatamodel.id = item["id"] as? String ?? ""
                        if (userDatamodel.id == ""){
                            userDatamodel.id = String(describing: item["id"] as? Int)
                        }
                        
                        userDatamodel.country = item["country"] as? String ?? ""
                        userDatamodel.description = item["description"] as? String ?? ""
                        userDatamodel.id_user = item["id_user"] as? String ?? ""
                        userDatamodel.image = item["image"] as? String ?? ""
                        userDatamodel.image_profile = item["image_profile"] as? String ?? ""
                        userDatamodel.likes = item["likes"] as? String ?? ""
                        userDatamodel.name = item["name"] as? String ?? ""
                        userDatamodel.total_comments = item["total_comments"] as? String ?? ""
                        userDatamodel.ranking = item["ranking"] as? String ?? ""
                        userDatamodel.text = item["text"] as? String ?? ""
                        userDatamodel.is_followed = item["is_followed"] as? Int ?? 0
                        userDatamodel.user_like = item["user_like"] as? String ?? ""
                        userDatamodel.total_fans = item["total_fans"] as? Int ?? 0
                        userDatamodel.total_like = item["total_like"] as? Int ?? 0
                        userDatamodel.total_follower = item["total_follower"] as? Int ?? 0
                        userDatamodel.type = item["type"] as? String ?? ""
                        
                        self.profileObj = userDatamodel
                        
                         if !userDatamodel.type.isEmpty {

                            self.userDataArray.append(userDatamodel)

                         }
                        
                    }
                     self.start_index += 1
                     } else {
                        self.start_index = -1
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
                        self.profileCollectionView.reloadData()
                        //  self.getMyProfileApi()
                    })
                }
                    
                else
                {
                      self.start_index = -1
                }
            }
            else
            {
                let error = responseObject.object(forKey: "error") as? String
                if error ==  nil {
                    self.getUserDetails()
                } else {
                    if (error == "#997") {
                        self.showError(errMsg: user_error_unknown)
                    }
                    else {
                         self.showError(errMsg: error_on_server)
                    }
                }
               
            }
        }
    }
    
    
    func followerApi(index: Int)
    {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        
        let params = [
            "user_id" : RichnessUserDefault.getUserID(),
            "user_followed": objc,
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
