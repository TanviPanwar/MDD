//
//  ImagePickerDelegate.swift
//  Niah
//
//  Created by IOS3 on 25/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import Foundation
import UIKit


class ImagePickerDelegate : NSObject , UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    var onCompletion  : ((UIImage) -> ())?
    var imageView = UIImageView()
    var viewController = UIViewController()
    
    
    init(imageView : UIImageView? , viewController : UIViewController? , onCompletion : ((UIImage) -> ())?) {
        self.imageView = imageView!
        self.viewController = viewController!
        self.onCompletion = onCompletion!
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        onCompletion!(image!)
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
}
