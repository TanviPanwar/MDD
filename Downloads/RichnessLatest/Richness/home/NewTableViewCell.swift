//
//  NewTableViewCell.swift
//  Richness
//
//  Created by iOS6 on 24/04/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import UIKit
import AVFoundation

class NewTableViewCell: UITableViewCell , ASAutoPlayVideoLayerContainer {

    
    //MARK:- Outlets
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 5
        profileImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        profileImageView.layer.borderWidth = 0.5
        //self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resize
        profileImageView.layer.addSublayer(videoLayer)
        selectionStyle = .none
    }
    
    func configureCell(imageUrl: String?,
                       description: String,
                       videoUrl: String?) {
        // self.descriptionLabel.text = description
        self.profileImageView.imageURL = imageUrl
        self.videoURL = videoUrl
    }
    
    override func prepareForReuse() {
        profileImageView.imageURL = nil
        self.profileImageView.image = UIImage()
        self.playPauseBtn.setImage(nil, for: .normal)
        self.playPauseBtn.isHidden = true
        self.infoTextView.text = ""
        sideviewTrailingConstraint.constant = -87
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let horizontalMargin: CGFloat = 20
        let width: CGFloat = bounds.size.width - horizontalMargin * 2
        let height: CGFloat = (width * 0.9).rounded(.up)
        videoLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }
    
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(profileImageView.frame, from: profileImageView)
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
