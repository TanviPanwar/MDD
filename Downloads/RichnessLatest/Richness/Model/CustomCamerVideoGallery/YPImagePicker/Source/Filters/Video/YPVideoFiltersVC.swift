//
//  VideoFiltersVC.swift
//  YPImagePicker
//
//  Created by Nik Kov || nik-kov.com on 18.04.2018.
//  Copyright © 2018 Yummypets. All rights reserved.
//

import UIKit
import Photos
import AVKit
//import PryntTrimmerView

public class YPVideoFiltersVC: UIViewController, IsMediaFilterVC  {
    
    @IBOutlet weak var trimBottomItem: YPMenuItem!
    @IBOutlet weak var coverBottomItem: YPMenuItem!
    
    @IBOutlet weak var videoView: YPVideoView!
    @IBOutlet weak var trimmerView: TrimmerView!
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverThumbSelectorView: ThumbSelectorView!

    public var inputVideo: YPMediaVideo!
    public var inputAsset: AVAsset { return AVAsset(url: inputVideo.url) }
    
    private var playbackTimeCheckerTimer: Timer?
    private var imageGenerator: AVAssetImageGenerator?
    private var isFromSelectionVC = false
    
    var didSave: ((YPMediaItem) -> Void)?
    var didCancel: (() -> Void)?
    
    var time = String()

    private var _didFinishPicking: (([YPMediaItem], Bool) -> Void)?
    public func didFinishPicking(completion: @escaping (_ items: [YPMediaItem], _ cancelled: Bool) -> Void) {
        _didFinishPicking = completion
    }

    private func didSelect(items: [YPMediaItem]) {
        _didFinishPicking?(items, false)
    }

    /// Designated initializer
    public class func initWith(video: YPMediaVideo,
                               isFromSelectionVC: Bool) -> YPVideoFiltersVC {
        let vc = YPVideoFiltersVC(nibName: "YPVideoFiltersVC", bundle: Bundle(for: YPVideoFiltersVC.self))
        vc.inputVideo = video
        vc.isFromSelectionVC = isFromSelectionVC
        
        return vc
    }
    
    // MARK: - Live cycle

    override public func viewDidLoad() {
        super.viewDidLoad()

//        trimmerView.mainColor = YPConfig.colors.trimmerMainColor
//        trimmerView.handleColor = YPConfig.colors.trimmerHandleColor
//        trimmerView.positionBarColor = YPConfig.colors.positionLineColor
//        trimmerView.maxDuration = YPConfig.video.trimmerMaxDuration
//        trimmerView.minDuration = YPConfig.video.trimmerMinDuration
//
//        coverThumbSelectorView.thumbBorderColor = YPConfig.colors.coverSelectorBorderColor

//        trimBottomItem.textLabel.text = YPConfig.wordings.trim
//        coverBottomItem.textLabel.text = YPConfig.wordings.cover

//        trimBottomItem.button.addTarget(self, action: #selector(selectTrim), for: .touchUpInside)
//        coverBottomItem.button.addTarget(self, action: #selector(selectCover), for: .touchUpInside)
//
        // Remove the default and add a notification to repeat playback from the start
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
        
         title = ""//
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon4"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(cancel))
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.8164560199, green: 0.7133601308, blue: 0.52625525, alpha: 1)
        
        
        
        
        
        
        
        

//        navigationItem.leftBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "icon4"),
//                                                             style: .plain,
//                                                             target: self,
//                                                             action: #selector(cancel)) , UIBarButtonItem(title: YPConfig.wordings.cameraTitle,
//                                                                                                          style: .plain,
//                                                                                                          target: self,
//                                                                                                          action: nil)]
        
//        self.navigationController?.view.tintColor = #colorLiteral(red: 0.862745098, green: 0.7137254902, blue: 0.5294117647, alpha: 1)
//
//        let backButton = UIBarButtonItem()
//        backButton.title = "Publish"
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
//
        
        if isFromSelectionVC {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: YPConfig.wordings.cancel,
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(cancel))
        }
       // setupRightBarButtonItem()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
