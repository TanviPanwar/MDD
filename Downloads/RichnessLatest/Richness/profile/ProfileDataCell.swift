//
//  ProfileDataCell.swift
//  Richness
//
//  Created by IOS3 on 07/02/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import UIKit

class ProfileDataCell: UITableViewCell
{

//    @IBOutlet weak var userLikesBtn: UIButton!
//    @IBOutlet weak var userFollowerBtn: UIButton!
//    @IBOutlet weak var userFansBtn: UIButton!

    @IBOutlet weak var userDataCollectionView: UICollectionView!

//    public var onFolllowerButtonTapped : (() ->Void)? = nil
//    public var onFansButtonTapped : (() ->Void)? = nil



    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

//    @IBAction func onFollowerBtnTapped(_ sender: UIButton) {
//
//        onFolllowerButtonTapped!()
//    }
//    @IBAction func onFansBtnTapped(_ sender: UIButton) {
//
//        onFansButtonTapped!()
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
