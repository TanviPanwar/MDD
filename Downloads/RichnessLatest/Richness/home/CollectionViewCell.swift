//
//  CollectionViewCell.swift
//  Richness
//
//  Created by IOS3 on 28/01/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import UIKit
import AVFoundation


class CollectionViewCell: UICollectionViewCell, ASAutoPlayVideoLayerContainer
{
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var playPauseBtn: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var infoTextView: UITextView!
    
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var sideImgView: UIImageView!
    @IBOutlet weak var sideBtn: UIButton!
    @IBOutlet weak var sideviewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var infoTextHeightConstarint: NSLayoutConstraint!
    
    @IBOutlet weak var searchBtn: UIButton!


    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var likeButton: likeButton!

    @IBOutlet weak var likesBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var rankingBtn: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var addFollowerImage: UIImageView!
    @IBOutlet weak var addfollowerBtn: UIButton!

    public var onPlayPauseButtonTapped : (() ->Void)? = nil
    public var onDiamondButtonTapped : (() ->Void)? = nil
    public var on3DotButtonTapped : (() ->Void)? = nil
    public var onProfileTapped : (() ->Void)? = nil
    public var onAvatarTapped : (() ->Void)? = nil
    public var addFollowerTapped : (() ->Void)? = nil
  //  public var searchButtonTapped : (() ->Void)? = nil
    
    var playPauseBool : Bool = false


    var playerController: ASVideoPlayerController?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                
               // DispatchQueue.global(qos: .background).async {
                    
                    ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
//                    let url1 = URL(string: videoURL)
//                    
//                    if url1 != nil {
//                        
//                        self.encodeVideo(url1!)
//                    }
                    
//                    if url1 != nil {
//                        let track = AVAsset(url: url1!).tracks(withMediaType: AVMediaType.video).first
//
//
//                        let size = track!.naturalSize.applying(track!.preferredTransform)
//                        //CGSize(width: fabs(size.width), height: fabs(size.height))
//                        print(CGSize(width: fabs(size.width), height: fabs(size.height)))
//                        if fabs(size.height) > fabs(size.width) {
//                            self.videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//                        }
//
//                        else {
//                            self.videoLayer.videoGravity = AVLayerVideoGravity.resizeAspect
//                        }
//
//                            DispatchQueue.main.async {
//                                self.playPauseBtn.setImage(#imageLiteral(resourceName: "pause-video"), for: .normal)
//                                self.activityIndicator.stopAnimating()
//                                self.activityIndicator.isHidden = true
//                            }
//
//                    }
              //  }
       
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
            self.videoLayer.backgroundColor = UIColor.clear.cgColor
            self.videoLayer.videoGravity = AVLayerVideoGravity.resizeAspect
            self.videoView.layer.addSublayer(self.videoLayer)
      
       
        
    }
    
    
    
    func encodeVideo(_ videoURL: URL)  {
        
        let avAsset = AVURLAsset(url: videoURL, options: nil)
        
        let startDate = Foundation.Date()
        
        //Create Export session
        let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)
        
        // exportSession = AVAssetExportSession(asset: composition, presetName: mp4Quality)
        //Creating temp path to save the converted video
        
        
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let myDocumentPath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("temp.mov").absoluteString
        let url = URL(fileURLWithPath: myDocumentPath)
        
        let documentsDirectory2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        
        let filePath = documentsDirectory2.appendingPathComponent("rendered-Video.mov")
        deleteFile(filePath)
        
        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: myDocumentPath) {
            do {
                try FileManager.default.removeItem(atPath: myDocumentPath)
            }
            catch let error {
                print(error)
            }
        }
        
        
        
        exportSession!.outputURL = filePath
        exportSession!.outputFileType = AVFileType.mov
        exportSession!.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, 0)
        let range = CMTimeRangeMake(start, avAsset.duration)
        exportSession?.timeRange = range
        
        exportSession!.exportAsynchronously(completionHandler: {() -> Void in
            switch exportSession!.status {
            case .failed:
                print("%@",exportSession?.error)
            case .cancelled:
                print("Export canceled")
            case .completed:
                //Video conversion finished
                let endDate = Foundation.Date()
                
                let time = endDate.timeIntervalSince(startDate)
                print(time)
                print("Successful!")
                print(exportSession?.outputURL)
                let mediaPath = exportSession!.outputURL?.path
                
                if videoURL != nil {
                    let track = AVAsset(url: (exportSession?.outputURL)!).tracks(withMediaType: AVMediaType.video).first
                    let size = track!.naturalSize.applying(track!.preferredTransform)
                    //CGSize(width: fabs(size.width), height: fabs(size.height))
                    print(CGSize(width: fabs(size.width), height: fabs(size.height)))
                    if fabs(size.height) > fabs(size.width) {
                        self.videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    }
                        
                    else {
                        self.videoLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                    }
                    
                    DispatchQueue.main.async {
                        self.playPauseBtn.setImage(#imageLiteral(resourceName: "pause-video"), for: .normal)
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    }
                }
                //self.mediaPath = String(self.exportSession.outputURL!)
            // self.mediaPath = self.mediaPath.substringFromIndex(7)
            default:
                break
            }
            
        })
        
        
    }
    
    func deleteFile(_ filePath:URL) {
        guard FileManager.default.fileExists(atPath: filePath.path) else {
            return
        }
        
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
        }catch{
            fatalError("Unable to delete file: \(error) : \(#function).")
        }
    }
    
    

   
    func configureCell(imageUrl: String?,
                       description: String,
                       videoUrl: String?) {

//        if description != "Image" {
         videoURL = videoUrl
       // ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL!)
//        } else {
//           videoLayer.player = nil
//            videoLayer.player?.pause()
          //videoURL = nil
       // }
    }

    override func prepareForReuse() {
     
       // self.videoLayer.player?.pause()
        
        self.profileImageView.image = UIImage()
        self.playPauseBtn.setImage(nil, for: .normal)
        self.playPauseBtn.isHidden = true
        self.infoTextView.text = ""
        sideviewTrailingConstraint.constant = -87
           super.prepareForReuse()
    }
    
    @IBAction func onPlayPause(_ sender: UIButton) {
        
        onPlayPauseButtonTapped!()
    }
    
    @IBAction func onTapDiamond(_ sender: likeButton) {

        onDiamondButtonTapped!()
    }
    @IBAction func onTap3Dot(_ sender: UIButton) {

        on3DotButtonTapped!()
    }
    @IBAction func onTapProfile(_ sender: UIButton) {
        onProfileTapped!()
    }
    @IBAction func onTapAvatar(_ sender: UIButton) {
        onAvatarTapped!()
    }
    @IBAction func onAddFollower(_ sender: UIButton) {
        addFollowerTapped!()
    }


//    @IBAction func onSearchButtonTapped(_ sender: UIButton) {
//        searchButtonTapped!()
//    }

    override func layoutSubviews() {
        super.layoutSubviews()
            videoLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
       
        
    }
    


    func visibleVideoHeight() -> CGFloat {
        return self.frame.height
    }
    
}


