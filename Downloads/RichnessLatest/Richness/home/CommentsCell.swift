//
//  CommentsCell.swift
//  Richness
//
//  Created by IOS3 on 16/01/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell
{
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var totalLikesLabel: UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code

        cellImg.layer.borderWidth = 1
        cellImg.layer.masksToBounds = false
        cellImg.layer.borderColor = #colorLiteral(red: 0.8470588235, green: 0.6823529412, blue: 0.4901960784, alpha: 1)
        cellImg.layer.cornerRadius = cellImg.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        cellImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
