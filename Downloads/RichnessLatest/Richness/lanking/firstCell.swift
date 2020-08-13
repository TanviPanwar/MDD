//
//  firstCell.swift
//  Richness
//
//  Created by Sobura on 6/6/18.
//  Copyright © 2018 Sobura. All rights reserved.
//

import UIKit

class firstCell: UITableViewCell {

    @IBOutlet weak var thirdScoreView: GradientView!
    @IBOutlet weak var secondScoreView: GradientView!
    @IBOutlet weak var firstScoreView: GradientView!
    
    @IBOutlet weak var lbl1stCountry: UILabel!
    @IBOutlet weak var lbl2ndCountry: UILabel!
    @IBOutlet weak var lbl3thCountry: UILabel!
    @IBOutlet weak var lbl3thName: UILabel!
    @IBOutlet weak var lbl2ndName: UILabel!
    @IBOutlet weak var lbl1stName: UILabel!
    @IBOutlet weak var lbl3thScore: UILabel!
    @IBOutlet weak var lbl2ndScore: UILabel!
    @IBOutlet weak var lbl1stScore: UILabel!
    @IBOutlet weak var firstAvatarImgView: UIImageView!
    @IBOutlet weak var thirdAvatarImgView: UIImageView!
    @IBOutlet weak var secondAvatarImgView: UIImageView!
    
    public var on1stAvatarButtonTapped : (() ->Void)? = nil
    public var on2ndAvatarButtonTapped : (() ->Void)? = nil
    public var on3rdAvatarButtonTapped : (() ->Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        firstAvatarImgView.roundImgView(borderColor: #colorLiteral(red: 0.9450980392, green: 0.8470588235, blue: 0.7137254902, alpha: 1))
        secondAvatarImgView.roundImgView(borderColor:#colorLiteral(red: 0.9450980392, green: 0.8470588235, blue: 0.7137254902, alpha: 1))
        thirdAvatarImgView.roundImgView(borderColor: #colorLiteral(red: 0.9450980392, green: 0.8470588235, blue: 0.7137254902, alpha: 1))
        
//        firstScoreView.layer.cornerRadius = firstScoreView.frame.height/2
//        firstScoreView.layer.masksToBounds = true
//        secondScoreView.layer.cornerRadius = secondScoreView.frame.height/2
//        secondScoreView.layer.masksToBounds = true
//        thirdScoreView.layer.cornerRadius = thirdScoreView.frame.height/2
//        thirdScoreView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onTap1thAvatar(_ sender: UIButton) {
        
        on1stAvatarButtonTapped!()
    }
    
    @IBAction func onTap2ndAvatar(_ sender: UIButton) {
        
        on2ndAvatarButtonTapped!()
    }
    
    @IBAction func onTap3rdAvatar(_ sender: UIButton) {
        on3rdAvatarButtonTapped!()
    }
    
}
