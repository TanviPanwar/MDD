////
////  PostVideoViewController.swift
////  Richness
////
////  Created by IOS3 on 24/01/19.
////  Copyright © 2019 Sobura. All rights reserved.
////
//
//import UIKit
//import Photos
//import  Alamofire
//
//class PostVideoViewController: UIViewController , IsMediaFilterVC, UITextViewDelegate
//{
//
//    @IBOutlet weak var videoView: YPVideoView!
//
//    @IBOutlet weak var coverImageView: UIImageView!
//    @IBOutlet weak var commentTextView: UITextView!
//    @IBOutlet weak var postVideoBtn: UIButton!
//
//    public var inputVideo: YPMediaVideo!
//    public var inputAsset: AVAsset { return AVAsset(url: inputVideo.url) }
//
//    private var playbackTimeCheckerTimer: Timer?
//    private var imageGenerator: AVAssetImageGenerator?
//    private var isFromSelectionVC = false
//
//     var recordedData: Data?
//
//    var didSave: ((YPMediaItem) -> Void)?
//    var didCancel: (() -> Void)?
//
//    /// Designated initializer
//    public class func initWith(video: YPMediaVideo,
//                               isFromSelectionVC: Bool) -> PostVideoViewController {
//        let vc = PostVideoViewController(nibName: "PostVideoViewController", bundle: Bundle(for: PostVideoViewController.self))
//        vc.inputVideo = video
//        vc.isFromSelectionVC = isFromSelectionVC
//
//        return vc
//    }
//
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//
//        // Remove the default and add a notification to repeat playback from the start
//        commentTextView.delegate = self
//        videoView.removeReachEndObserver()
//        NotificationCenter.default
//            .addObserver(self,
//                         selector: #selector(itemDidFinishPlaying(_:)),
//                         name: .AVPlayerItemDidPlayToEndTime,
//                         object: nil)
//
//
//        // Set initial video cover
//        imageGenerator = AVAssetImageGenerator(asset: self.inputAsset)
//        imageGenerator?.appliesPreferredTrackTransform = true
//        // didChangeThumbPosition(CMTime(seconds: 1, preferredTimescale: 1))
//
//        // Navigation bar setup
//        title = "Publish"
////        if isFromSelectionVC {
////            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon4"),
////                                                               style: .plain,
////                                                               target: self,
////                                                               action: #selector(cancel))
////        }
//
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon4"),
//                                                           style: .plain,
//                                                           target: self,
//                                                           action: #selector(cancel))
//        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.8164560199, green: 0.7133601308, blue: 0.52625525, alpha: 1)
//
//        // Do any additional setup after loading the view.
//    }
//
//    override public func viewDidAppear(_ animated: Bool) {
//
//        videoView.loadVideo(inputVideo)
//
//        super.viewDidAppear(animated)
//    }
//
//    public override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        stopPlaybackTimeChecker()
//        videoView.stop()
//    }
//
//    //MARK:-
//    //MARK:- Textview Delegates
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if (commentTextView.text == "Add a description here...") {
//            commentTextView.text = ""
//           // commentTextView.textColor = UIColor.black
//        }
//    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if (commentTextView.text == "") {
//            //commentTextView.textColor = UIColor.gray
//            commentTextView.text = "Add a description here..."
//        }
//    }
//
//
//    //MARK:-
//    //MARK:- IB Actions
//
//    @IBAction func PostVideoBtnAction(_ sender: Any)
//    {
//
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.inputVideo.url)
//        }) { saved, error in
//            if saved {
//                print(" Video is saved in gallery")
////                let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
////                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
////                alertController.addAction(defaultAction)
////                self.present(alertController, animated: true, completion: nil)
//            }
//        }
//
//      postVideo()
//        //video()
//
//    }
//
//    //MARK:-
//    //MARK:- Methods
//
//    @objc func cancel() {
//        //didCancel?()
//        navigationController?.popViewController(animated: true)
//    }
//
//
//    @objc func itemDidFinishPlaying(_ notification: Notification) {
////        if let startTime = trimmerView.startTime {
////            videoView.player.seek(to: startTime)
////        }
//    }
//
//    func startPlaybackTimeChecker() {
//        stopPlaybackTimeChecker()
//        playbackTimeCheckerTimer = Timer
//            .scheduledTimer(timeInterval: 0.05, target: self,
//                            selector: #selector(onPlaybackTimeChecker),
//                            userInfo: nil,
//                            repeats: true)
//    }
//
//    func stopPlaybackTimeChecker() {
//        playbackTimeCheckerTimer?.invalidate()
//        playbackTimeCheckerTimer = nil
//    }
//
//    @objc func onPlaybackTimeChecker() {
////        guard let startTime = trimmerView.startTime,
////            let endTime = trimmerView.endTime else {
////                return
//       // }
//
//        let playBackTime = videoView.player.currentTime()
//        //trimmerView.seek(to: playBackTime)
//
////        if playBackTime >= endTime {
////            videoView.player.seek(to: startTime,
////                                  toleranceBefore: kCMTimeZero,
////                                  toleranceAfter: kCMTimeZero)
////            //trimmerView.seek(to: startTime)
////        }
//    }
//
//    //MARK:-
//    //MARK:- Api Methods
//
//    func postVideo() {
//        var comment : String = ""
//        let currentDate = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy HH"
//        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
//
//
//        if (commentTextView.text == "Add a description here...") {
//            comment = ""
//        }
//        else{
//            comment = commentTextView.text.encodeEmoji
//        }
//
//        let params = [
//            "id" : RichnessUserDefault.getUserID(),
//            "key" : key,
//            "text" : comment,
//            "type" : "1"
//        ]
//      print(params)
//         let assetURL =  inputVideo.url
//        do {
//      recordedData = try Data(contentsOf: assetURL)
//
//        RichnessAlamofire.showIndicator()
//        RichnessAlamofire.shareInstance.upload(multipartFormData: { multipartFormData in
//
//            if(self.inputVideo != nil)
//            {
//                multipartFormData.append(self.recordedData!, withName: "image", fileName: "\(Date().ticks).mp4", mimeType: "video/mp4")
//            }
//
//            let contentDict = params
//            for (key, value) in contentDict
//            {
//                multipartFormData.append(value.data(using: .utf8)!, withName: key)
//            }
//
//        }, usingThreshold: RichnessAlamofire.multipartFormDataEncodingMemoryThreshold, to: ADDIMAGE_URL, method: .post, encodingCompletion: { encodingResult in
//            switch encodingResult {
//            case .success(let upload, _, _):
//                upload.responseJSON { response in
//                    print(response)
//
//                    switch response.result {
//                    case .success(let JSON):
//                        let res = JSON as! NSDictionary
//
//                        if(res.object(forKey: "image_add") != nil){
//
//                            self.showSuccess(successMsg: "Video added successfully.")
//                        }
//                        else{
//                            let error = res.object(forKey: "error") as? String
//                            if (error == "#997") {
//                                self.showError(errMsg: user_error_unknown)
//                            }
//                            else {
//                                self.showError(errMsg: error_on_server)
//                            }
//                        }
//                        RichnessAlamofire.hideIndicator()
//                    case .failure(let error):
//                        print(error)
//                    }
//                    RichnessAlamofire.hideIndicator()
//                }
//            case .failure(let encodingError):
//                print(encodingError)
//                RichnessAlamofire.hideIndicator()
//            }
//        })
//
//        }
//
//        catch
//        {
//
//
//        }
//    }
//
//    func video()
//    {
//        var comment : String = ""
//        let currentDate = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
//
//
//        if (commentTextView.text == "Add a description here...") {
//            comment = ""
//        }
//        else{
//            comment = commentTextView.text.encodeEmoji
//        }
//
//        let  params = ["file_date":  dateFormatter.string(from:Date()) as String , "file_size": String(80), "tags":""]
//        print(params)
//        let assetURL =  inputVideo.url
//        do {
//            recordedData = try Data(contentsOf: assetURL)
//            let headers = [
//                "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImE2NjkwNmJhYjg4ZDY2YTU4MDMyMjkwNjVkYzI2ZWQ2MGFlMDVlOWVhOGUyZDkxMzc3ODYzODhiMjcwMjE3Yjk1MmNlNDZlN2ZhYzFiOTZiIn0.eyJhdWQiOiI0IiwianRpIjoiYTY2OTA2YmFiODhkNjZhNTgwMzIyOTA2NWRjMjZlZDYwYWUwNWU5ZWE4ZTJkOTEzNzc4NjM4OGIyNzAyMTdiOTUyY2U0NmU3ZmFjMWI5NmIiLCJpYXQiOjE1NDgxNTg1NDksIm5iZiI6MTU0ODE1ODU0OSwiZXhwIjoxNTc5Njk0NTQ5LCJzdWIiOiI2Iiwic2NvcGVzIjpbXX0.VMdLgwLCrMdqpeDG0T8YTXeYy5d6XyGvDvH8fKPaI5kdiD7QsAjYpFn_LmeTgrbkAAc64hRjEMJ429baW1F8--2TA0ngvujgQv7VpLCYG2FgeL-B4_EM8UVwp4QJwpCZCefilqyV-858n0grvS-C4MkpqtFdowtr19O_HdbWsGeDhGZuOVIwRuU2PEj84S7m22O0pvTuf8XP9eg--zAUHDDWApTre1mS_peSNXCINZVIeRLwqKSc5884YHgSL8TF_PCugQt7NkxrpHsSJm96JoV_lZrDaooL1eA1NJGMfRNCz8kG7-y1vfMkfV2eScSQxZVw9WYatp8JUQXAsopf8G8kE-5vS_l1sBoYVx6iEkXnl8lhu2QkvN2iRegzXq0_-DBNzh27U5TR5JM8Ve10KGTVl0m0JGAC7TNYb0UTOj61UzmCJtUj1dLKD1XH98631ClTmiwDSMDUkmcGMOUM1aJWRm7PejbkPAlXsgH5arjl5PhdDRgh2CYxn50YVBSUrNF5VGwq65PGgdt7Q7IvSbjyk5fhQ3uIFLJMjvnWYezJuQS3fwYayvEHCetD1xpYZowYpBcMljLQpX-d8wkWzYdEmpMmkYtaOJV0CBQdM_68DkkYIONXKD1hKy-IXx6Xoo9hHtBI84JKbo4PzBjfKQ-21L6h8BtWYZsROr_GEUc",
//                "Accept": "application/json"
//            ]
//
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//
//            multipartFormData.append(self.recordedData ?? Data(), withName: "files", fileName: "\(Date().ticks).mp4", mimeType: "video/mp4")
//            for (key, value) in params {
//                // multipartFormData.append(((value as? String)!.data(using: .utf8))!, withName: key)
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//
//            }
//        }, to:"http://dev.loopleap.com/api/uploadfile",  headers:headers)
//        { (result) in
//
//           // ProjectManager.sharedInstance.stopLoader()
//
//            switch result {
//
//
//
//            case .success(let upload, _, _):
//
//
//                upload.responseJSON { response in
//
//                    print(response.result.value)
//                    //                        DispatchQueue.main.async {
//                    //                            ProjectManager.sharedInstance.stopLoader()
//                    //                            self.dismiss(animated: true, completion: nil)
//                    //                        }
//
//                    if response.result.isFailure {
//                        DispatchQueue.main.async {
//
//                        }
//                    }
//                    else {
//
//
//                    }
//
//                    //print response.result
//                }
//
//
//
//
//            case .failure(let _):
//
//
//                break
//            }
//        }
//
//        }
//        catch
//        {
//
//        }
//
//
//    }
//
//
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
//extension Date {
//    var ticks: UInt64 {
//        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
//    }
//}



