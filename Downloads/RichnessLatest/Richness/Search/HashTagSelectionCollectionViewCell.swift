//
//  HashTagSelectionCollectionViewCell.swift
//  Richness
//
//  Created by IOS3 on 12/02/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import UIKit
import AVFoundation

class HashTagSelectionCollectionViewCell: UICollectionViewCell, ASAutoPlayVideoLayerContainer
{
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var backBtn: UIButton!
  
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var sideImgView: UIImageView!
    @IBOutlet weak var sideBtn: UIButton!
    @IBOutlet weak var sideviewTrailingConstraint: NSLayoutConstraint!
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
    public var backButtonTapped : (() ->Void)? = nil
    public var onDiamondButtonTapped : (() ->Void)? = nil
    public var on3DotButtonTapped : (() ->Void)? = nil
    public var onProfileTapped : (() ->Void)? = nil
    public var onAvatarTapped : (() ->Void)? = nil
    public var addFollowerTapped : (() ->Void)? = nil


    var playerController: ASVideoPlayerController?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                
               
                DispatchQueue.global(qos: .background).async {
                    ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
//                    DispatchQueue.main.async {
//                        self.playPauseBtn.setImage(#imageLiteral(resourceName: "pause-video"), for: .normal)
//                        // self.activityIndicator.stopAnimating()
//                    }
//                    
//                    let url1 = URL(string: videoURL)
//                    if url1 != nil {
//                        let track = AVAsset(url: url1!).tracks(withMediaType: AVMediaType.video).first
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
//                        DispatchQueue.main.async {
//                            self.playPauseBtn.setImage(#imageLiteral(resourceName: "pause-video"), for: .normal)
//                            self.activityIndicator.stopAnimating()
//                            self.activityIndicator.isHidden = true
//                        }
//                    }
                   
                    
                }
            }
            videoLayer.isHidden = videoURL == nil
        }
    }


    func configureCell(imageUrl: String?,
                       description: String,
                       videoUrl: String?) {

        //        if description != "Image" {
        videoURL = videoUrl
        //        } else {
        //           videoLayer.player = nil
        //            videoLayer.player?.pause()
        //videoURL = nil
        // }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // self.videoLayer.player?.pause()
        self.profileImageView.image = UIImage()
        self.playPauseBtn.setImage(nil, for: .normal)
        self.playPauseBtn.isHidden = true
        self.infoTextView.text = ""
        sideviewTrailingConstraint.constant = -87
    }
    
    @IBAction func onPlayPause(_ sender: UIButton) {
        
        onPlayPauseButtonTapped!()
    }

    @IBAction func onBackButtonTapped(_ sender: UIButton) {

        backButtonTapped!()
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

    override func layoutSubviews() {
        super.layoutSubviews()
        videoLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

    }

    func visibleVideoHeight() -> CGFloat {
        return self.frame.height
    }

}




