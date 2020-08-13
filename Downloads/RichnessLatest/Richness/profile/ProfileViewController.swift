//
//  ProfileViewController.swift
//  Richness
//
//  Created by Sobura on 6/7/18.
//  Copyright © 2018 Sobura. All rights reserved.
//

import Foundation
import UIKit
import PullToRefresh
import SDWebImage

class ProfileViewController: PanelViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    var image = UIImage()
    var avatarImage : Data? = nil
    
    @IBOutlet weak var tableView: UITableView!
    var cell1 : profile_firstCell!
    
    var profileImage = ""
    var refreshControl = UIRefreshControl()
    var start_index = 0
    var profileArray : [User] = []
    var isAvatarChanged = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        (self.owner as! MainViewController).profileView = self
        self.isAvatarChanged = false
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        getMyProfile()
        setupPullToRefresh()
    }
    
    @objc func refresh() {
        
        start_index = 0
        profileArray.removeAll()
        getMyProfile()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(profileArray.count == 0){
            return 0
        }
        return profileArray.count + 1
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "profile_firstCell", for: indexPath) as! profile_firstCell
            
            cell.nameLabel.text = profileArray[indexPath.row].name
            cell.lblRanking.text = profileArray[indexPath.row].ranking + "."
            
            if(self.isAvatarChanged == false){
                if profileArray[indexPath.row].image_profile != ""{
                    cell.avatarImgView.sd_setImage(with: URL(string : profileArray[indexPath.row].image_profile))
                }
                else{
                    cell.avatarImgView.image = UIImage(named:"placeholder")
                }
            }
            else{
                cell.avatarImgView.image = image
            }
            
            if(profileArray[indexPath.row].country != ""){
                cell.countryLabel.text = profileArray[indexPath.row].country
            }
            else{
                cell.countryLabel.text = "Country"
            }
            cell.infoTxtView.text = profileArray[indexPath.row].description.decodeEmoji
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(toEditName))
            cell.nameLabel.addGestureRecognizer(tap)
            
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(toEditCountry))
            cell.countryLabel.addGestureRecognizer(tap1)
            
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(toEditInfo))
            cell.infoTxtView.addGestureRecognizer(tap2)
            
            self.cell1 = cell
            
            cell.onAvatarButtonTapped = {
                
                let alertController = UIAlertController()
                
                let cameraButton = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
                    self.camera()
                })
                
                let  photoLibraryButton = UIAlertAction(title: "Photo Library", style: .default, handler: { (action) -> Void in
                
                    self.photoLibrary()
                })
                
                let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                })
                
                alertController.addAction(cameraButton)
                alertController.addAction(photoLibraryButton)
                alertController.addAction(cancelButton)
                
                self.present(alertController, animated: true, completion: nil)
            }
        
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "profile_secondCell", for: indexPath) as! profile_secondCell
            
            cell.nameLabel.text = profileArray[indexPath.row - 1].name
            cell.likeLabel.text = profileArray[indexPath.row - 1].likes + " persons"
            
            if(self.isAvatarChanged == false){
                if profileArray[0].image_profile != ""{
                    cell.avatarImgView.sd_setImage(with: URL(string : profileArray[0].image_profile))
                }
                else{
                    cell.avatarImgView.image = UIImage(named:"placeholder")
                }
            }
            else{
                cell.avatarImgView.image = image
            }
            
            if(profileArray[indexPath.row - 1].user_like == "1"){
                cell.likeButton.isChecked = true
            }
            else{
                cell.likeButton.isChecked = false
            }

            cell.profileImgView.sd_setImage(with: URL(string : profileArray[indexPath.row - 1].image))
            
            cell.infoTxtView.text = profileArray[indexPath.row - 1].text
            
            cell.on3DotButtonTapped = {
                
                (self.owner as! MainViewController).reportButton.setTitle("Delete Image", for: .normal)
                (self.owner as! MainViewController).reportAlertView.isHidden = false
                (self.owner as! MainViewController).idimage = self.profileArray[indexPath.row - 1].id
                (self.owner as! MainViewController).deletedImgIndex = indexPath.row - 1
            }
            
            cell.onDiamondButtonTapped = {
                
                if cell.likeButton.isChecked {
                    self.like_unlike(like_type: 1, imageId: self.profileArray[indexPath.row - 1].id, cell: cell, index : indexPath.row)
                    
                }
                else{
                    self.like_unlike(like_type: 2, imageId: self.profileArray[indexPath.row - 1].id, cell: cell, index : indexPath.row)
                }
            }
            
            cell.onProfileTapped = {
                self.profileImage = self.profileArray[indexPath.row - 1].image
                self.owner?.rightToLeft()
                let nextView = mainstoryboard.instantiateViewController(withIdentifier: "ImagePreviewController") as! ImagePreviewController
                nextView.image = self.profileImage
                self.owner?.present(nextView, animated: false, completion: nil)
            }
        
            return cell
        }
    }

    @objc func toEditInfo(){
        
        (self.owner as! MainViewController).changeType = 3
        (self.owner as! MainViewController).infoTxtAlertView.isHidden = false
        (self.owner as! MainViewController).infoTxtView.text = self.cell1.infoTxtView.text
        
    }
    
    @objc func toEditName(){
        
        (self.owner as! MainViewController).changeType = 1
        (self.owner as! MainViewController).editAlertView.isHidden = false
        (self.owner as! MainViewController).n_cTextField.text = self.cell1.nameLabel.text
        
    }
    
    @objc func toEditCountry(cell : profile_firstCell){
        
        (self.owner as! MainViewController).changeType = 2
        (self.owner as! MainViewController).editAlertView.isHidden = false
        (self.owner as! MainViewController).n_cTextField.text = self.cell1.countryLabel.text
    }
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            myPickerController.allowsEditing = true
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func photoLibrary()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.allowsEditing = true
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        cell1.avatarImgView.image = image
        self.avatarImage = UIImageJPEGRepresentation(image, 0.8)
        dismiss(animated:true, completion: nil)
        changeAvatar()
        
    }
    
    func getMyProfile() {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        
        let params = [
            "start_index" : self.start_index,
            "user_id" : RichnessUserDefault.getUserID(),
            "id" : RichnessUserDefault.getUserID(),
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
                        print(item)
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
                        print(item["ranking"] as? String ?? "")
                        usermodel.text = item["text"] as? String ?? ""
                        usermodel.user_like = item["user_like"] as? String ?? ""
                        
                        self.profileArray.append(usermodel)
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
    
    func changeAvatar(){
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        
        let params = [
            "user_id" : RichnessUserDefault.getUserID(),
            "key" : key
            ]
        print(params)
        
        avatarImage = UIImageJPEGRepresentation(image, 0.6)
        
        print(params)
        
        RichnessAlamofire.showIndicator()
        RichnessAlamofire.shareInstance.upload(multipartFormData: { multipartFormData in
            
            if(self.avatarImage != nil)
            {
                multipartFormData.append(self.avatarImage!, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
            let contentDict = params
            for (key, value) in contentDict
            {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
            
        }, usingThreshold: RichnessAlamofire.multipartFormDataEncodingMemoryThreshold, to: CHANGEAVATA_URL, method: .post, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)
                    
                    switch response.result {
                    case .success(let JSON):
                        let res = JSON as! NSDictionary
                        
                        if(res.object(forKey: "#001") != nil){
                            
                            self.isAvatarChanged = true
                            self.tableView.reloadData()
                        }
                        
                        RichnessAlamofire.hideIndicator()
                    case .failure(let error):
                        print(error)
                    }
                    RichnessAlamofire.hideIndicator()
                }
            case .failure(let encodingError):
                print(encodingError)
                RichnessAlamofire.hideIndicator()
            }
        })
    }
    
    func like_unlike(like_type : Int, imageId : String, cell : profile_secondCell, index : Int) {
        
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
                        
                        self.profileArray[index].likes = String(Int(self.profileArray[index].likes)! + 1)
                        cell.likeLabel.text = self.profileArray[index].likes + " persons"
                    }
                    else{
                        self.profileArray[index].likes = String(Int(self.profileArray[index].likes)! - 1)
                        cell.likeLabel.text = self.profileArray[index].likes + " persons"
                        
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
                
                if (self?.profileArray.count)! % 20 != 0{
                    self?.tableView.removePullToRefresh(at: .bottom)
                    return
                }
                self?.getMyProfile()
                
            }
        }
    }
}
