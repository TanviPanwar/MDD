//
//  AlertControllerDelegate.swift
//  Niah
//
//  Created by IOS3 on 27/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import Foundation
import UIKit


class AlertController {




    func addPictureBtnAction(view : UIView? , viewController : UIViewController? , title : String?, message : String? , imagePicker : UIImagePickerController? ,onCompletion : ((String) -> ())?) {


        let alertController : UIAlertController = UIAlertController(title: "Title", message: "Select Camera or Photo Library", preferredStyle: .actionSheet)

        let cameraAction : UIAlertAction = UIAlertAction(title: "Camera", style: .default, handler: {(cameraAction) in
            print("camera Selected...")

            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) == true {

                imagePicker!.sourceType = .camera
                viewController!.present(imagePicker!, animated: true, completion: nil)

            }else{

                Server.sharedInstance.showAlertwithTitle(title:"Alert", desc:"Camera is not available on this Device or accesibility has been revoked!" as String, vc: viewController!)



            }

        })

        let libraryAction : UIAlertAction = UIAlertAction(title: "Photo Library", style: .default, handler: {(libraryAction) in

            print("Photo library selected....")

            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) == true {

                imagePicker!.sourceType = .photoLibrary
                viewController!.present(imagePicker!, animated: true, completion: nil)

            }else{
                Server.sharedInstance.showAlertwithTitle(title:"Alert", desc:"Photo Library is not available on this Device or accesibility has been revoked!" as String, vc: viewController!)

            }
        })

        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel , handler: {(cancelActn) in
            print("Cancel action was pressed")
        })

        alertController.addAction(cameraAction)

        alertController.addAction(libraryAction)

        alertController.addAction(cancelAction)

        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = view!.frame
        onCompletion!("success")
        viewController!.present(alertController, animated: true, completion: nil)



    }








}
