//
//  CameraViewController.swift
//  Richness
//
//  Created by Sobura on 6/7/18.
//  Copyright © 2018 Sobura. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var encodeEmoji: String{
        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue){
            return encodeStr as String
        }
        return self
    }
}
extension String {
    var decodeEmoji: String{
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr{
            return str as String
        }
        return self
    }
}
class CameraViewController: PanelViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var innerImgView: UIImageView!
    @IBOutlet weak var profileImgView: UIImageView!
    
    @IBOutlet weak var shareButton: GradientButton!
    @IBOutlet weak var commentTxtView: UITextView!
    
    var image = UIImage()
    var ProfileImage : Data? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (self.owner as! MainViewController).cameraView = self
        commentTxtView.text = "Add a description here..."
        commentTxtView.layer.cornerRadius = 10
        commentTxtView.layer.masksToBounds = true
        commentTxtView.textColor = UIColor.gray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toProfileEdit))
        innerImgView.addGestureRecognizer(tap)
    }
    
    @objc func toProfileEdit() {
        
        let alertController = UIAlertController()
        
        let cameraButton = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            self.camera()
        })
        
        let  photoLibraryButton = UIAlertAction(title: "Photo Library", style: .default, handler: { (action) -> Void in
            
            self.photoLibrary()
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        })
        
        alertController.addAction(cameraButton)
        alertController.addAction(photoLibraryButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
    
        shareButton.layer.cornerRadius = shareButton.frame.height/2
        shareButton.layer.masksToBounds = true
        
        profileImgView.layer.cornerRadius = 30
        profileImgView.layer.masksToBounds = true
        innerImgView.layer.cornerRadius = 30
        innerImgView.layer.masksToBounds = true
        profileImgView.layer.borderColor = UIColor(displayP3Red: 242/255, green: 215/255, blue: 179/255, alpha: 1.0).cgColor
        profileImgView.layer.borderWidth = 5
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (commentTxtView.text == "Add a description here...") {
            commentTxtView.text = ""
            commentTxtView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if (commentTxtView.text == "") {
            commentTxtView.textColor = UIColor.gray
            commentTxtView.text = "Add a description here..."
        }
    }
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            myPickerController.allowsEditing = true
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func photoLibrary()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            myPickerController.allowsEditing = true
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.profileImgView.image = image
        
        self.ProfileImage = UIImageJPEGRepresentation(image, 0.8)
 
        dismiss(animated:true, completion: nil)
        
    }
    
    func postImage() {
        var comment : String = ""
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        
        if (commentTxtView.text == "Add a description here...") {
            comment = ""
        }
        else{
            comment = commentTxtView.text.encodeEmoji
        }
        
        let params = [
            "id" : RichnessUserDefault.getUserID(),
            "key" : key,
            "text" : comment
        ]
        print(params)
        
        RichnessAlamofire.showIndicator()
        RichnessAlamofire.shareInstance.upload(multipartFormData: { multipartFormData in
            
            if(self.ProfileImage != nil)
            {
                multipartFormData.append(self.ProfileImage!, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
            let contentDict = params
            for (key, value) in contentDict
            {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
            
        }, usingThreshold: RichnessAlamofire.multipartFormDataEncodingMemoryThreshold, to: ADDIMAGE_URL, method: .post, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)
                    
                    switch response.result {
                    case .success(let JSON):
                        let res = JSON as! NSDictionary
                        
                        if(res.object(forKey: "image_add") != nil){
                            
                            self.showSuccess(successMsg: "Image added successfully.")
                        }
                        else{
                            let error = res.object(forKey: "error") as? String
                            if (error == "#997") {
                                self.showError(errMsg: user_error_unknown)
                            }
                            else {
                                self.showError(errMsg: error_on_server)
                            }
                        }
                        RichnessAlamofire.hideIndicator()
                    case .failure(let error):
                        print(error)
                    }
                    RichnessAlamofire.hideIndicator()
                }
            case .failure(let encodingError):
                print(encodingError)
                RichnessAlamofire.hideIndicator()
            }
        })
    }
    @IBAction func onTapShare(_ sender: Any) {
            
        postImage()
    }
}
