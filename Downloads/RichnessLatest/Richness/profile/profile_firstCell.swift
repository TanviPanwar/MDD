//
//  profile_firstCell.swift
//  Richness
//
//  Created by Sobura on 6/7/18.
//  Copyright © 2018 Sobura. All rights reserved.
//

import UIKit

class profile_firstCell: UITableViewCell {

    @IBOutlet weak var avatarImgView: UIImageView!
    
    @IBOutlet weak var lblRanking: UILabel!
    @IBOutlet weak var infoTxtView: UITextView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    public var onAvatarButtonTapped : (() ->Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        
        avatarImgView.image = nil
        
    }
    
     override func layoutSubviews() {
        
        avatarImgView.layer.cornerRadius = avatarImgView.frame.width/2
        avatarImgView.layer.masksToBounds = true
        avatarImgView.layer.borderColor = UIColor(displayP3Red: 254/255, green: 207/255, blue: 133/255, alpha: 1.0).cgColor
        avatarImgView.layer.borderWidth = 3
    }
    @IBAction func onTapAvatar(_ sender: UIButton) {
        
        onAvatarButtonTapped!()
    }
}
