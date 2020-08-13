//
//  FollowersFanCell.swift
//  Richness
//
//  Created by IOS3 on 04/02/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import UIKit

class FollowersFanCell: UITableViewCell
{
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followUnfollowBtn: UIButton!

    public var onFollowUnfollowButtonTapped : (() ->Void)? = nil

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code

        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        //userProfileImage.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.737254902, blue: 0.5843137255, alpha: 1)
        profileImage.layer.cornerRadius = profileImage.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        profileImage.clipsToBounds = true

        followUnfollowBtn.layer.borderWidth = 1
        followUnfollowBtn.layer.masksToBounds = false
        followUnfollowBtn.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.737254902, blue: 0.5843137255, alpha: 1)
        followUnfollowBtn.layer.cornerRadius = 4
        followUnfollowBtn.clipsToBounds = true
    }

    @IBAction func followUnfollowBtnAction(_ sender: Any) {

        onFollowUnfollowButtonTapped!()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
