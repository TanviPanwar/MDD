//
//  LankingViewController.swift
//  Richness
//
//  Created by Sobura on 6/6/18.
//  Copyright © 2018 Sobura. All rights reserved.
//

import Foundation
import UIKit
import PullToRefresh

class LankingViewController: PanelViewController, UITableViewDelegate, UITableViewDataSource{
    
    var refreshControl = UIRefreshControl()
    var start_index = 0
    
    var rankArray : [User] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hallView: UIView!
    @IBOutlet weak var hallLabel: UILabel!
    var lastIndex:Int = 7
    var isLoadMore = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        getRanking()
        setupPullToRefresh()
    }
    
    @objc func refresh() {
        
        start_index = 0
        rankArray.removeAll()
        tableView.reloadData()
        refreshControl.endRefreshing()
        getRanking()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            if(rankArray.count == 0){
                return 0
            }
            return 2
        }
            
        else {
            if rankArray.count > 3 {
                return rankArray.count - 3
            }
            else {
                return 0
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.section == 0){
            if (indexPath.row == 0)
            {
                return 300
            }
            else {
                return 60
                
            }
        }
        else{
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0){
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as! firstCell
                cell.firstAvatarImgView?.sd_setImage(with:URL(string : rankArray[0].image_profile), placeholderImage: #imageLiteral(resourceName: "img_placeholder"), options: []) { (img, error, cache, url) in
                    
                }
                cell.firstAvatarImgView.tag = 0
                let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                cell.firstAvatarImgView.addGestureRecognizer(tapGesture1)
                
                cell.secondAvatarImgView?.sd_setImage(with:URL(string : rankArray[1].image_profile), placeholderImage: #imageLiteral(resourceName: "img_placeholder"), options: []) { (img, error, cache, url) in
                    
                }
                cell.secondAvatarImgView.tag = 1
                let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                cell.secondAvatarImgView.addGestureRecognizer(tapGesture2)
                cell.thirdAvatarImgView?.sd_setImage(with:URL(string : rankArray[2].image_profile), placeholderImage: #imageLiteral(resourceName: "img_placeholder"), options: []) { (img, error, cache, url) in
                    
                }
                cell.thirdAvatarImgView.tag = 2
                let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                cell.thirdAvatarImgView.addGestureRecognizer(tapGesture3)
                //            cell.firstAvatarImgView.sd_setImage(with: URL(string : rankArray[0].image_profile))
                //            cell.secondAvatarImgView.sd_setImage(with: URL(string : rankArray[1].image_profile))
                //            cell.thirdAvatarImgView.sd_setImage(with: URL(string : rankArray[2].image_profile))
                if !rankArray[0].country.isEmpty {
                    cell.lbl1stCountry.text = rankArray[0].country
                } else {
                    cell.lbl1stCountry.text = "Country"
                }
                if !rankArray[1].country.isEmpty {
                    cell.lbl2ndCountry.text = rankArray[1].country
                } else {
                    cell.lbl2ndCountry.text = "Country"
                }
                if !rankArray[2].country.isEmpty {
                    cell.lbl3thCountry.text = rankArray[2].country
                } else {
                    cell.lbl3thCountry.text = "Country"
                }
                //            cell.lbl1stCountry.text = rankArray[0].country
                //            cell.lbl2ndCountry.text = rankArray[1].country
                //            cell.lbl3thCountry.text = rankArray[2].country
                
                cell.lbl1stScore.text = rankArray[0].credits
                cell.lbl2ndScore.text = rankArray[1].credits
                cell.lbl3thScore.text = rankArray[2].credits
                
                cell.lbl1stName.text = rankArray[0].name
                cell.lbl2ndName.text = rankArray[1].name
                cell.lbl3thName.text = rankArray[2].name
                
                //            cell.on1stAvatarButtonTapped = {
                //                (self.owner as! MainViewController).userInfoAlertView.isHidden = false
                //                (self.owner as! MainViewController).avatarImgView.sd_setImage(with: URL(string : self.rankArray[0].image_profile))
                //                (self.owner as! MainViewController).lblName.text = self.rankArray[0].name
                //                (self.owner as! MainViewController).lblCountry.text = self.rankArray[0].country
                //                (self.owner as! MainViewController).lblRanking.text = self.rankArray[0].ranking + "."
                //                RichnessUserDefault.setOtherUserID(val: self.rankArray[0].id_user)
                //            }
                //            cell.on2ndAvatarButtonTapped = {
                //                (self.owner as! MainViewController).userInfoAlertView.isHidden = false
                //                (self.owner as! MainViewController).avatarImgView.sd_setImage(with: URL(string : self.rankArray[1].image_profile))
                //                (self.owner as! MainViewController).lblName.text = self.rankArray[1].name
                //                (self.owner as! MainViewController).lblCountry.text = self.rankArray[1].country
                //                (self.owner as! MainViewController).lblRanking.text = self.rankArray[1].ranking + "."
                //                RichnessUserDefault.setOtherUserID(val: self.rankArray[1].id_user)
                //            }
                //            cell.on3rdAvatarButtonTapped = {
                //                (self.owner as! MainViewController).userInfoAlertView.isHidden = false
                //                (self.owner as! MainViewController).avatarImgView.sd_setImage(with: URL(string : self.rankArray[2].image_profile))
                //                (self.owner as! MainViewController).lblName.text = self.rankArray[2].name
                //                (self.owner as! MainViewController).lblCountry.text = self.rankArray[2].country
                //                (self.owner as! MainViewController).lblRanking.text = self.rankArray[2].ranking + "."
                //                RichnessUserDefault.setOtherUserID(val: self.rankArray[2].id_user)
                //            }
                
                return cell
            }
                
            else  {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ThirdCell", for: indexPath) as! ThirdCell
                
                return cell
                
            }
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "secondCell", for: indexPath) as! secondCell
            print(indexPath.row)
            print(rankArray.count)
            cell.avatarImgView?.sd_setImage(with:URL(string : rankArray[indexPath.row + 3].image_profile), placeholderImage: #imageLiteral(resourceName: "img_placeholder"), options: []) { (img, error, cache, url) in
                
            }
            if !rankArray[indexPath.row + 3].country.isEmpty {
                cell.countryLabel.text = rankArray[indexPath.row + 3].country
            } else {
                cell.countryLabel.text = "Country"
            }
            cell.nameLabel.text =  rankArray[indexPath.row + 3].name
            cell.scoreLabel.text = rankArray[indexPath.row + 3].credits
            cell.descriptionLabel.text = rankArray[indexPath.row + 3].description
            cell.rankLabel.text = "\(indexPath.row + 4)" + "."
            cell.avatarImgView.isUserInteractionEnabled = true
            cell.avatarImgView.tag = indexPath.row + 3
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            cell.avatarImgView.addGestureRecognizer(tapGesture)
            cell.cellView.tag = indexPath.row + 3
            let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            cell.cellView.addGestureRecognizer(tapGesture1)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
        }
        else{
           
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let actualArr = rankArray.count - 3
        let redundancy = actualArr % lastIndex
        lastIndex = lastIndex + 10
        if redundancy == 0 && isLoadMore {
            self.getRanking()
        }
        
       
        
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tag = (tapGestureRecognizer.view)?.tag
        
        
        if rankArray[tag!].id_user == RichnessUserDefault.getUserID() {
            
            let vc:ProfileVC = self.storyboard?.instantiateViewController(withIdentifier:"ProfileVC") as! ProfileVC
            vc.boolRecived = true
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
            
        }
            
        else {
            let vc:UserProfileViewController = self.storyboard?.instantiateViewController(withIdentifier:"UserProfileViewController") as! UserProfileViewController
            vc.objc = rankArray[tag!].id_user
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
        
        
    }
    
    func getRanking() {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        
        let params = [
            "start_index" : self.start_index,
            "key" : key
            ] as [String : Any]
        print(params)
        
        //        start_index += 1
        
        RichnessAlamofire.POST(GETRANKING_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                
                print(responseObject)
                self.tableView.endRefreshing(at: .bottom)
                if let res = responseObject as? [String:Any], let result = res["user_data"] as? [String:Any]{
                    let values = Array(result.values) as? [[String : Any]]
                    print(key)
                    for i in 0 ..< values!.count{
                        let usermodel = User()
                        let res = result["\(i)"] as? NSDictionary
                        usermodel.country = res?.object(forKey: "country") as? String ?? ""
                        usermodel.description = res!["description"] as? String ?? ""
                        usermodel.id_user = res!["id_user"] as? String ?? ""
                        usermodel.image_profile = res!["image_profile"] as? String ?? ""
                        usermodel.name = res!["name"] as? String ?? ""
                        usermodel.ranking = res!["ranking"] as? String ?? ""
                        usermodel.credits = res!["credits"] as? String ?? ""
                        self.rankArray.append(usermodel)
                    }
                    
                    if (values?.count)! > 0 {
                    self.start_index += 1
                    self.isLoadMore = true
                    } else {
                        self.isLoadMore = false
                    }
                   
                    self.tableView.reloadData()
                }
            }
            else
            {
                self.isLoadMore = false
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
            
            if (self?.rankArray.count)! % 20 != 0{
                self?.tableView.removePullToRefresh(at: .bottom)
                return
            }
            self?.getRanking()
        }
    }
}