//
//  PostVideoViewController.swift
//  Richness
//
//  Created by IOS3 on 24/01/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import UIKit
import Photos
import  Alamofire

class PostVideoViewController: UIViewController , IsMediaFilterVC, UITextViewDelegate
{

    @IBOutlet weak var videoView: YPVideoView!

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var postVideoBtn: UIButton!

    public var inputVideo: YPMediaVideo!
    public var inputAsset: AVAsset { return AVAsset(url: inputVideo.url) }

    private var playbackTimeCheckerTimer: Timer?
    private var imageGenerator: AVAssetImageGenerator?
    private var isFromSelectionVC = false

    var recordedData: Data?

    var didSave: ((YPMediaItem) -> Void)?
    var didCancel: (() -> Void)?

    /// Designated initializer
    public class func initWith(video: YPMediaVideo,
                               isFromSelectionVC: Bool) -> PostVideoViewController {
        let vc = PostVideoViewController(nibName: "PostVideoViewController", bundle: Bundle(for: PostVideoViewController.self))
        vc.inputVideo = video
        vc.isFromSelectionVC = isFromSelectionVC

        return vc
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Remove the default and add a notification to repeat playback from the start
        commentTextView.delegate = self
        videoView.isHidden = true
        videoView.removeReachEndObserver()
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(itemDidFinishPlaying(_:)),
                         name: .AVPlayerItemDidPlayToEndTime,
                         object: nil)


