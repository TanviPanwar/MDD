//
//  MainViewController.swift
//  Richness
//
//  Created by Sobura on 6/6/18.
//  Copyright © 2018 Sobura. All rights reserved.
//

import Foundation
import UIKit
import CoreML
import AVKit
//import YPImagePicker
import AVFoundation
import Photos

class MainViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var n_cTextField: UITextField!
    
    @IBOutlet weak var getRichButton: GradientButton!
    @IBOutlet weak var infoTxtView: UITextView!
    @IBOutlet var tabbarView: UIView!
    @IBOutlet var infoTxtAlertView: UIView!
    @IBOutlet var getRichAlertView: UIView!
    @IBOutlet var editAlertView: UIView!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var reportAlertView: UIView!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var userInfoAlertView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var tabButton: [UIButton]!
    @IBOutlet weak var lblRanking: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var notifyDotView: UIView!

    
    var currentSubview: UIViewController? = nil
    var idimage = ""
    var deletedImgIndex = 0
    var profileView : ProfileViewController!
    var cameraView : CameraViewController!
    var image = UIImage()
    var changeType = 0
    var checked_user = User()

    var selectedLoggingLevel: LoggerMessageType = .none
    var depthView: UIImageView?

    var selectedItems = [YPMediaItem]()

    let selectedImageV = UIImageView()
    let pickButton = UIButton()
    let resultsButton = UIButton()
    var myTimer = Timer()
    var buttonTag = Int()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        getRichButton.layer.masksToBounds = true
        
        reportAlertView.frame = self.view.frame
        userInfoAlertView.frame = self.view.frame
        editAlertView.frame = self.view.frame
        infoTxtAlertView.frame = self.view.frame
        getRichAlertView.frame = self.view.frame
        
        self.view.addSubview(reportAlertView)
        self.view.addSubview(userInfoAlertView)
        self.view.addSubview(editAlertView)
        self.view.addSubview(infoTxtAlertView)
        self.view.addSubview(getRichAlertView)
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(exitAlert))
        tap.numberOfTapsRequired = 1
        self.userInfoAlertView.addGestureRecognizer(tap)
        
        let infoAlertTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(exitInfoAlert))
        infoAlertTap.numberOfTapsRequired = 1
        self.infoTxtAlertView.addGestureRecognizer(infoAlertTap)
        
        let homeAlertTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(exitHomeAlert))
        homeAlertTap.numberOfTapsRequired = 1
        self.reportAlertView.addGestureRecognizer(homeAlertTap)
        
        let editAlertTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(exitEditAlert))
        editAlertTap.numberOfTapsRequired = 1
        self.editAlertView.addGestureRecognizer(editAlertTap)
        
        tabButton[0].setBackgroundImage(UIImage(named: "icon_home_click"), for: .normal)
