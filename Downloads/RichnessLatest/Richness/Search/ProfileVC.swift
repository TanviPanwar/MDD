//
//  ExampleViewController.swift
//  Richness
//
//  Created by IOS3 on 12/02/19.
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


class ProfileVC:PanelViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UpdateProfileDataDelegate
{

    func didGetData() {
        userDataArray.removeAll()
        self.profileCollectionView.reloadData()
        self.start_index = 0
        self.getMyProfileApi()
    }

    @IBOutlet weak var contentView: UIView!

   
    @IBOutlet weak var profileCollectionView: UICollectionView!

    var start_index = 0
    var objc = SearchUser()
    var userDataArray : [User] = []
    var width = CGFloat()
    var cellTag = Int()
    var boolRecived = Bool()
    var profileObj = User()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        width = (UIScreen.main.bounds.size.width - 2)/3
        //userProfileTableView.reloadData()
        getMyProfileApi()
        
       
        
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.isHidden = true
        }

        // Do any additional setup after loading the view.
    }

    deinit {

    }

    
    
  
    // MARK:-
    //MARK:-  IB Actions

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

    @IBAction func notificationBtnAction(_ sender: Any) {
        let vc:NotificationViewController = self.storyboard?.instantiateViewController(withIdentifier:"NotificationViewController") as! NotificationViewController
        
        let nav = UINavigationController(rootViewController: vc)
        
        self.present(nav, animated:true, completion:nil)
    }

    @IBAction func settingBtnAction(_ sender: Any) {
        let vc:ProfileSettingViewController = self.storyboard?.instantiateViewController(withIdentifier:"ProfileSettingViewController") as! ProfileSettingViewController
        // vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        // self.present(vc, animated:true, completion:nil)
        
        if self.parent is MainViewController {
            
            DispatchQueue.main.async {
                self.parent?.navigationController?.pushViewController(vc, animated: true)
            }
        }
            
        else {
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
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
    //MARK:-  Methods

    func setUI() {

      
    }

    // MARK:-
    //MARK:-  CollectionView DataSources

    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height:360 )
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as! ProfileHeaderView
            
            if boolRecived {
                 headerView.cancelBtn.isHidden = false
            }
                
            else {
                 headerView.cancelBtn.isHidden = true
            }
            
             headerView.userProfileImage.layer.borderWidth = 1
             headerView.userProfileImage.layer.masksToBounds = false
             headerView.userProfileImage.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.737254902, blue: 0.5843137255, alpha: 1)
             headerView.userProfileImage.layer.cornerRadius =  headerView.userProfileImage.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
             headerView.userProfileImage.clipsToBounds = true
                headerView.userProfileImage?.sd_setImage(with: URL(string :profileObj.image_profile), placeholderImage:UIImage(named:"img_placeholder"), options:[], completed: nil)
                
            headerView.userWallImage.sd_setImage(with: URL(string : profileObj.image_profile))
