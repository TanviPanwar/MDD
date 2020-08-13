//
//  ContactUsTableViewCell.swift
//  MDD
//
//  Created by iOS6 on 19/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit


class ContactUsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var partnerLabel: UILabel!
    @IBOutlet weak var memberTelePhoneLabel: UILabel!
    @IBOutlet weak var memberFLabel: UILabel!
    @IBOutlet weak var memberEmailLabel: UILabel!
    @IBOutlet weak var moreInfoBtn: UIButton!
    @IBOutlet weak var downloadVcareBtn: UIButton!
    
     public var onMoreInfoButtonTapped : (() ->Void)? = nil
     public var onDownloadVcareButtonTapped : (() ->Void)? = nil


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        moreInfoBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 2)
        downloadVcareBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 2)
   
    }
    
    
    @IBAction func moreInfoBtnAction(_ sender: Any) {
        
        onMoreInfoButtonTapped!()
        
    }
    
    @IBAction func downloadVcareBtnAction(_ sender: Any) {
        
        onDownloadVcareButtonTapped!()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
