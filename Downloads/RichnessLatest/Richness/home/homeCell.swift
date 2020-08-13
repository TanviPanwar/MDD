//
//  profileCell.swift
//  Richness
//
//  Created by Sobura on 6/6/18.
//  Copyright © 2018 Sobura. All rights reserved.
//

import UIKit
import AVFoundation
class homeCell: UITableViewCell , ASAutoPlayVideoLayerContainer{

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var videoView: UIView!
   // @IBOutlet weak var likeButton: likeButton!
    @IBOutlet weak var likeButton: likeButton!
    @IBOutlet weak var infoTxtView: UITextView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var sideImgView: UIImageView!
    @IBOutlet weak var sideBtn: UIButton!
    @IBOutlet weak var sideviewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBtn: UIButton!



    @IBOutlet weak var profileBtn: UIButton!    
    @IBOutlet weak var profileImg: UIImageView!
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







    
    public var onDiamondButtonTapped : (() ->Void)? = nil
    public var on3DotButtonTapped : (() ->Void)? = nil
    public var onProfileTapped : (() ->Void)? = nil
    public var onAvatarTapped : (() ->Void)? = nil
    public var addFollowerTapped : (() ->Void)? = nil
    public var searchButtonTapped : (() ->Void)? = nil


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
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        self.videoView.layer.addSublayer(videoLayer)
        
      //  avatarImgView.layer.cornerRadius = 25
       // avatarImgView.layer.masksToBounds = true
      //  avatarImgView.layer.borderColor = UIColor(displayP3Red: 254/255, green: 207/255, blue: 133/255, alpha: 1.0).cgColor
       // avatarImgView.layer.borderWidth = 3

//        sideView.frame = CGRect(x: sideView.frame.origin.x + sideView.frame.origin.y, y:sideView.frame.origin.y, width: sideView.frame.size.width, height: sideView.frame.size.height)

        profileImg.layer.borderWidth = 1
        profileImg.layer.masksToBounds = false
        profileImg.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.737254902, blue: 0.5843137255, alpha: 1)
        profileImg.layer.cornerRadius = profileImg.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        profileImg.clipsToBounds = true

    }
    func configureCell(imageUrl: String?,
                       description: String,
                       videoUrl: String?) {
        
        self.videoURL = videoUrl
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profileImgView.image = UIImage()
        self.infoTxtView.text = ""
        sideviewTrailingConstraint.constant = -87
    }

//    @IBAction func onTapDiamond(_ sender: Any) {
//    }
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

    @IBAction func onSearchButtonTapped(_ sender: UIButton) {
        searchButtonTapped!()
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        videoLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.frame.height)
    }
    
    func visibleVideoHeight() -> CGFloat {
       
        return self.frame.height
    }
}

