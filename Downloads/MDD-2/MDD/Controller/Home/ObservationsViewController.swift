//
//  ObservationsViewController.swift
//  MDD
//
//  Created by iOS6 on 26/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import AssetsPickerViewController
import Photos
import AssetsLibrary
import GSImageViewerController

class ObservationsViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var observationCollectionView: UICollectionView!
    @IBOutlet weak var msgLabel: UILabel!
    
    var uplpdedFile:UIImage?
    var fileName = String()
    var objc = CategoryObjectModel()
    var galleryArray = [CategoryObjectModel]()
    var check = false
    var sizeGradient: CGFloat?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

       // observationGalleryApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if check == false {
            observationGalleryApi()
        }
        
    }

    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
  
    }
    
    // MARK:-
    //MARK:-  CollectionView DataSources
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: UIScreen.main.bounds.size.width, height:520 ) : CGSize(width: UIScreen.main.bounds.size.width, height:360 )
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as! ObservationsCollectionReusableView
            
            var height = CGFloat()
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                height = 55
            }
            
            else {
                
                height = 35
            }
            
            headerView.uploadFileBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: height/2)
            headerView.uploadFileBtn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            headerView.uploadFileBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            headerView.chooseFileBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: headerView.chooseFileBtn.frame.size.height/2)
            headerView.chooseFileBtn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            headerView.chooseFileBtn.setTitleColor(#colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), for: .normal)
            
            headerView.onUploadButtonTapped = {
                
                let alertController = UIAlertController()
                let cameraAction =  UIAlertAction(title:"Camera", style:.default) { (action) in
                    self.camera()
                }
                let galleryAction = UIAlertAction(title:"Gallery", style:.default) { (action) in
                    self.photoLibrary()
                }
                let cancelAction = UIAlertAction(title:"Cancel", style: .default, handler: nil)
                alertController.addAction(cameraAction)
                alertController.addAction(galleryAction)
                alertController.addAction(cancelAction)
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    
                    alertController.popoverPresentationController?.sourceView = self.view
                    alertController.popoverPresentationController?.sourceRect = CGRect(x: headerView.uploadFileBtn.frame.origin.x, y: headerView.uploadFileBtn.frame.origin.y + headerView.uploadFileBtn.frame.size.height + 40, width: headerView.uploadFileBtn.frame.size.width, height: headerView.uploadFileBtn.frame.size.height)
                }
                
                UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)

            }
           
            headerView.onSubmitButtonTapped = {
               
                let caption:String = (headerView.enterCaptionTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
                self.observationUploadApi(caption: caption)
                
            }
            
             return headerView
            
            
        case UICollectionView.elementKindSectionFooter:
            
            return  UICollectionReusableView()
            
        default:
            
            assert(false, "Unexpected element kind")
        }
        return  UICollectionReusableView()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        
        var size = CGFloat()
        if UIDevice.current.userInterfaceIdiom == .pad {
            size = (observationCollectionView.frame.size.width - (space + flowayout!.minimumInteritemSpacing ?? 0.0)) / 3.0
            sizeGradient = size
        }
        else {
        size = (observationCollectionView.frame.size.width - space) / 2.0
            sizeGradient = size
            
        }
        return CGSize(width: size, height: size - 30)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       return galleryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ObservationsCollectionViewCell", for: indexPath) as! ObservationsCollectionViewCell
        
        cell.CellLabel.text = galleryArray[indexPath.row].imageCaption
        cell.cellImageView.sd_setImage(with: URL(string :galleryArray[indexPath.row].image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
        }
        
        let view = UIView(frame: CGRect(x:0, y:0, width: sizeGradient!, height: sizeGradient! - 30))
        
        let gradient = CAGradientLayer()
        
        gradient.frame = view.frame
        
        gradient.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        
        //    gradient.locations = [0.0, 1.0]
        
        view.layer.insertSublayer(gradient, at: 0)
        
        cell.cellImageView.addSubview(view)
        
        cell.cellImageView.bringSubviewToFront(view)

        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = observationCollectionView.cellForItem(at: indexPath) as! ObservationsCollectionViewCell
        
        saveStatusApi(title: galleryArray[indexPath.row].imageCaption, link: galleryArray[indexPath.row].image)
        
        if cell.cellImageView.image != nil {

        let imageInfo   = GSImageInfo(image: cell.cellImageView.image!, imageMode: .aspectFit)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo)
        self.present(imageViewer, animated: true, completion: nil) //(imageViewer, animated: true)
//
        }

    }
    
    
    // MARK:-
    //MARK:- ImagePicker Methods
  
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        
        let cameraImage =  info[.originalImage] as? UIImage //image captured from camera
        uplpdedFile = cameraImage?.fixOrientation()
       // uplpdedFile = info[.originalImage] as? UIImage
        
    
        dismiss(animated:true, completion: {
            
            
            if let referenceUrl = info[UIImagePickerController.InfoKey.referenceURL] as? NSURL {
                
                ALAssetsLibrary().asset(for: referenceUrl as URL, resultBlock: { asset in

                    let headerView =        self.observationCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0) ) as? ObservationsCollectionReusableView

                    if (asset != nil) {
                        
                         self.fileName = asset!.defaultRepresentation().filename()
                        
                        headerView?.chooseFileBtn.setTitle(self.fileName, for: .normal)
                        
                    }
                        
                    else {
                        
                         let ext = referenceUrl.pathExtension
                         self.fileName =  "\(Date().ticks).\( ext!)"
                        
                        headerView?.chooseFileBtn.setTitle(self.fileName, for: .normal)
                        
                    }
                 
                }, failureBlock: nil)
            }
            
            
            else {
                
                self.fileName =  "\(Date().ticks).jpeg"
                
                let headerView =        self.observationCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0) ) as? ObservationsCollectionReusableView
                
                headerView?.chooseFileBtn.setTitle(self.fileName, for: .normal)
                
                
            }
        })
       
    }
    
 
    // MARK:-
    //MARK:-  API Methods
    
    func observationUploadApi(caption: String)
    {
        
        self.view.endEditing(true)
        let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.loggedInUserID)
        
        if userId is String  {
            
            let params = ["user_id":userId!, "cat_id": objc.cat_id, "photocaption":caption] as [String: Any]
            print(params)
            
            if Server.sharedInstance.isInternetAvailable()
            {
                
                if caption == "" && self.uplpdedFile == nil {
                    
                    Server.sharedInstance.showSnackBarAlert(desc: "Please upload file and enter caption.")
                    
                }
                    
                else if caption == "" {
                    
                    Server.sharedInstance.showSnackBarAlert(desc: "Please enter caption.")
                    
                    
                }
                
                else if self.uplpdedFile == nil {
                  
                    Server.sharedInstance.showSnackBarAlert(desc: "Please upload file.")

                    
                }
                
                else {
                
                DispatchQueue.main.async {
                    
                    Server.sharedInstance.showLoader()
                    
                }
                
                let data :  Data = self.uplpdedFile!.jpegData(compressionQuality: 0.4)!
                    Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                        multipartFormData.append(data, withName: "file", fileName: "\(Date().ticks).jpeg", mimeType:  "image/jpeg")
                        
                        
                        
                    for (key, value) in params {
                    // multipartFormData.append(((value as? String)!.data(using: .utf8))!, withName: key)
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                
                    }
                    }, to:K_Base_Url+K_Observation_Url, headers:nil)
                    { (result) in
                        
                        switch result {
   
                        case .success(let upload, _, _):
                            
                            
                                upload.responseJSON { response in
                                   
                                    Server.sharedInstance.stopLoader()

                                    if response.result.isFailure {
                                      

                                    }
                                    else {
                                        
                                       let json = response.result.value as? [String: Any]
                                        let status = Server.sharedInstance.checkResponseForString(jsonKey:"success", dict: json! as NSDictionary)
                                        let msg = Server.sharedInstance.checkResponseForString(jsonKey:"message", dict: json! as NSDictionary)
                                        if status.boolValue {
                                            
                                            self.uplpdedFile = nil
                                            let headerView =        self.observationCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0) ) as? ObservationsCollectionReusableView
                                            
                                            headerView?.chooseFileBtn.setTitle("Choose File", for: .normal)
                                            headerView?.enterCaptionTextField.text = ""
                                            Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                                            
                                        }
                                        
                                        else {
                                            
                                            DispatchQueue.main.async {
                                                Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                                                
                                            }
                                        }
                                        
                                    }
                               
                                }
                            
                            
                        case .failure(let _):
                            DispatchQueue.main.async {
                            
                               Server.sharedInstance.stopLoader()
                            }
                            
                            break
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
    
    func observationGalleryApi()
    {
        
        let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.loggedInUserID)
        
        if userId is String  {
            
            let params = ["user_id":userId!, "cat_id": objc.cat_id] as [String: Any]
            print(params)
            
            if Server.sharedInstance.isInternetAvailable()
            {
                
                DispatchQueue.main.async {
                
                    Server.sharedInstance.showLoader()
               
               }
                
                
                Alamofire.request(K_Base_Url+K_ObservationGallery_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
                    .responseJSON { response in
                        
                        Server.sharedInstance.stopLoader()
                        self.check = true
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
 
                            if let response = json["repsonse"] as? NSArray , response.count > 0 {
                                
                                self.msgLabel.isHidden = true
                                let responseArray = Server.sharedInstance.GetObservationGalleryListObjects(array: response)
                                
                                self.galleryArray.append(contentsOf: responseArray)
                                
                                self.observationCollectionView.reloadData()
                            }
                            
                            else {
                                
                                Server.sharedInstance.showSnackBarAlert(desc:msg as String)
  
                            }
  
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
    
    func saveStatusApi(title: String,link: String)
    {
   
        let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.loggedInUserID)
        
        if userId is String  {
            
            let params = ["userid":userId!, "catastropheid": objc.cat_id, "parentcategoryid": "Gallery", "title":title, "linkid": link, "source":"ios", "briefing": "1"] as [String: Any]
            print(params)
            
            if Server.sharedInstance.isInternetAvailable()
            {
           
                
                Alamofire.request(K_Base_Url+K_SaveStatus_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
                    .responseJSON { response in
                        
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
                        let status = Server.sharedInstance.checkResponseForString(jsonKey:"status", dict: json as NSDictionary)
                        let msg = Server.sharedInstance.checkResponseForString(jsonKey:"message", dict: json as NSDictionary)
                        if status == "success" {
                            
                        }
                        else {
                            
                        }
                }
                
            }
                
            else {
                DispatchQueue.main.async(execute: {
                    
                    Server.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
                })
            }
            
            
        } else {
            
            //              Server.sharedInstance.showAlertwithTitle(title:"", desc: "UserId is Empty", vc:UIApplication.topViewController()!)
            
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
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}
