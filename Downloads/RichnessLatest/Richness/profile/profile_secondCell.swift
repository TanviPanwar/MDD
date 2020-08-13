//
//  profile_secondCell.swift
//  Richness
//
//  Created by Sobura on 6/7/18.
//  Copyright © 2018 Sobura. All rights reserved.
//

import UIKit

class profile_secondCell: UITableViewCell {

    @IBOutlet weak var likeButton: likeButton!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var infoTxtView: UITextView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    public var onDiamondButtonTapped : (() ->Void)? = nil
    public var on3DotButtonTapped : (() ->Void)? = nil
    public var onProfileTapped : (() ->Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        
        avatarImgView.layer.cornerRadius = avatarImgView.frame.width/2
        avatarImgView.layer.masksToBounds = true
        avatarImgView.layer.borderColor = UIColor(displayP3Red: 254/255, green: 207/255, blue: 133/255, alpha: 1.0).cgColor
        avatarImgView.layer.borderWidth = 3
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
}
