//
//  SavePhotoViewController.swift
//  Richness
//
//  Created by IOS3 on 23/01/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import UIKit
import PullToRefresh
import SDWebImage
import Player
import  IQKeyboardManagerSwift
import AVFoundation
import AVKit

//public enum YPCropType {
//    case none
//    case rectangle(ratio: Double)
//}
public enum SaveType {
    case none
    //case rectangle(ratio: Double)
}

class SavePhotoViewController: UIViewController, UITextViewDelegate {
    
    var selectedItems = [YPMediaItem]()
    
    let selectedImageV = UIImageView()

    public var didFinishSaving: ((UIImage) -> Void)?
    override var prefersStatusBarHidden: Bool { return YPConfig.hidesStatusBar }

    private let originalImage: UIImage
    var ProfileImage : Data? = nil



    private let v: SaveView
    override func loadView() { view = v }



    required init(image: UIImage) {
        v = SaveView(image: image)
        originalImage = image
        super.init(nibName: nil, bundle: nil)
       self.title = "Publish" //YPConfig.wordings.crop
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        v.descriptionText.delegate = self
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon4"),
                                                           style: .plain,
                                                            target: self,
                                                            action: #selector(cancel))
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.8164560199, green: 0.7133601308, blue: 0.52625525, alpha: 1)
        
        
        
        
        //YPHelper.changeBackButtonIcon(self)
       // YPHelper.changeBackButtonTitle(self)
//        let upperLine = UIView()
//        let lowerLine = UIView()
//        upperLine.height(2)
//        upperLine.width(1000)
//        lowerLine.height(2)
//        lowerLine.width(375)
//        upperLine.backgroundColor = #colorLiteral(red: 0.8164560199, green: 0.7133601308, blue: 0.52625525, alpha: 1)
//        lowerLine.backgroundColor = #colorLiteral(red: 0.8164560199, green: 0.7133601308, blue: 0.52625525, alpha: 1)
//
//        upperLine.Top == v.imageView.Top
//        lowerLine.Top == v.imageView.Bottom
        setupToolbar()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(imageTapped(tapGestureRecognizer:)))
        
         v.imageView.isUserInteractionEnabled = true
         v.imageView.addGestureRecognizer(tapGestureRecognizer)
        
        //setupGestureRecognizers()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK:-
    //MARK:- Textview Delegates

    func textViewDidBeginEditing(_ textView: UITextView) {
        if (v.descriptionText.text == "Add a description here...") {
            v.descriptionText.text = ""
            // commentTextView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if (v.descriptionText.text == "") {
            //commentTextView.textColor = UIColor.gray
            v.descriptionText.text = "Add a description here..."
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 300    // 10 Limit Value
    }
    
    //MARK:-
    //MARK:- Tap Gesture Method

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
       showPicker()
       // self.navigationController?.popToRootViewController(animated: true)
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
        
        config.library.maxNumberOfItems = 5
        
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
                    self.selectedImageV.contentMode = .scaleAspectFit
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
                        print("😀 \(String(describing: self?.resolutionForLocalVideo1(url: assetURL)!))")
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

    func setupToolbar() {
        let cancelButton = UIBarButtonItem(title: YPConfig.wordings.cancel,
                                           style: .plain,
                                           target: self,
                                           action: #selector(cancel))
        cancelButton.tintColor = .white
        let button1: UIButton = UIButton(type: UIButtonType.custom)
        button1.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        button1.isUserInteractionEnabled = true
        //set image for button
        button1.setImage(UIImage(named: "icon_check"), for: UIControlState.normal)
        button1.addTarget(self, action: #selector(done), for: .touchUpInside)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil);
        let flexibleSpace1 = UIBarButtonItem(customView:button1 )





        let saveButton = UIBarButtonItem(title: YPConfig.wordings.save,
                                         style: .plain,
                                         target: self,
                                         action: #selector(done))
        saveButton.tintColor = .white
        v.toolbar.items = [flexibleSpace, flexibleSpace1, flexibleSpace]
//
//
//        let titleView = UIView()
//        titleView.frame = CGRect(x: v.bottomCurtain.frame.size.width, y:
//            v.bottomCurtain.frame.size.height, width: v.bottomCurtain.frame.size.width, height: v.bottomCurtain.frame.size.width)
//
//        print(v.lowerArea.frame)
//        let button: UIButton = UIButton(type: UIButtonType.custom)
//        //set image for button
//        button.setImage(UIImage(named: "icon_check"), for: UIControlState.normal)
//        //add function for button
//        button.addTarget(self, action: #selector(done), for: UIControlEvents.touchUpInside)
//        //set frame
//        button.frame = CGRect(x:(v.lowerArea.frame.size.width - 60)/2, y: (v.lowerArea.frame.size.height - 60)/2 , width: 60, height: 60)
        //titleView.addSubview(button)
        //        self.view.addSubview(titleView)
        // v.lowerArea.addSubview(button)

    }

//    func setupGestureRecognizers() {
//        // Pinch Gesture
//        pinchGR.addTarget(self, action: #selector(pinch(_:)))
//        pinchGR.delegate = self
//        v.imageView.addGestureRecognizer(pinchGR)
//
//        // Pan Gesture
//        panGR.addTarget(self, action: #selector(pan(_:)))
//        panGR.delegate = self
//        v.imageView.addGestureRecognizer(panGR)
//    }

    @objc
    func cancel() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    func done() {
        guard let image = v.imageView.image else {
            return
        }

        let xCrop =  v.imageView.frame.minX
        let yCrop = v.imageView.frame.minY
        let widthCrop = v.cropArea.frame.width
        let heightCrop = v.cropArea.frame.height
        let scaleRatio = image.size.width / v.imageView.frame.width
        let scaledCropRect = CGRect(x: xCrop * scaleRatio,
                                    y: yCrop * scaleRatio,
                                    width: widthCrop * scaleRatio,
                                    height: heightCrop * scaleRatio)
//        if let cgImage = image.toCIImage()?.toCGImage()
//             {
               // let croppedImage = UIImage(cgImage: image as! CGImage)
            didFinishSaving?(image)
       // guard let image = v.imageView.image else { return }
            postImage(postImage: image)
            YPPhotoSaver.trySaveImage(image, inAlbumNamed: YPConfig.albumName)



        }

    func postImage(postImage: UIImage) {
        var comment : String = ""
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)

        if (v.descriptionText.text == "Add a description here...") {
            comment = ""
        }
        else{
            comment = v.descriptionText.text.encodeEmoji
        }

        let params = [
            "id" : RichnessUserDefault.getUserID(),
            "key" : key,
            "text" : comment,
            "type" : "0"
            ]
        print(params)
        self.ProfileImage = UIImageJPEGRepresentation(postImage, 0.5)
        

        RichnessAlamofire.showIndicator()
        RichnessAlamofire.shareInstance.upload(multipartFormData: { multipartFormData in

            if(self.ProfileImage != nil)
            {
                multipartFormData.append(self.ProfileImage!, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            }

            let contentDict = params
            for (key, value) in contentDict
            {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }

        }, usingThreshold: RichnessAlamofire.multipartFormDataEncodingMemoryThreshold, to: ADDIMAGE_URL, method: .post, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)

                    switch response.result {
                    case .success(let JSON):
                        let res = JSON as! NSDictionary

                        if(res.object(forKey: "image_add") != nil){
                            //self.navigationController?.popToRootViewController(animated: true)
                            //self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
                            
                            DispatchQueue.main.async {
                                
                                
                                for vc in (self.navigationController?.viewControllers)! {
                                    
                                    if vc is YPPickerVC {
                                        
                                        
                                        self.navigationController?.popToViewController(vc, animated: false)
                                        
                                        ProjectManager.shared.postVideoDelegate?.navigateToHome()
                                        break
                                    }
                                }
                            self.showSuccess(successMsg: "Image added successfully.")
                            }
                        }
                        else{
                            let error = res.object(forKey: "error") as? String
                            if (error == "#997") {
                                self.showError(errMsg: user_error_unknown)
                            }
                            else {
                                self.showError(errMsg: error_on_server)
                            }
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



    }

// Support methods
extension SavePhotoViewController {
    /* Gives a resolution for the video by URL */
    func resolutionForLocalVideo1(url: URL) -> CGSize? {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
}


//}

//extension YPCropVC: UIGestureRecognizerDelegate {
//
//    // MARK: - Pinch Gesture
//
//    @objc
//    func pinch(_ sender: UIPinchGestureRecognizer) {
//        // TODO: Zoom where the fingers are (more user friendly)
//        switch sender.state {
//        case .began, .changed:
//            var transform = v.imageView.transform
//            // Apply zoom level.
//            transform = transform.scaledBy(x: sender.scale,
//                                           y: sender.scale)
//            v.imageView.transform = transform
//        case .ended:
//            pinchGestureEnded()
//        case .cancelled, .failed, .possible:
//            ()
//        }
//        // Reset the pinch scale.
//        sender.scale = 1.0
//    }
//
//    private func pinchGestureEnded() {
//        var transform = v.imageView.transform
//        let kMinZoomLevel: CGFloat = 1.0
//        let kMaxZoomLevel: CGFloat = 3.0
//        var wentOutOfAllowedBounds = false
//
//        // Prevent zooming out too much
//        if transform.a < kMinZoomLevel {
//            transform = .identity
//            wentOutOfAllowedBounds = true
//        }
//
//        // Prevent zooming in too much
//        if transform.a > kMaxZoomLevel {
//            transform.a = kMaxZoomLevel
//            transform.d = kMaxZoomLevel
//            wentOutOfAllowedBounds = true
//        }
//
//        // Animate coming back to the allowed bounds with a haptic feedback.
//        if wentOutOfAllowedBounds {
//            generateHapticFeedback()
//            UIView.animate(withDuration: 0.3, animations: {
//                self.v.imageView.transform = transform
//            })
//        }
//    }
//
//    func generateHapticFeedback() {
//        if #available(iOS 10.0, *) {
//            let generator = UIImpactFeedbackGenerator(style: .light)
//            generator.impactOccurred()
//        }
//    }
//
//    // MARK: - Pan Gesture
//
//    @objc
//    func pan(_ sender: UIPanGestureRecognizer) {
//        let translation = sender.translation(in: view)
//        let imageView = v.imageView
//
//        // Apply the pan translation to the image.
//        imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
//
//        // Reset the pan translation.
//        sender.setTranslation(CGPoint.zero, in: view)
//
//        if sender.state == .ended {
//            keepImageIntoCropArea()
//        }
//    }
//
//    private func keepImageIntoCropArea() {
//        let imageRect = v.imageView.frame
//        let cropRect = v.cropArea.frame
//        var correctedFrame = imageRect
//
//        // Cap Top.
//        if imageRect.minY > cropRect.minY {
//            correctedFrame.origin.y = cropRect.minY
//        }
//
//        // Cap Bottom.
//        if imageRect.maxY < cropRect.maxY {
//            correctedFrame.origin.y = cropRect.maxY - imageRect.height
//        }
//
//        // Cap Left.
//        if imageRect.minX > cropRect.minX {
//            correctedFrame.origin.x = cropRect.minX
//        }
//
//        // Cap Right.
//        if imageRect.maxX < cropRect.maxX {
//            correctedFrame.origin.x = cropRect.maxX - imageRect.width
//        }
//
//        // Animate back to allowed bounds
//        if imageRect != correctedFrame {
//            UIView.animate(withDuration: 0.3, animations: {
//                self.v.imageView.frame = correctedFrame
//            })
//        }
//    }
//
//    /// Allow both Pinching and Panning at the same time.
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
//                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//}
