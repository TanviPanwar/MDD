//
//  Extensions.swift
//  MDD
//
//  Created by iOS6 on 21/08/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class Extensions: NSObject {
    
}

extension UITextField {
    func textFieldWithRightView(width:CGFloat , icon:UIImage) {
        self.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        imageView.image = icon
        imageView.tintColor = .lightGray
        imageView.contentMode = .center
        self.rightView = imageView
    }
}