//            headerView.userProfileImage.sd_setImage(with: URL(string : userDataArray[indexPath.row].image_profile))
             headerView.userNameLabel.text = profileObj.name
             headerView.userDescriptionLabel.text = profileObj.description
             headerView.userLikesBtn.setTitle("\(profileObj.total_like)" + " " + "Likes", for: .normal)
             headerView.userFollowerBtn.setTitle("\(profileObj.total_follower)" + " " + "Followers", for: .normal)
             headerView.userFansBtn.setTitle("\(profileObj.total_fans)" + " " + "Fans", for: .normal)
           
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
                self.getMyProfileApi()
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




    // MARK:-
    //MARK:-  Api Methods
    // MARK:-
    //MARK:-  Api Methods
    
    
    func getMyProfileApi() {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        let params = [ "start_index" : self.start_index,
                       "user_id" : RichnessUserDefault.getUserID(),
                       "id" :  RichnessUserDefault.getUserID(),
                       "key" : key
            ] as [String : Any]
        print(params)
        
        //start_index += 1
        var showLoader = Bool()
//        if self.start_index == 0{
            showLoader = true
//        }
        RichnessAlamofire.POST(GETTIMELINE_URL, parameters: params as [String : AnyObject],showLoading: showLoader,showSuccess: false,showError: false
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
                            userDatamodel.user_like = item["user_like"] as? String ?? ""
                            userDatamodel.total_fans = item["total_fans"] as? Int ?? 0
                            userDatamodel.total_like = item["total_like"] as? Int ?? 0
                            userDatamodel.total_follower = item["total_follower"] as? Int ?? 0
                            userDatamodel.type = item["type"] as? String ?? ""
                            // userDatamodel.id = item["id"] as? String ?? ""
                           self.profileObj = userDatamodel
                            if !userDatamodel.image.isEmpty{
                                
                                self.userDataArray.append(userDatamodel)
                            }
                            
                        }
                        
                        self.start_index += 1
                    } else {
                        self.start_index = -1
                        
                        
                    }
                    // if self.start_index == 0{
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
                    self.getMyProfileApi()
                } else {
                    if (error == "#997") {
                        self.showError(errMsg: user_error_unknown)
                    }
                    else {
                        //self.showError(errMsg: error_on_server)
                    }
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

extension ProfileVC: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard let data = NSData(contentsOf: outputFileURL as URL) else {
            return
    }

//    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
//        guard let data = NSData(contentsOf: outputFileURL as URL) else {
//            return
//        }

        print("File size before compression: \(Double(data.length / 1048576)) mb")
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".m4v")
        compressVideo(inputURL: outputFileURL as URL, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }

            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }

                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
            case .failed:
                break
            case .cancelled:
                break
            }
        }
    }

    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)

            return
        }

        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}
let userImageCache = NSCache<NSString, UIImage>()
let imageCache = NSCache<AnyObject, AnyObject>()
var imageURLString: String?


extension UIImageView {
    public func imageFromVideoServerURL(urlString: String, completion:@escaping (UIImage?) -> Void) {
        imageURLString = urlString
        self.image = nil
        if let url = URL(string: urlString) {
            
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil{
                    
                }
                
                DispatchQueue.main.async(execute: {
                    
                    
                    ProjectManager.shared.getThumnailImageFromVideo(urlStr: urlString) { (img) in
                        if img != nil {
                        completion(img)
                        // calls when scrolling
                          
                        } else {
                             completion(nil)
                        }
                    }
                    
                })
            }) .resume()
        }
    }
    public func imageFromServerURL(urlString: String, completion:@escaping (UIImage?) -> Void) {
        imageURLString = urlString
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil{
                
                }
                DispatchQueue.main.async(execute: {
                    if data != nil {
                    
                    if let imgaeToCache = UIImage(data: data!){
                          let width = (UIScreen.main.bounds.size.width - 2)/3
                        let cacheImage = imgaeToCache.resizeImageWith(newSize: CGSize(width: width, height: width + 60))
                        completion(cacheImage)
                       
                    
                    } else {
                          completion(nil)
                        }
                    }
                })
            }) .resume()
        }
    }
    
//    func downloadImage(from imgURL: String!) {
//        let url = URLRequest(url: URL(string: imgURL)!)
//        
//        // set initial image to nil so it doesn't use the image from a reused cell
//        
//        // check if the image is already in the cache
//        if let imageToCache = imageCache.object(forKey: imgURL! as AnyObject) as? UIImage {
//            self.image = imageToCache
//            return
//        }
//        
//        // download the image asynchronously
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if error != nil {
//                // user an alert to display the error
//                if let topController = UIApplication.topViewController() {
//                 
//                }
//                return
//            }
//            
//            DispatchQueue.main.async {
//                let imageToCache = UIImage(data: data!)
//                imageCache.setObject(imageToCache!, forKey: imgURL! as AnyObject)
//                self.image = imageToCache
//            }
//        }
//        task.resume()
//    }
    
    func downloadUserImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        // set initial image to nil so it doesn't use the image from a reused cell
        image = nil
        
        // check if the image is already in the cache
        if let imageToCache = userImageCache.object(forKey: imgURL! as NSString) {
            self.image = imageToCache
            return
        }
        
        // download the image asynchronously
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                // user an alert to display the error
                if let topController = UIApplication.topViewController() {
                   
                }
                return
            }
            
            DispatchQueue.main.async {
                // create UIImage
                let imageToCache = UIImage(data: data!)
                // add image to cache
                userImageCache.setObject(imageToCache!, forKey: imgURL! as NSString)
                self.image = imageToCache
            }
        }
        task.resume()
    }
}
