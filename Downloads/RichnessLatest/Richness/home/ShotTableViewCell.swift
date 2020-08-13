//
//  ShotTableViewCell.swift
//  Richness
//
//  Created by iOS6 on 25/04/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import UIKit
import AVFoundation
class ShotTableViewCell: UITableViewCell, ASAutoPlayVideoLayerContainer {
   
    //MARK:- Outlets
    @IBOutlet var shotImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var playPauseBtn: UIButton!
    
   
    @IBOutlet weak var infoTextView: UITextView!
    
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var sideImgView: UIImageView!
    @IBOutlet weak var sideBtn: UIButton!
    @IBOutlet weak var sideviewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoTextHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var likeButton: likeButton!
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
    
    
    var playPauseBool : Bool = false
    
    
    //MARK:- Variables
    var playerController: ASVideoPlayerController?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    
    
     var height = CGFloat()
    
    //MARK:- Object Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        shotImageView.layer.cornerRadius = 5
        shotImageView.backgroundColor = UIColor.black
        shotImageView.clipsToBounds = true
        shotImageView.layer.borderColor = UIColor.black.cgColor
        shotImageView.layer.borderWidth = 0.5
        //self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
      
        videoLayer.backgroundColor = UIColor.black.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        shotImageView.layer.addSublayer(videoLayer)
        selectionStyle = .none
        
        
       
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            print(UIApplication.shared.statusBarFrame.height)
            if UIScreen.main.bounds.size.height > 800 {
                if UIApplication.shared.statusBarFrame.height > 44 {
                    
                    height =
                        UIScreen.main.bounds.size.height - (UIApplication.shared.statusBarFrame.height - 20)
                } else {
                    height =   UIScreen.main.bounds.size.height - bottomPadding!
                }
            } else {
                if UIApplication.shared.statusBarFrame.height > 20 {
                    
                    height =
                        UIScreen.main.bounds.size.height - (UIApplication.shared.statusBarFrame.height - 20)
                } else {
                    height =   UIScreen.main.bounds.size.height
                }
            }
            
        }
        else {
            if UIApplication.shared.statusBarFrame.height > 20 {
                
                height =   UIScreen.main.bounds.size.height - (UIApplication.shared.statusBarFrame.height - 20)
            } else {
                height =   UIScreen.main.bounds.size.height
            }
            
        }
    }
    
    
    func configureCell(imageUrl: String?,
                       description: String,
                       videoUrl: String?) {
        // self.descriptionLabel.text = description
        self.shotImageView.imageURL = imageUrl
        self.videoURL = videoUrl
    }
    
    
    override func prepareForReuse() {
        shotImageView.imageURL = nil
        self.shotImageView.image = UIImage()
        self.playPauseBtn.setImage(nil, for: .normal)
        self.playPauseBtn.isHidden = true
        self.infoTextView.text = ""
        sideviewTrailingConstraint.constant = -87
        super.prepareForReuse()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        
        videoLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height )
    }
    
    
    
    func visibleVideoHeight() -> CGFloat {
        let window = UIApplication.shared.keyWindow
        
        let bottomPadding = window?.safeAreaInsets.bottom
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(CGRect(x:0, y: 0, width: UIScreen.main.bounds.size.width, height: height), from: shotImageView)
        print("shotImageView.frame **** \(shotImageView.frame)")
        guard let videoFrame = videoFrameInParentSuperView,
            let superViewFrame = superview?.frame else {
                return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
    
    //MARK:- Actions
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
    
    
}
