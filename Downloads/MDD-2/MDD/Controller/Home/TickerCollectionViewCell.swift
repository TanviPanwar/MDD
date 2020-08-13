//
//  TickerCollectionViewCell.swift
//  MDD
//
//  Created by iOS6 on 14/02/20.
//  Copyright © 2020 IOS3. All rights reserved.
//

import UIKit

class TickerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
   
    @IBOutlet weak var pdfBtn: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
      public var onPdfTapped: (() ->Void)? = nil
 
    @IBAction func pdfBtnAction(_ sender: Any) {
        
        onPdfTapped!()
        
    }
    
  
}
