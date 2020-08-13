//
//  ProfileVC.swift
//  Richness
//
//  Created by IOS3 on 07/02/19.
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
import Accelerate

class ExampleVC: PanelViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UpdateProfileDataDelegate
{
    func didGetData() {
        userDataArray.removeAll()
        self.profileTableView.reloadData()
        self.start_index = 0
        self.getMyProfileApi()
    }



    @IBOutlet weak var profileTableView: UITableView!
    // @IBOutlet weak var userCollectionView: UICollectionView!

    var start_index = 0
    var objc = SearchUser()
    var userDataArray : [User] = []
    var notificationArray : [User] = []
    var width = CGFloat()
    var cellTag = Int()
    var boolRecived = Bool()
   

    override func viewDidLoad()
    {
        super.viewDidLoad()


        width = (UIScreen.main.bounds.size.width - 2)/3
        //userProfileTableView.reloadData()
       getMyProfileApi()

        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.methodforRemoveReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier1"), object: nil)
        
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
    
    
    deinit {
        
    }

    // MARK:-
    //MARK:- Get Notification

    @objc func methodOfReceivedNotification(notification: Notification) {
        guard let cell = profileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileCell else {return}
        cell.notificationBtn.setImage(UIImage(named: "new_notification_icon"), for: .normal)
        
    }

    @objc func methodforRemoveReceivedNotification(notification: Notification) {
         guard let cell = profileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileCell else {return}
        cell.notificationBtn.setImage(UIImage(named: "notification_outline"), for: .normal)

    }

//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        let sessionManager = RichnessAlamofire()
//        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
//            dataTasks.forEach { $0.cancel() }
//            //self.timer.invalidate()
//        }
//
//    }


    // MARK:-
    //MARK:-  TableView DataSources

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 2

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row == 0 {

            return 360
            //return UITableViewAutomaticDimension
        }

        else {

            if (userDataArray.count)/3 != 0
            {
                let reminder: CGFloat = (CGFloat((userDataArray.count)/3 + 1))
                let height = reminder * (width + 60)

                return height + 40
            }

            else if userDataArray.count < 3
            {

                return width + 60 + 40
            }else {
                let reminder: CGFloat = CGFloat((userDataArray.count)/3)
                let height = reminder * (width + 60)
                return height + 40

            }
        }

    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {

            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell

            if userDataArray.count > 0 {
                cell.userWallImage.sd_setImage(with: URL(string : userDataArray[indexPath.row].image_profile))
                cell.userProfileImage.sd_setImage(with: URL(string : userDataArray[indexPath.row].image_profile))
                cell.userNameLabel.text = userDataArray[indexPath.row].name
                cell.userDescriptionLabel.text = userDataArray[indexPath.row].description
                cell.userLikesBtn.setTitle("\(userDataArray[0].total_like)" + " " + "Likes", for: .normal)
                cell.userFollowerBtn.setTitle("\(userDataArray[0].total_follower)" + " " + "Followers", for: .normal)
                cell.userFansBtn.setTitle("\(userDataArray[0].total_fans)" + " " + "Fans", for: .normal)
                
                
                cell.onCancelButtonTapped = {
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
                cell.onSearchButtonTapped = {
                    self.view.endEditing(true)
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
                    
                    vc.modalPresentationStyle = .overCurrentContext
                    let nav = UINavigationController(rootViewController: vc )
                    self.present(nav, animated:true, completion:nil)
                    
                }
                
                cell.onNotificationButtonTapped = {
                    //                if cell.notificationBtn.currentImage == UIImage(named: "new_notification_icon") {
                    let vc:NotificationViewController = self.storyboard?.instantiateViewController(withIdentifier:"NotificationViewController") as! NotificationViewController
                    
                    let nav = UINavigationController(rootViewController: vc)
                    
                    self.present(nav, animated:true, completion:nil)
                    // }
                }
                
                cell.onSettingButtonTapped = {
                    
                    
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
                
                cell.onFolllowerButtonTapped = {
                    self.cellTag = cell.userFollowerBtn.tag
                    
                    let vc:FollowersFansViewController = self.storyboard?.instantiateViewController(withIdentifier:"FollowersFansViewController") as! FollowersFansViewController
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.obj = self.userDataArray[0]
                    vc.getTag = self.cellTag
                    let nav = UINavigationController(rootViewController: vc)    
                    self.present(nav, animated:true, completion:nil)
                    
                    
                }
                
                cell.onFansButtonTapped = {
                    self.cellTag = cell.userFansBtn.tag
                    
                    let vc:FollowersFansViewController = self.storyboard?.instantiateViewController(withIdentifier:"FollowersFansViewController") as! FollowersFansViewController
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.obj = self.userDataArray[0]
                    vc.getTag = self.cellTag
                    let nav = UINavigationController(rootViewController: vc)
                    self.present(nav, animated:true, completion:nil)
                    
                    
                }

            }
            
            else {
                cell.userLikesBtn.setTitle("0 Likes", for: .normal)
                cell.userFollowerBtn.setTitle("0 Followers", for: .normal)
                cell.userFansBtn.setTitle("0 Fans", for: .normal)
                
                
                cell.onCancelButtonTapped = {
                    
                    self.dismiss(animated: true, completion: nil)
                }
                
                cell.onSearchButtonTapped = {
                    self.view.endEditing(true)
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
                    
                    vc.modalPresentationStyle = .overCurrentContext
                    let nav = UINavigationController(rootViewController: vc )
                    self.present(nav, animated:true, completion:nil)
                    
                }
                
                cell.onNotificationButtonTapped = {
                    //                if cell.notificationBtn.currentImage == UIImage(named: "new_notification_icon") {
                    let vc:NotificationViewController = self.storyboard?.instantiateViewController(withIdentifier:"NotificationViewController") as! NotificationViewController
                    self.present(vc, animated:true, completion:nil)
                    // }
                }
                
                cell.onSettingButtonTapped = {
                    
                    
                    let vc:ProfileSettingViewController = self.storyboard?.instantiateViewController(withIdentifier:"ProfileSettingViewController") as! ProfileSettingViewController
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.delegate = self
                    self.present(vc, animated:true, completion:nil)
                    
                    
                    
                }
                
                
                
                
                cell.onFolllowerButtonTapped = {
//                    self.cellTag = cell.userFollowerBtn.tag
//
//                    let vc:FollowersFansViewController = self.storyboard?.instantiateViewController(withIdentifier:"FollowersFansViewController") as! FollowersFansViewController
//                    vc.modalPresentationStyle = .overCurrentContext
//                    vc.obj = self.userDataArray[0]
//                    vc.getTag = self.cellTag
//                    self.present(vc, animated:true, completion:nil)
                    
                    
                }
                
                cell.onFansButtonTapped = {
//                    self.cellTag = cell.userFansBtn.tag
//
//                    let vc:FollowersFansViewController = self.storyboard?.instantiateViewController(withIdentifier:"FollowersFansViewController") as! FollowersFansViewController
//                    vc.modalPresentationStyle = .overCurrentContext
//                    vc.obj = self.userDataArray[0]
//                    vc.getTag = self.cellTag
//                    self.present(vc, animated:true, completion:nil)
                    
                    
                }
            }

            if boolRecived == true {
               cell.cancelBtn.isHidden = false
            }

            else {
                cell.cancelBtn.isHidden = true
            }

//            cell.onCancelButtonTapped = {
//
//                self.dismiss(animated: true, completion: nil)
//            }
//
//            cell.onSearchButtonTapped = {
//                self.view.endEditing(true)
//
//
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
//
//                vc.modalPresentationStyle = .overCurrentContext
//                let nav = UINavigationController(rootViewController: vc )
//                self.present(nav, animated:true, completion:nil)
//
//            }
//
//            cell.onNotificationButtonTapped = {
////                if cell.notificationBtn.currentImage == UIImage(named: "new_notification_icon") {
//                    let vc:NotificationViewController = self.storyboard?.instantiateViewController(withIdentifier:"NotificationViewController") as! NotificationViewController
//                    self.present(vc, animated:true, completion:nil)
//               // }
//            }
//
//            cell.onSettingButtonTapped = {
//
//
//                let vc:ProfileSettingViewController = self.storyboard?.instantiateViewController(withIdentifier:"ProfileSettingViewController") as! ProfileSettingViewController
//                vc.modalPresentationStyle = .overCurrentContext
//                vc.delegate = self
//                self.present(vc, animated:true, completion:nil)
//
//
//
//            }
//
//            cell.onFolllowerButtonTapped = {
//                self.cellTag = cell.userFollowerBtn.tag
//
//                let vc:FollowersFansViewController = self.storyboard?.instantiateViewController(withIdentifier:"FollowersFansViewController") as! FollowersFansViewController
//                vc.modalPresentationStyle = .overCurrentContext
//                vc.obj = self.userDataArray[0]
//                vc.getTag = self.cellTag
//                self.present(vc, animated:true, completion:nil)
//
//
//            }
//
//            cell.onFansButtonTapped = {
//                self.cellTag = cell.userFansBtn.tag
//
//                let vc:FollowersFansViewController = self.storyboard?.instantiateViewController(withIdentifier:"FollowersFansViewController") as! FollowersFansViewController
//                vc.modalPresentationStyle = .overCurrentContext
//                vc.obj = self.userDataArray[0]
//                vc.getTag = self.cellTag
//                self.present(vc, animated:true, completion:nil)
//
//
//            }

                return cell



        }

        else {

            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDataCell", for: indexPath) as! ProfileDataCell
//            if userDataArray.count > 0
//            {
//
//                cell.userLikesBtn.setTitle("\(userDataArray[0].total_like)" + " " + "Likes", for: .normal)
//                cell.userFollowerBtn.setTitle("\(userDataArray[0].total_follower)" + " " + "Followers", for: .normal)
//                cell.userFansBtn.setTitle("\(userDataArray[0].total_fans)" + " " + "Fans", for: .normal)
//            }
//
//            else {
//                cell.userLikesBtn.setTitle("0 Likes", for: .normal)
//                cell.userFollowerBtn.setTitle("0 Followers", for: .normal)
//                cell.userFansBtn.setTitle("0 Fans", for: .normal)
//            }


            DispatchQueue.main.async {[weak self] in
              cell.userDataCollectionView.reloadData()
            }


//            cell.onFolllowerButtonTapped = {
//                self.cellTag = cell.userFollowerBtn.tag
//
//                let vc:FollowersFansViewController = self.storyboard?.instantiateViewController(withIdentifier:"FollowersFansViewController") as! FollowersFansViewController
//                vc.modalPresentationStyle = .overCurrentContext
//                vc.obj = self.userDataArray[0]
//                vc.getTag = self.cellTag
//                self.present(vc, animated:true, completion:nil)
//
//
//            }
//
//            cell.onFansButtonTapped = {
//                self.cellTag = cell.userFansBtn.tag
//
//                let vc:FollowersFansViewController = self.storyboard?.instantiateViewController(withIdentifier:"FollowersFansViewController") as! FollowersFansViewController
//                vc.modalPresentationStyle = .overCurrentContext
//                vc.obj = self.userDataArray[0]
//                vc.getTag = self.cellTag
//                self.present(vc, animated:true, completion:nil)
//
//
//            }

            return cell
        }
    }


    // MARK:-
    //MARK:-  CollectionView DataSources

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {


        return CGSize(width:width, height: width + 60)


    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return userDataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionCell", for: indexPath) as! ProfileCollectionCell
        cell.imageView.image = nil
        if  userDataArray[indexPath.row].type == "0" {
            cell.videoView.isHidden = true
            cell.playVideoImage.isHidden = true
            cell.imageView.isHidden = false
            
           
            ProjectManager.shared.getImageFromSDWebimage(urlStr:self.userDataArray[indexPath.row].image) { (image) in
                  cell.imageView.image = image
            }
            
            
//            if self.userDataArray[indexPath.row].savedImage != nil {
//                cell.imageView.image =  self.userDataArray[indexPath.row].savedImage
//
//            }
//            else  {
//
//                DispatchQueue.global(qos: .background).async {
//                    do {
//                        let data  = try Data(contentsOf:URL(string: self.userDataArray[indexPath.row].image)! )
//                        let img = UIImage(data:data )
//                        let scaledimg = img?.getResizedImage()
//                        self.userDataArray[indexPath.row].savedImage = scaledimg!
//
//                        DispatchQueue.main.async {
//                        cell.imageView.image = scaledimg!
//                        }
//
//                    }
//
//                    catch  {
//                        DispatchQueue.main.async {
//                            cell.imageView.image = nil
//
//                        }
//                    }
//                }
//
//
//            }
            
           
                
            

            
            
           

        }
            
            

        else if userDataArray[indexPath.row].type == "1" {

            cell.imageView.isHidden = false
            cell.playVideoImage.isHidden = false
            cell.videoView.isHidden = true

            //            do {
            //
            //                var err: NSError? = nil
            //                let asset = AVURLAsset(url: NSURL(fileURLWithPath: userDataArray[indexPath.row].image) as URL, options: nil)
            //                let imgGenerator = AVAssetImageGenerator(asset: asset)
            //
            //                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            //                let uiImage = UIImage(cgImage: cgImage)
            //                cell.imageView?.image = uiImage
            //
            //            }
            //
            //            catch{
            //
            //            }

            //let urlImage = URL(string: userDataArray[indexPath.row].image)
            //            let asset = AVAsset(url: urlImage!)
            //            let assetImageGenerator = AVAssetImageGenerator(asset: asset)
            //
            //            var time = asset.duration
            //            time.value = min(time.value, 2)
            //
            //            do {
            //                let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            //                let uiImage = UIImage(cgImage: imageRef)
            //                cell.imageView?.image = uiImage
            //            } catch {
            //                print("error")
            //
            //            } && userDataArray.count > 19
            if userDataArray[indexPath.row].savedImage == nil {
            if userDataArray[indexPath.row].image .hasPrefix("https") {
                ProjectManager.shared.getThumnailImageFromVideo(urlStr:  userDataArray[indexPath.row].image) { (image) in
                    if self.userDataArray.count > indexPath.row {
                        self.userDataArray[indexPath.row].savedImage = image

                    }
                      cell.imageView?.image = image
                }

            } else {
                 cell.imageView?.image = userDataArray[indexPath.row].savedImage

                }
//                DispatchQueue.global(qos: .background).async {
//
//                    print("index is:",  indexPath.row)
//                    let asset = AVAsset(url: URL(string: self.userDataArray[indexPath.row].image)!)
//                    let assetImgGenerate = AVAssetImageGenerator(asset: asset)
//                    assetImgGenerate.appliesPreferredTrackTransform = true
//                    //Can set this to improve performance if target size is known before hand
//                    //assetImgGenerate.maximumSize = CGSize(width,height)
//                    let time = CMTimeMakeWithSeconds(1.0, 600)
//                    do {
//                        let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
//                        if img != nil {
//                            let thumbnail = UIImage(cgImage: img)
//                            if  let data = thumbnail.jpeg(.lowest) {
//                            DispatchQueue.main.async(execute: {[weak self] in
//                                 guard let strongSelf = self else { return }
//                                cell.imageView?.image = UIImage(data: data)
//                            })
//                            }
//                        }
//
//                    } catch {
//                        print(error.localizedDescription)
//
//                    }
//
//                }
            }
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



        //        let cell = tableview.dequeueReusableCell(withReuseIdentifier: "UserDataCell", for: indexPath) as! UserDataCell
        //        if indexPath.row == userDataArray.count - 1
        //        {
        //            self.getMyProfileApi(cell: cell)
        //        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let vc:ProfileGalleryViewController = self.storyboard?.instantiateViewController(withIdentifier:"ProfileGalleryViewController") as! ProfileGalleryViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.cellIndex = indexPath.row
        vc.homeArray = userDataArray
        vc.start_index = start_index
        vc.user_ID = userDataArray[indexPath.row].id_user
        self.present(vc, animated:true, completion:nil)

    }




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
        if self.start_index == 0{
            showLoader = true
        }
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
                       self.profileTableView.reloadData()
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
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
         return UIImageJPEGRepresentation(self, jpegQuality.rawValue)
    }
}
extension UIImage {
    
    
    func getResizedImage() -> UIImage {
        
        let cgImage = self.cgImage
        
        // create a source buffer
        var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil,
                                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                                          version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
        var sourceBuffer = vImage_Buffer()
        defer {
            sourceBuffer.data.deallocate()
            //sourceBuffer.data.dealloc(Int(sourceBuffer.height) * Int(sourceBuffer.height) * 4)
        }
        
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage!, numericCast(kvImageNoFlags))
        guard error == kvImageNoError else { return UIImage() }
        
        // create a destination buffer
        let scale = UIScreen.main.scale
        let destWidth = Int(self.size.width * 0.5 * scale)
        let destHeight = Int(self.size.height * 0.5 * scale)
        let bytesPerPixel = cgImage?.bitsPerPixel //CGImageGetBitsPerPixel(self.cgImage!) / 8
        let destBytesPerRow = destWidth * bytesPerPixel!
        let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
        defer {
            destData.deallocate(capacity: destHeight * destBytesPerRow)
        }
        var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
        
        // scale the image
        error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return UIImage() }
        
        // create a CGImage from vImage_Buffer
        let destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
        guard error == kvImageNoError else { return UIImage() }
        
        // create a UIImage
        let scaledImage = destCGImage.flatMap { UIImage(cgImage: $0, scale: 0.0, orientation: self.imageOrientation) }
        return scaledImage ?? UIImage()
       
        

    }
}
