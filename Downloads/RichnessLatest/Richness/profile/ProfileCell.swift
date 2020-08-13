//
//  ProfileCell.swift
//  Richness
//
//  Created by IOS3 on 07/02/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell
{

    @IBOutlet weak var userProfileCellView: UIView!
    @IBOutlet weak var userWallImage: UIImageView!
    @IBOutlet weak var userWallView: UIView!

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var userLikesBtn: UIButton!
    @IBOutlet weak var userFollowerBtn: UIButton!
    @IBOutlet weak var userFansBtn: UIButton!

    public var onCancelButtonTapped : (() ->Void)? = nil
    public var onSearchButtonTapped : (() ->Void)? = nil
    public var onNotificationButtonTapped : (() ->Void)? = nil
    public var onSettingButtonTapped : (() ->Void)? = nil
    public var onFolllowerButtonTapped : (() ->Void)? = nil
    public var onFansButtonTapped : (() ->Void)? = nil


    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code

        userProfileImage.layer.borderWidth = 1
        userProfileImage.layer.masksToBounds = false
        userProfileImage.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.737254902, blue: 0.5843137255, alpha: 1)
        userProfileImage.layer.cornerRadius = userProfileImage.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        userProfileImage.clipsToBounds = true
    }

    @IBAction func onCancelBtnTapped(_ sender: UIButton) {

        onCancelButtonTapped!()
    }

    @IBAction func onSearchBtnTapped(_ sender: UIButton) {

        onSearchButtonTapped!()
    }

    @IBAction func onNotificationBtnTapped(_ sender: UIButton) {

        onNotificationButtonTapped!()
    }

    @IBAction func onSettingBtnTapped(_ sender: UIButton) {

        onSettingButtonTapped!()
    }
    
    @IBAction func onFollowerBtnTapped(_ sender: UIButton) {
        
        onFolllowerButtonTapped!()
    }
    @IBAction func onFansBtnTapped(_ sender: UIButton) {
        
        onFansButtonTapped!()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