//        trimmerView.asset = inputAsset
//        trimmerView.delegate = self
//
//        coverThumbSelectorView.asset = inputAsset
//        coverThumbSelectorView.delegate = self
//
//        selectTrim()
        //videoView.loadVideo(inputVideo)

        super.viewDidAppear(animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopPlaybackTimeChecker()
        videoView.stop()
    }
    
    func setupRightBarButtonItem() {
        let rightBarButtonTitle = isFromSelectionVC ? YPConfig.wordings.done : YPConfig.wordings.next
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightBarButtonTitle,
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(save))
        navigationItem.rightBarButtonItem?.tintColor = YPConfig.colors.tintColor
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let player = AVPlayer(url: inputVideo.url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    // MARK: - Top buttons

    @objc public func save() {
        guard let didSave = didSave else { return print("Don't have saveCallback") }
        navigationItem.rightBarButtonItem = YPLoaders.defaultLoader

        do {
            let asset = AVURLAsset(url: inputVideo.url)
            let trimmedAsset = try asset
                .assetByTrimming(startTime: trimmerView.startTime ?? kCMTimeZero,
                                 endTime: trimmerView.endTime ?? inputAsset.duration)
            
            // Looks like file:///private/var/mobile/Containers/Data/Application
            // /FAD486B4-784D-4397-B00C-AD0EFFB45F52/tmp/8A2B410A-BD34-4E3F-8CB5-A548A946C1F1.mov
            let destinationURL = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingUniquePathComponent(pathExtension: YPConfig.video.fileType.fileExtension)
            
            try trimmedAsset.export(to: destinationURL) { [weak self] in
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async {
                    let resultVideo = YPMediaVideo(thumbnail: strongSelf.coverImageView.image!,
                                                   videoURL: destinationURL, asset: strongSelf.inputVideo.asset)
                    didSave(YPMediaItem.video(v: resultVideo))
                    strongSelf.setupRightBarButtonItem()
                }
            }
        } catch let error {
            print("💩 \(error)")
        }
    }
    
    @objc func cancel() {
        //didCancel?()
        navigationController?.popViewController(animated: true)

    }
    
    // MARK: - Bottom buttons

    @objc public func selectTrim() {
        title = YPConfig.wordings.trim
        
        trimBottomItem.select()
        coverBottomItem.deselect()

        trimmerView.isHidden = false
        videoView.isHidden = false
        coverImageView.isHidden = true
        coverThumbSelectorView.isHidden = true
    }
    
    @objc public func selectCover() {
        title = YPConfig.wordings.cover
        
        trimBottomItem.deselect()
        coverBottomItem.select()
        
        trimmerView.isHidden = true
        videoView.isHidden = true
        coverImageView.isHidden = false
        coverThumbSelectorView.isHidden = false
        
        stopPlaybackTimeChecker()
        videoView.stop()
    }
    
    // MARK: - Various Methods

    // Updates the bounds of the cover picker if the video is trimmed
    // TODO: Now the trimmer framework doesn't support an easy way to do this.
    // Need to rethink a flow or search other ways.
    func updateCoverPickerBounds() {
        if let startTime = trimmerView.startTime,
            let endTime = trimmerView.endTime {
            if let selectedCoverTime = coverThumbSelectorView.selectedTime {
                let range = CMTimeRange(start: startTime, end: endTime)
                if !range.containsTime(selectedCoverTime) {
                    // If the selected before cover range is not in new trimeed range,
                    // than reset the cover to start time of the trimmed video
                }
            } else {
                // If none cover time selected yet, than set the cover to the start time of the trimmed video
            }
        }
    }
    
    // MARK: - Trimmer playback
    
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
        guard let startTime = trimmerView.startTime,
            let endTime = trimmerView.endTime else {
            return
        }
        
        let playBackTime = videoView.player.currentTime()
        //trimmerView.seek(to: playBackTime)
        
        if playBackTime >= endTime {
            videoView.player.seek(to: startTime,
                                  toleranceBefore: kCMTimeZero,
                                  toleranceAfter: kCMTimeZero)
            //trimmerView.seek(to: startTime)
        }
    }

    //MARK:-
    //MARK:- IB Actions

    @IBAction func cancelBtnAction(_ sender: Any)
    {
        //didCancel?()
       self.dismiss(animated: true, completion: nil)

    }

    @IBAction func doneBtnAction(_ sender: Any)
    {

         let showsFilters = YPConfig.showsFilters

        // One item flow
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.inputVideo.url)
        }) { saved, error in
            if saved {
                print(" Video is saved in gallery")
                //                let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                //                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                //                alertController.addAction(defaultAction)
                //                self.present(alertController, animated: true, completion: nil)
            }
        }

        if showsFilters {
            let postVideoVC = PostVideoViewController.initWith(video:  inputVideo,
                                                           isFromSelectionVC: false)
            postVideoVC.didSave = { [weak self] outputMedia in
                self?.didSelect(items: [outputMedia])
            }
            self.navigationController?.pushViewController(postVideoVC, animated: true)

        } else
        {
            self.didSelect(items: [YPMediaItem.video(v: inputVideo)])
        }



    }

}

// MARK: - TrimmerViewDelegate
//extension YPVideoFiltersVC: TrimmerViewDelegate {
//    public func positionBarStoppedMoving(_ playerTime: CMTime) {
//        videoView.player.seek(to: playerTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
//        videoView.play()
//        startPlaybackTimeChecker()
//        updateCoverPickerBounds()
//    }
//
//    public func didChangePositionBar(_ playerTime: CMTime) {
//        stopPlaybackTimeChecker()
//        videoView.pause()
//        videoView.player.seek(to: playerTime, toleranceBefore: kCMTimeZero, toleranceAfter:kCMTimeZero)
//    }
//}
//
//// MARK: - ThumbSelectorViewDelegate
//extension YPVideoFiltersVC: ThumbSelectorViewDelegate {
//    public func didChangeThumbPosition(_ imageTime: CMTime) {
//        if let imageGenerator = imageGenerator,
//            let imageRef = try? imageGenerator.copyCGImage(at: imageTime, actualTime: nil) {
//            coverImageView.image = UIImage(cgImage: imageRef)
//        }
//    }
//}
