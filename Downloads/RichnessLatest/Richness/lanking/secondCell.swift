//
//  secondCell.swift
//  Richness
//
//  Created by Sobura on 6/6/18.
//  Copyright © 2018 Sobura. All rights reserved.
//

import UIKit

class secondCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        cellView.layer.borderWidth = 1
        cellView.layer.masksToBounds = false
        cellView.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.737254902, blue: 0.5843137255, alpha: 1)
        cellView.layer.cornerRadius = 4 //This will change with corners of image and height/2 will make this circle shape
        cellView.clipsToBounds = true
        
        avatarImgView.roundImgView(borderColor: UIColor(displayP3Red: 120/255, green: 118/255, blue: 115/255, alpha: 1.0))
        scoreLabel.layer.cornerRadius = scoreLabel.frame.height/2
        scoreLabel.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
