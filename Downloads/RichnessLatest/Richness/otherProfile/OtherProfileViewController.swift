//
//  OtherProfileViewController.swift
//  Richness
//
//  Created by Sobura on 6/12/18.
//  Copyright © 2018 Sobura. All rights reserved.
//

import Foundation
import UIKit
import PullToRefresh
import SDWebImage

class OtherProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var reportAlertView: UIView!
    
    var image = UIImage()
    var avatarImage : Data? = nil
    
    var cell1 : profile_firstCell!
    var profileImage = ""
    var refreshControl = UIRefreshControl()
    var start_index = 0
    var otherProfileArray : [User] = []
    var idimage = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        reportAlertView.frame = self.view.frame
        self.view.addSubview(reportAlertView)
        
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        let alertTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(exitAlert))
        alertTap.numberOfTapsRequired = 1
        self.reportAlertView.addGestureRecognizer(alertTap)
        
        getOtherProfile()
    }
    
    @objc func exitAlert()  {
        
        self.reportAlertView.isHidden = true
    }
    
    @objc func refresh() {
        
        start_index = 0
        otherProfileArray.removeAll()
        getOtherProfile()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if otherProfileArray.count == 0 {
            return 0
        }
        
        return otherProfileArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row == 0){
            return 300
        }
        else{
            return 550
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherProfile_firstCell", for: indexPath) as! otherProfile_firstCell
            cell.nameLabel.text = otherProfileArray[indexPath.row].name
            cell.rankLabel.text = otherProfileArray[indexPath.row].ranking + "."
            cell.avatarImgView.sd_setImage(with: URL(string : otherProfileArray[indexPath.row].image_profile))
            
            if(otherProfileArray[indexPath.row].country != ""){
                cell.countryLabel.text = otherProfileArray[indexPath.row].country
            }
            else{
                cell.countryLabel.text = "Country"
            }
            cell.infoTxtView.text = otherProfileArray[indexPath.row].description
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherProfile_secondCell", for: indexPath) as! otherProfile_secondCell
            
            cell.nameLabel.text = otherProfileArray[indexPath.row - 1].name
            cell.likeLabel.text = otherProfileArray[indexPath.row - 1].likes + " persons"
            
            cell.avatarImgView.sd_setImage(with: URL(string : otherProfileArray[indexPath.row - 1].image_profile))
            
            
            if(otherProfileArray[indexPath.row - 1].user_like == "1"){
                cell.likeButton.isChecked = true
            }
            else{
                cell.likeButton.isChecked = false
            }
            
            cell.profileImgView.sd_setImage(with: URL(string : otherProfileArray[indexPath.row - 1].image))
            
            cell.infoTxtView.text = otherProfileArray[indexPath.row - 1].text
            
            cell.on3DotButtonTapped = {
                
                self.reportAlertView.isHidden = false
                self.idimage = self.otherProfileArray[indexPath.row - 1].id
            }
            
            cell.onDiamondButtonTapped = {
                
                if cell.likeButton.isChecked {
                    self.like_unlike(like_type: 1, imageId: self.otherProfileArray[indexPath.row - 1].id, cell: cell, index : indexPath.row)
                    
                }
                else{
                    self.like_unlike(like_type: 2, imageId: self.otherProfileArray[indexPath.row - 1].id, cell: cell, index : indexPath.row)
                }
            }
            
            cell.onProfileTapped = {
                self.profileImage = self.otherProfileArray[indexPath.row - 1].image
                self.rightToLeft()
                let nextView = mainstoryboard.instantiateViewController(withIdentifier: "ImagePreviewController") as! ImagePreviewController
                nextView.image = self.profileImage
                self.present(nextView, animated: false, completion: nil)
            }
            
            return cell
        }
    }
    
    func getOtherProfile() {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        
        let params = [
            "start_index" : self.start_index,
            "user_id" : RichnessUserDefault.getUserID(),
            "id" : RichnessUserDefault.getOtherUserID(),
            "key" : key
            ] as [String : Any]
        print(params)
        
        start_index += 1
        
        RichnessAlamofire.POST(GETTIMELINE_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                print(responseObject)
                self.tableView.endRefreshing(at: .bottom)
                if(responseObject.object(forKey: "result") != nil){
                    let result = responseObject.object(forKey: "result") as? [NSDictionary]
                    
                    for item in result!{
                        
                        let usermodel = User()
                        
                        usermodel.id = item["id"] as? String ?? ""
                        if (usermodel.id == ""){
                            usermodel.id = String(describing: item["id"] as? Int)
                        }
                        
                        usermodel.country = item["country"] as? String ?? ""
                        usermodel.description = item["description"] as? String ?? ""
                        usermodel.id_user = item["id_user"] as? String ?? ""
                        usermodel.image = item["image"] as? String ?? ""
                        usermodel.image_profile = item["image_profile"] as? String ?? ""
                        usermodel.likes = item["likes"] as? String ?? ""
                        usermodel.name = item["name"] as? String ?? ""
                        usermodel.ranking = item["ranking"] as? String ?? ""
                        usermodel.text = item["text"] as? String ?? ""
                        usermodel.user_like = item["user_like"] as? String ?? ""
                        
                        self.otherProfileArray.append(usermodel)
                    }
                    self.tableView.reloadData()
                }
                else{
                    let error = responseObject.object(forKey: "error") as? String
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
    
    func like_unlike(like_type : Int, imageId : String, cell : otherProfile_secondCell, index : Int) {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        
        let params = [
            "liked_type" : like_type,
            "image_id" : imageId,
            "user_id" : RichnessUserDefault.getUserID(),
            "key" : key
            ] as [String : Any]
        print(params)
        
        RichnessAlamofire.POST(ADDLIKE_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                
                if(responseObject.object(forKey: "like_add") != nil){
                    if(like_type == 1){
                        
                        self.otherProfileArray[index - 1].likes = String(Int(self.otherProfileArray[index - 1].likes)! + 1)
                        cell.likeLabel.text = self.otherProfileArray[index - 1].likes + " persons"
                    }
                    else{
                        self.otherProfileArray[index - 1].likes = String(Int(self.otherProfileArray[index - 1].likes)! - 1)
                        cell.likeLabel.text = self.otherProfileArray[index - 1].likes + " persons"
                        
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
    
    func setupPullToRefresh() {
        self.tableView.addPullToRefresh(PullToRefresh(position: .bottom)) { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                
                if (self?.otherProfileArray.count)! % 20 != 0{
                    self?.tableView.removePullToRefresh(at: .bottom)
                    return
                }
                self?.getOtherProfile()
            }
        }
    }
    
    func reportImage() {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        
        let params = [
            "user_id" : RichnessUserDefault.getUserID(),
            "idimage" : idimage,
            "key" : key
            ] as [String : Any]
        print(params)
        
        RichnessAlamofire.POST(REPORTPHOTO_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                print(responseObject)
                if(responseObject.object(forKey: "result") != nil){
                    
                    self.reportAlertView.isHidden = true
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
    
    @IBAction func onTapBack(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapReport(_ sender: UIButton) {
        
        reportImage()
    }
}
