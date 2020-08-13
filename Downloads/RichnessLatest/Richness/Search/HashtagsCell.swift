//
//  HashtagsCell.swift
//  Richness
//
//  Created by IOS3 on 31/01/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import UIKit

class HashtagsCell: UITableViewCell
{
    @IBOutlet weak var hashtagCellView: UIView!
    @IBOutlet weak var hashtagImage: UIImageView!
    @IBOutlet weak var hastagLabel: UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
