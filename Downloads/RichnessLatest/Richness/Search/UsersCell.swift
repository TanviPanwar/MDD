//
//  UsersCell.swift
//  Richness
//
//  Created by IOS3 on 31/01/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import UIKit

class UsersCell: UITableViewCell
{

    @IBOutlet weak var userCellView: UIView!    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followUnfollowBtn: UIButton!

      public var onFollowUnfollowButtonTapped : (() ->Void)? = nil
    

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code

        userProfileImage.layer.borderWidth = 1
        userProfileImage.layer.masksToBounds = false
        //userProfileImage.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.737254902, blue: 0.5843137255, alpha: 1)
        userProfileImage.layer.cornerRadius = userProfileImage.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        userProfileImage.clipsToBounds = true

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