        // Set initial video cover
        imageGenerator = AVAssetImageGenerator(asset: self.inputAsset)
        imageGenerator?.appliesPreferredTrackTransform = true
        
        // didChangeThumbPosition(CMTime(seconds: 1, preferredTimescale: 1))
        
        let time = CMTimeMakeWithSeconds(1.0, 600)
        do {
            let img = try imageGenerator!.copyCGImage(at: time, actualTime: nil)
            if img != nil {
                let thumbnail = UIImage(cgImage: img)
                self.coverImageView.contentMode = .scaleAspectFit
                self.coverImageView.clipsToBounds =  true
                DispatchQueue.main.async(execute: {
                    self.coverImageView?.image = thumbnail
                })
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(imageTapped(tapGestureRecognizer:)))
        
        coverImageView.isUserInteractionEnabled = true
        coverImageView.addGestureRecognizer(tapGestureRecognizer)
            

        // Navigation bar setup
       
        //        if isFromSelectionVC {
        //            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon4"),
        //                                                               style: .plain,
        //                                                               target: self,
        //                                                               action: #selector(cancel))
        
        
        //        }
        
    
        title = "Publish"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon4"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(cancel))
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.8164560199, green: 0.7133601308, blue: 0.52625525, alpha: 1)
      

        // Do any additional setup after loading the view.
    }

    override public func viewDidAppear(_ animated: Bool) {

       // videoView.loadVideo(inputVideo)

        super.viewDidAppear(animated)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopPlaybackTimeChecker()
        videoView.stop()
    }

    //MARK:-
    //MARK:- Textview Delegates

    func textViewDidBeginEditing(_ textView: UITextView) {
        if (commentTextView.text == "Add a description here...") {
            commentTextView.text = ""
            // commentTextView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if (commentTextView.text == "") {
            //commentTextView.textColor = UIColor.gray
            commentTextView.text = "Add a description here..."
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 300// 10 Limit Value
    }
    
    //MARK:-
    //MARK:- Tap Gesture Method
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        // showPicker()
        self.navigationController?.popToRootViewController(animated: true)
    }


    //MARK:-
    //MARK:- IB Actions

    @IBAction func PostVideoBtnAction(_ sender: Any)
    {

//                PHPhotoLibrary.shared().performChanges({
//                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.inputVideo.url)
//                }) { saved, error in
//                    if saved {
//                        print(" Video is saved in gallery")
//        //                let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
//        //                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        //                alertController.addAction(defaultAction)
//        //                self.present(alertController, animated: true, completion: nil)
//                    }
//                }

        postVideo()
        //video()

    }

    //MARK:-
    //MARK:- Methods

    @objc func cancel() {
        //didCancel?()
        navigationController?.popViewController(animated: true)
    }


    @objc func itemDidFinishPlaying(_ notification: Notification) {
        //        if let startTime = trimmerView.startTime {
        //            videoView.player.seek(to: startTime)
        //        }
    }

    func startPlaybackTimeChecker() {
        stopPlaybackTimeChecker()
        playbackTimeCheckerTimer = Timer
            .scheduledTimer(timeInterval: 0.05, target: self,
                            selector: #selector(onPlaybackTimeChecker),
                            userInfo: nil,
                            repeats: true)
    }

    func stopPlaybackTimeChecker() {
        playbackTimeCheckerTimer?.invalidate()
        playbackTimeCheckerTimer = nil
    }

    @objc func onPlaybackTimeChecker() {
        //        guard let startTime = trimmerView.startTime,
        //            let endTime = trimmerView.endTime else {
        //                return
        // }

        let playBackTime = videoView.player.currentTime()
        //trimmerView.seek(to: playBackTime)

        //        if playBackTime >= endTime {
        //            videoView.player.seek(to: startTime,
        //                                  toleranceBefore: kCMTimeZero,
        //                                  toleranceAfter: kCMTimeZero)
        //            //trimmerView.seek(to: startTime)
        //        }
    }

    //MARK:-
    //MARK:- Api Methods

    func postVideo() {
        var comment : String = ""
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)


        if (commentTextView.text == "Add a description here...") {
            comment = ""
        }
        else{
            comment = commentTextView.text.encodeEmoji
        }

        let params = [
            "id" : RichnessUserDefault.getUserID(),
            "key" : key,
            "text" : comment,
            "type" : "1"
        ]
        print(params)
        let assetURL =  inputVideo.url
       print(self.navigationController?.viewControllers)
        self.encodeVideo(videoURL:assetURL) { (status, videoURL) in
            if status && videoURL != nil{
                do {
                    print(assetURL.absoluteString)
                    self.recordedData = try Data(contentsOf: videoURL!)
                    DispatchQueue.main.async {
                          RichnessAlamofire.showIndicator()
                    }
                  
                    RichnessAlamofire.shareInstance.upload(multipartFormData: { multipartFormData in

                        if(self.inputVideo != nil)
                        {
                            multipartFormData.append(self.recordedData!, withName: "image", fileName: "video.mp4", mimeType: "video/mp4")
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


                                        DispatchQueue.main.async {
                                          
                                           
                                            for vc in (self.navigationController?.viewControllers)! {
                                                   
                                                if vc is YPPickerVC {
                                                 
                        
                                                    self.navigationController?.popToViewController(vc, animated: false)
                                                    
                                                       ProjectManager.shared.postVideoDelegate?.navigateToHome()
                                                    break
                                                }
                                            }
                                            
                                              self.showSuccess(successMsg: "Video added successfully.")
                                            //self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
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
                                     DispatchQueue.main.async {
                                    RichnessAlamofire.hideIndicator()
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                                 DispatchQueue.main.async {
                                RichnessAlamofire.hideIndicator()
                                }
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                             DispatchQueue.main.async {
                            RichnessAlamofire.hideIndicator()
                            }
                        }
                    })

                }

                catch
                {
               RichnessAlamofire.hideIndicator()

                }

            } else {
                 RichnessAlamofire.hideIndicator()
                self.showError(errMsg: user_error_unknown)
            }
        }


    }


    func encodeVideo(videoURL: URL , completionHandler:@escaping(Bool, URL?) -> Void)  {
        let avAsset = AVURLAsset(url: videoURL, options: nil)

        var startDate = NSDate()

        //Create Export session
        var exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetMediumQuality)

        // exportSession = AVAssetExportSession(asset: composition, presetName: mp4Quality)
        //Creating temp path to save the converted video


        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let myDocumentPath = NSURL(fileURLWithPath: documentsDirectory).appendingPathComponent("temp.mp4")?.absoluteString
        let url =  URL(fileURLWithPath:myDocumentPath! )

        let documentsDirectory2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let filePath = documentsDirectory2.appendingPathComponent("rendered-Video.mp4")
        deleteFile(filePath: filePath )

        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath:myDocumentPath ?? "") {
            do {
                try FileManager.default.removeItem(atPath: myDocumentPath ?? "")
            }
            catch let error {
                print(error)
            }
        }


        exportSession!.outputURL = filePath
        exportSession!.outputFileType = AVFileType.mp4
        exportSession!.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, 0)
        let range = CMTimeRangeMake(start, avAsset.duration)
        exportSession?.timeRange = range

        exportSession!.exportAsynchronously(completionHandler: {() -> Void in
            switch exportSession?.status {
            case .failed?:

                print("%@",exportSession?.error)
                completionHandler(false ,nil )

            case .cancelled?:
                print("Export canceled")
                completionHandler(false ,nil )

            case .completed?:
                //Video conversion finished
                let endDate = Date()

                let time = endDate.timeIntervalSince(startDate as Date )
                print(time)
                print("Successful!")
                print(exportSession?.outputURL ?? "")
                completionHandler(true ,exportSession?.outputURL )
            default:
                completionHandler(false ,nil )

                break
            }

        })


    }

    func deleteFile(filePath:URL) {
        guard FileManager.default.fileExists(atPath: filePath.path) else {
            return
        }

        do {
            try FileManager.default.removeItem(at: filePath)
        }catch{
            fatalError("Unable to delete file: \(error) :")
        }
    }

    func video()
    {
        var comment : String = ""
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)


        if (commentTextView.text == "Add a description here...") {
            comment = ""
        }
        else{
            comment = commentTextView.text.encodeEmoji
        }

        let  params = ["file_date":  dateFormatter.string(from:Date()) as String , "file_size": String(80), "tags":""]
        print(params)
        let assetURL =  inputVideo.url
        do {
            recordedData = try Data(contentsOf: assetURL)
            let headers = [
                "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImE2NjkwNmJhYjg4ZDY2YTU4MDMyMjkwNjVkYzI2ZWQ2MGFlMDVlOWVhOGUyZDkxMzc3ODYzODhiMjcwMjE3Yjk1MmNlNDZlN2ZhYzFiOTZiIn0.eyJhdWQiOiI0IiwianRpIjoiYTY2OTA2YmFiODhkNjZhNTgwMzIyOTA2NWRjMjZlZDYwYWUwNWU5ZWE4ZTJkOTEzNzc4NjM4OGIyNzAyMTdiOTUyY2U0NmU3ZmFjMWI5NmIiLCJpYXQiOjE1NDgxNTg1NDksIm5iZiI6MTU0ODE1ODU0OSwiZXhwIjoxNTc5Njk0NTQ5LCJzdWIiOiI2Iiwic2NvcGVzIjpbXX0.VMdLgwLCrMdqpeDG0T8YTXeYy5d6XyGvDvH8fKPaI5kdiD7QsAjYpFn_LmeTgrbkAAc64hRjEMJ429baW1F8--2TA0ngvujgQv7VpLCYG2FgeL-B4_EM8UVwp4QJwpCZCefilqyV-858n0grvS-C4MkpqtFdowtr19O_HdbWsGeDhGZuOVIwRuU2PEj84S7m22O0pvTuf8XP9eg--zAUHDDWApTre1mS_peSNXCINZVIeRLwqKSc5884YHgSL8TF_PCugQt7NkxrpHsSJm96JoV_lZrDaooL1eA1NJGMfRNCz8kG7-y1vfMkfV2eScSQxZVw9WYatp8JUQXAsopf8G8kE-5vS_l1sBoYVx6iEkXnl8lhu2QkvN2iRegzXq0_-DBNzh27U5TR5JM8Ve10KGTVl0m0JGAC7TNYb0UTOj61UzmCJtUj1dLKD1XH98631ClTmiwDSMDUkmcGMOUM1aJWRm7PejbkPAlXsgH5arjl5PhdDRgh2CYxn50YVBSUrNF5VGwq65PGgdt7Q7IvSbjyk5fhQ3uIFLJMjvnWYezJuQS3fwYayvEHCetD1xpYZowYpBcMljLQpX-d8wkWzYdEmpMmkYtaOJV0CBQdM_68DkkYIONXKD1hKy-IXx6Xoo9hHtBI84JKbo4PzBjfKQ-21L6h8BtWYZsROr_GEUc",
                "Accept": "application/json"
            ]

            Alamofire.upload(multipartFormData: { (multipartFormData) in

                multipartFormData.append(self.recordedData ?? Data(), withName: "files", fileName: "\(Date().ticks).mp4", mimeType: "video/mp4")
                for (key, value) in params {
                    // multipartFormData.append(((value as? String)!.data(using: .utf8))!, withName: key)
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)

                }
            }, to:"http://dev.loopleap.com/api/uploadfile",  headers:headers)
            { (result) in

                // ProjectManager.sharedInstance.stopLoader()

                switch result {



                case .success(let upload, _, _):


                    upload.responseJSON { response in

                        print(response.result.value)
                        //                        DispatchQueue.main.async {
                        //                            ProjectManager.sharedInstance.stopLoader()
                        //                            self.dismiss(animated: true, completion: nil)
                        //                        }

                        if response.result.isFailure {
                            DispatchQueue.main.async {

                            }
                        }
                        else {


                        }

                        //print response.result
                    }




                case .failure(let _):


                    break
                }
            }

        }
        catch
        {

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

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