//        let nextView: PanelViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
         let nextView: PanelViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewCollectionViewController") as! NewCollectionViewController
        loadNamedView(nextView: nextView)

        avatarImgView.roundImgView(borderColor: UIColor(displayP3Red: 254/255, green: 207/255, blue: 133/255, alpha: 1.0))

        tabbarView.addBlackGradientLayer(frame:CGRect(x:0, y: 0, width: UIScreen.main.bounds.size.width, height: tabbarView.frame.height), colors: [UIColor.black.withAlphaComponent(0.0), UIColor.black.withAlphaComponent(0.1) , UIColor.black.withAlphaComponent(0.2),UIColor.black.withAlphaComponent(0.3),UIColor.black.withAlphaComponent(0.4), UIColor.black.withAlphaComponent(0.5),UIColor.black.withAlphaComponent(0.6), UIColor.black.withAlphaComponent(0.7),UIColor.black.withAlphaComponent(0.8),UIColor.black.withAlphaComponent(0.9), UIColor.black.withAlphaComponent(1)])

        notifyDotView.isHidden = true
        notifyDotView.layer.borderWidth = 1
        notifyDotView.layer.masksToBounds = false
        notifyDotView.layer.cornerRadius = notifyDotView.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        notifyDotView.clipsToBounds = true

        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)

         NotificationCenter.default.addObserver(self, selector: #selector(self.methodforRemoveReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier1"), object: nil)
        
//        if self.chil  {
//            self.notifyDotView.isHidden = true
//        }
        
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.isHidden = true
        }
    



    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.isHidden = true
        }
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true, block: { (timer) in
            print("That took 30 seconds")
            DispatchQueue.global(qos: .background).async {
                self.getNotificationApi()
            }
        })
    }

    // MARK:-
    //MARK:- Get Notification

    @objc func methodOfReceivedNotification(notification: Notification) {
        
        if buttonTag != 1 {
            notifyDotView.isHidden = false
        }
       

    }

    @objc func methodforRemoveReceivedNotification(notification: Notification) {
        notifyDotView.isHidden = true

    }

    // MARK: -
    // MARK:- Methods

    @objc func exitInfoAlert() {
        
        self.infoTxtAlertView.isHidden = true
    }
    
    @objc func exitEditAlert() {
        
        self.editAlertView.isHidden = true
    }
    
    @objc func exitAlert() {
        
        self.userInfoAlertView.isHidden = true
    }
    
    @objc func exitHomeAlert() {
        
        self.reportAlertView.isHidden = true
    }


    // MARK: -
    // MARK:- IB Actions

    @IBAction func onTapReport(_ sender: UIButton) {
        
        if(sender.titleLabel?.text == "Delete Image"){
            self.deleteImage()
        }
        else{
            reportImage()
        }
    }

    @IBAction func onTapTab(_ sender: UIButton) {
        buttonTag = sender.tag
        tabButton[0].setBackgroundImage(UIImage(named: "icon_home"), for: .normal)
        tabButton[1].setBackgroundImage(UIImage(named: "icon_profile"), for: .normal)
        tabButton[2].setBackgroundImage(UIImage(named: "icon_camera_click"), for: .normal)
        tabButton[3].setBackgroundImage(UIImage(named: "icon_ranking"), for: .normal)
        tabButton[4].setBackgroundImage(UIImage(named: "icon_buy"), for: .normal)
        
        switch sender.tag {
        case 0:
            tabButton[sender.tag].setBackgroundImage(UIImage(named: "icon_home_click"), for: .normal)
            
            //sender.isUserInteractionEnabled = false

//
//            let nextView: PanelViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//            loadNamedView(nextView: nextView)

            let nextView: PanelViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewCollectionViewController") as! NewCollectionViewController
                    loadNamedView(nextView: nextView)


            break
        case 1:
            tabButton[sender.tag].setBackgroundImage(UIImage(named: "icon_profile_click"), for: .normal)
            let nextView: PanelViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC

// let nextView: PanelViewController = self.storyboard?.instantiateViewController(withIdentifier: "ExampleViewController") as! ProfileVC
            sender.preventRepeatedPresses()
            loadNamedView(nextView: nextView)
            self.notifyDotView.isHidden = true

            break
        case 2:
            tabButton[sender.tag].setBackgroundImage(UIImage(named: "icon_camera_click"), for: .normal)
            if RichnessUserDefault.getUserRanking() != "0"{
             //self.camera()
               // self.openCamera()
                self.showPicker()

                
            }
            else{
                self.getRichAlertView.isHidden = false
            }
            break
        case 3:
            tabButton[sender.tag].setBackgroundImage(UIImage(named: "icon_ranking_click"), for: .normal)
            let nextView: PanelViewController = self.storyboard?.instantiateViewController(withIdentifier: "LankingViewController") as! LankingViewController
            loadNamedView(nextView: nextView)
            break
        case 4:
            tabButton[sender.tag].setBackgroundImage(UIImage(named: "icon_buy_click"), for: .normal)
            let nextView: PanelViewController = self.storyboard?.instantiateViewController(withIdentifier: "DiamondViewController") as! DiamondViewController
            loadNamedView(nextView: nextView)
            break
        default:
            break
        }
    }

    // MARK: -
    // MARK:- API Methods

    func getNotificationApi() {

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        let params = ["user_id" : RichnessUserDefault.getUserID(),
                      "key" : key
            ] as [String : Any]
        print(params)

        RichnessAlamofire.notificatonPost(ISNOTIFICATION_URL, parameters: params as [String : AnyObject],showLoading: false,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                print(responseObject)
                // self.tableView.endRefreshing(at: .bottom)
                if(responseObject.object(forKey: "result") != nil){
                    let result = responseObject.object(forKey: "result") as? String //as? [NSDictionary]
                    print(self.childViewControllers)
                    if self.buttonTag == 1{
                        self.notifyDotView.isHidden = true
                    }
                    print(result!)
                    if result == "1" {
                        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
                    }

                    else if result == "0" {
                        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier1"), object: nil)
                    }
                }

                else
                {
                    print("Result is nil")

                }
            }
            else
            {
                let error = responseObject.object(forKey: "error") as? String
                if (error == "#997") {
                  // self.showError(errMsg: user_error_unknown)
                }
                else {
                    //self.showError(errMsg: error_on_server)
                }
            }
        }
    }
    


    // MARK: - Configuration
    @objc
    func showPicker() {


        var config = YPImagePickerConfiguration()

        /* Uncomment and play around with the configuration 👨‍🔬 🚀 */

        /* Set this to true if you want to force the  library output to be a squared image. Defaults to false */
        //         config.library.onlySquare = true

        /* Set this to true if you want to force the camera output to be a squared image. Defaults to true */
         config.onlySquareImagesFromCamera = false

        /* Ex: cappedTo:1024 will make sure images from the library or the camera will be
         resized to fit in a 1024x1024 box. Defaults to original image size. */
        // config.targetImageSize = .cappedTo(size: 1024)

        /* Choose what media types are available in the library. Defaults to `.photo` */
        config.library.mediaType = .photoAndVideo

        /* Enables selecting the front camera by default, useful for avatars. Defaults to false */
        // config.usesFrontCamera = true

        /* Adds a Filter step in the photo taking process. Defaults to true */
        // config.showsFilters = false

        /* Manage filters by yourself */
        //        config.filters = [YPFilter(name: "Mono", coreImageFilterName: "CIPhotoEffectMono"),
        //                          YPFilter(name: "Normal", coreImageFilterName: "")]
        //        config.filters.remove(at: 1)
        //        config.filters.insert(YPFilter(name: "Blur", coreImageFilterName: "CIBoxBlur"), at: 1)

        /* Enables you to opt out from saving new (or old but filtered) images to the
         user's photo library. Defaults to true. */
        config.shouldSaveNewPicturesToAlbum = false

        /* Choose the videoCompression. Defaults to AVAssetExportPresetHighestQuality */
        config.video.compression = AVAssetExportPresetMediumQuality

        /* Defines the name of the album when saving pictures in the user's photo library.
         In general that would be your App name. Defaults to "DefaultYPImagePickerAlbumName" */
        // config.albumName = "ThisIsMyAlbum"

        /* Defines which screen is shown at launch. Video mode will only work if `showsVideo = true`.
         Default value is `.photo` */
        config.startOnScreen = .photo //.library

        /* Defines which screens are shown at launch, and their order.
         Default value is `[.library, .photo]` */
        config.screens = [.library, .photo, .video]

        /* Can forbid the items with very big height with this property */
        //        config.library.minWidthForItem = UIScreen.main.bounds.width * 0.8

        /* Defines the time limit for recording videos.
         Default is 30 seconds. */
        // config.video.recordingTimeLimit = 5.0

        /* Defines the time limit for videos from the library.
         Defaults to 60 seconds. */
        config.video.libraryTimeLimit = 500.0

        /* Adds a Crop step in the photo taking process, after filters. Defaults to .none */
        config.showsCrop = .rectangle(ratio: (16/9)) //(16/9)

        /* Defines the overlay view for the camera. Defaults to UIView(). */
        // let overlayView = UIView()
        // overlayView.backgroundColor = .red
        // overlayView.alpha = 0.3
        // config.overlayView = overlayView

        /* Customize wordings */
        config.wordings.libraryTitle = "Gallery"

        /* Defines if the status bar should be hidden when showing the picker. Default is true */
        config.hidesStatusBar = false

        /* Defines if the bottom bar should be hidden when showing the picker. Default is false */
        config.hidesBottomBar = false

        config.library.maxNumberOfItems = 1

        /* Disable scroll to change between mode */
        // config.isScrollToChangeModesEnabled = false
        //        config.library.minNumberOfItems = 2

        /* Skip selection gallery after multiple selections */
        // config.library.skipSelectionsGallery = true

        /* Here we use a per picker configuration. Configuration is always shared.
         That means than when you create one picker with configuration, than you can create other picker with just
         let picker = YPImagePicker() and the configuration will be the same as the first picker. */


        /* Only show library pictures from the last 3 days */
        //let threDaysTimeInterval: TimeInterval = 3 * 60 * 60 * 24
        //let fromDate = Date().addingTimeInterval(-threDaysTimeInterval)
        //let toDate = Date()
        //let options = PHFetchOptions()
        //options.predicate = NSPredicate(format: "creationDate > %@ && creationDate < %@", fromDate as CVarArg, toDate as CVarArg)
        //
        ////Just a way to set order
        //let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        //options.sortDescriptors = [sortDescriptor]
        //
        //config.library.options = options

        let picker = YPImagePicker(configuration: config)

        /* Change configuration directly */
        // YPImagePickerConfiguration.shared.wordings.libraryTitle = "Gallery2"


        /* Multiple media implementation */
        picker.didFinishPicking { [unowned picker] items, cancelled in

            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                return
            }
            _ = items.map { print("🧀 \($0)") }

            self.selectedItems = items
            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
                    self.selectedImageV.image = photo.image
                    picker.dismiss(animated: true, completion: nil)
                case .video(let video):
                    self.selectedImageV.image = video.thumbnail

                    let assetURL = video.url
                    let playerVC = AVPlayerViewController()
                    let player = AVPlayer(playerItem: AVPlayerItem(url:assetURL))
                    playerVC.player = player

                    picker.dismiss(animated: true, completion: { [weak self] in
                        self?.present(playerVC, animated: true, completion: nil)
                        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
                    })
                }
            }
        }

        /* Single Photo implementation. */
        // picker.didFinishPicking { [unowned picker] items, _ in
        //     self.selectedItems = items
        //     self.selectedImageV.image = items.singlePhoto?.image
        //     picker.dismiss(animated: true, completion: nil)
        // }

        /* Single Video implementation. */
        //picker.didFinishPicking { [unowned picker] items, cancelled in
        //    if cancelled { picker.dismiss(animated: true, completion: nil); return }
        //
        //    self.selectedItems = items
        //    self.selectedImageV.image = items.singleVideo?.thumbnail
        //
        //    let assetURL = items.singleVideo!.url
        //    let playerVC = AVPlayerViewController()
        //    let player = AVPlayer(playerItem: AVPlayerItem(url:assetURL))
        //    playerVC.player = player
        //
        //    picker.dismiss(animated: true, completion: { [weak self] in
        //        self?.present(playerVC, animated: true, completion: nil)
        //        print("😀 \(String(describing: self?.resolutionForLocalVideo(url: assetURL)!))")
        //    })
        //}

        present(picker, animated: true, completion: nil)
    }


    func openCamera()
    {

        LuminaViewController.loggingLevel = selectedLoggingLevel
        let camera = LuminaViewController()
        camera.delegate = self
        //camera.position
//        camera.position = self.frontCameraSwitch.isOn ? .front : .back
//        camera.recordsVideo = self.recordsVideoSwitch.isOn
//        camera.streamFrames = self.trackImagesSwitch.isOn
//        camera.textPrompt = self.showTextPromptViewSwitch.isOn ? "This is how to test the text prompt view" : ""
//        camera.trackMetadata = self.trackMetadataSwitch.isOn
//        camera.captureLivePhotos = self.capturesLivePhotosSwitch.isOn
//        camera.captureDepthData = self.capturesDepthDataSwitch.isOn
//        camera.streamDepthData = self.streamsDepthDataSwitch.isOn
//        camera.resolution = selectedResolution
//        camera.maxZoomScale = (self.maxZoomScaleLabel.text! as NSString).floatValue
//        camera.frameRate = Int(self.frameRateLabel.text!) ?? 30
//        if #available(iOS 11.0, *), self.useCoreMLModelSwitch.isOn {
//            camera.streamingModels = [LuminaModel(model: MobileNet().model, type: "MobileNet"), LuminaModel(model: SqueezeNet().model, type: "SqueezeNet")]
//        }
        present(camera, animated: true, completion: nil)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        image = info[UIImagePickerControllerEditedImage] as! UIImage
        let nextView: PanelViewController = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        loadNamedView(nextView: nextView)
        self.cameraView.ProfileImage = UIImageJPEGRepresentation(image, 0.8)
        self.cameraView.profileImgView.image = image
        
        dismiss(animated:true, completion: nil)
        
    }
    
    func prepView(_ view: PanelViewController)
    {
        if currentSubview != nil {
            
            self.currentSubview?.view.removeFromSuperview()
        }
        
        addChildViewController(view)
        
        view.view.frame = CGRect(x: 0, y: containerView.frame.origin.y, width: containerView.frame.size.width, height: containerView.frame.size.height)
        print(view.view.frame)
        //        view.view.autoresizesSubviews = true
        self.containerView.addSubview(view.view)
        
        currentSubview = view
    }
    
    public func loadNamedView(nextView:PanelViewController)
    {
        nextView.owner = self
        prepView(nextView)
    }

    // MARK: -
    // MARK:- IB Actions

    @IBAction func onTapAvatar(_ sender: UIButton) {
        
        self.userInfoAlertView.isHidden = true
        let nextView = mainstoryboard.instantiateViewController(withIdentifier: "OtherProfileViewController") as! OtherProfileViewController
        self.present(nextView, animated: true, completion: nil)
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
    
    func deleteImage() {
        
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
        
        RichnessAlamofire.POST(DELETEPHOTO_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                
                if(responseObject.object(forKey: "result") != nil){
                    
                    self.reportAlertView.isHidden = true
                    self.profileView.profileArray.remove(at: self.deletedImgIndex)
                    self.profileView.tableView.reloadData()
                    
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
    
    func changeProfile() {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        
        var params : [String : Any] = [:]
        
        switch self.changeType {
        case 1:
            params = [
                "id" : RichnessUserDefault.getUserID(),
                "key" : key,
                "nickname" : self.n_cTextField.text!
                ]
            break
        case 2:
            params = [
                "id" : RichnessUserDefault.getUserID(),
                "key" : key,
                "country" : self.n_cTextField.text!
                ]
            break
        case 3:
            params = [
                "id" : RichnessUserDefault.getUserID(),
                "key" : key,
                "description" : self.infoTxtView.text.encodeEmoji
                ]
            break
        default:
            break
        }
        
        print(params)
        
        RichnessAlamofire.POST(CHANGEPROFILE_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                print(responseObject)
                if(responseObject.object(forKey: "result") != nil){
                    
                    switch self.changeType {
                    case 1:
                        for item in self.profileView.profileArray{
                            item.name = self.n_cTextField.text!
                        }
                        self.profileView.tableView.reloadData()
                        self.editAlertView.isHidden = true
                        break
                    case 2:
                        self.profileView.profileArray[0].country = self.n_cTextField.text!
                        self.profileView.tableView.reloadData()
                        self.editAlertView.isHidden = true
                        break
                    case 3:
                        self.profileView.profileArray[0].description = self.infoTxtView.text!
                        self.profileView.tableView.reloadData()
                        self.infoTxtAlertView.isHidden = true
                        break
                    default:
                        break
                    }
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
    
    @IBAction func onTapGetRich(_ sender: GradientButton) {
        self.getRichAlertView.isHidden = true
        tabButton[2].setBackgroundImage(UIImage(named: "icon_camera_click"), for: .normal)
        tabButton[4].setBackgroundImage(UIImage(named: "icon_buy_click"), for: .normal)
        let nextView: PanelViewController = self.storyboard?.instantiateViewController(withIdentifier: "DiamondViewController") as! DiamondViewController
        loadNamedView(nextView: nextView)
    }
    
    @IBAction func onTapSubmit_Name_Country(_ sender: UIButton) {
        changeProfile()
    }
    
    @IBAction func onTapSubmit_Detail(_ sender: UIButton) {
        changeProfile()
    }
}


extension UIButton {
    func preventRepeatedPresses(inNext seconds: Double = 1) {
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            self.isUserInteractionEnabled = true
        }
    }
}


extension MainViewController: LuminaDelegate {
    func streamed(videoFrame: UIImage, with predictions: [LuminaRecognitionResult]?, from controller: LuminaViewController) {
        if #available(iOS 11.0, *) {
            guard let predicted = predictions else {
                return
            }
            var resultString = String()
            for prediction in predicted {
                guard let values = prediction.predictions else {
                    continue
                }
                guard let bestPrediction = values.first else {
                    continue
                }
                resultString.append("\(String(describing: prediction.type)): \(bestPrediction.name)" + "\r\n")
            }
            controller.textPrompt = resultString
        } else {
            print("CoreML not available in iOS 10.0")
        }
    }

    func captured(stillImage: UIImage, livePhotoAt: URL?, depthData: Any?, from controller: LuminaViewController) {
        controller.dismiss(animated: true) {
            self.performSegue(withIdentifier: "stillImageOutputSegue", sender: ["stillImage" : stillImage, "livePhotoURL" : livePhotoAt as Any, "depthData" : depthData, "isPhotoSelfie" : controller.position == .front ? true : false])
        }
    }

    func captured(videoAt: URL, from controller: LuminaViewController) {
        controller.dismiss(animated: true) {
            let player = AVPlayer(url: videoAt)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player?.play()
            }
        }
    }

    func detected(metadata: [Any], from controller: LuminaViewController) {
        print(metadata)
    }

    func streamed(videoFrame: UIImage, from controller: LuminaViewController) {
        print("video frame received")
    }

    func streamed(depthData: Any, from controller: LuminaViewController) {
        if #available(iOS 11.0, *) {
            if let data = depthData as? AVDepthData {
                guard let image = data.depthDataMap.normalizedImage(with: controller.position) else {
                    print("could not convert depth data")
                    return
                }
                if let imageView = self.depthView {
                    imageView.removeFromSuperview()
                }
                let newView = UIImageView(frame: CGRect(x: controller.view.frame.minX, y: controller.view.frame.maxY - 300, width: 200, height: 200))
                newView.image = image
                newView.contentMode = .scaleAspectFit
                newView.backgroundColor = UIColor.clear
                controller.view.addSubview(newView)
                controller.view.bringSubview(toFront: newView)
            }
        }
    }

    func dismissed(controller: LuminaViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension CVPixelBuffer {
    func normalizedImage(with position: CameraPosition) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: self)
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(self), height: CVPixelBufferGetHeight(self))) {
            return UIImage(cgImage: cgImage , scale: 1.0, orientation: getImageOrientation(with: position))
        } else {
            return nil
        }
    }

    private func getImageOrientation(with position: CameraPosition) -> UIImageOrientation {
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft:
            return position == .back ? .down : .upMirrored
        case .landscapeRight:
            return position == .back ? .up : .downMirrored
        case .portraitUpsideDown:
            return position == .back ? .left : .rightMirrored
        case .portrait:
            return position == .back ? .right : .leftMirrored
        case .unknown:
            return position == .back ? .right : .leftMirrored
        }
    }
}
extension UIView{
    func addBlackGradientLayer(frame: CGRect, colors:[UIColor]){
        let width = (UIScreen.main.bounds.size.width - 72)/2
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        self.layer.addSublayer(gradient)
    }
}

// Support methods
extension MainViewController {
    /* Gives a resolution for the video by URL */
    func resolutionForLocalVideo(url: URL) -> CGSize? {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
}

