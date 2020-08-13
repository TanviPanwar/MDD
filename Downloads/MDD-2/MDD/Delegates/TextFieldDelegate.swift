//
//  TextFieldDelegate.swift
//  Niah
//
//  Created by IOS3 on 12/03/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate : NSObject , UITextFieldDelegate  {
    
    var onCompletion  : ((Int) -> ())?
    var view = UIView()
    var source = String()
    var role = String()
    
    
    init(view : UIView?, source : String?,role :  String? , onCompletion : ((Int) -> ())?) {
        self.view = view!
        self.source = source!
        self.onCompletion = onCompletion
        self.role = role!
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let textFieldWithTag = view.viewWithTag(textField.tag + 1) as? UITextField {
            if self.role == "jobProvider"{
                if textField.tag == 6 {
                     textField.resignFirstResponder()
                    return true
                }
            }
            textFieldWithTag.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if source == "Edit Profile"{
            if let textFieldWithTag = view.viewWithTag(textField.tag) as? UITextField {

                onCompletion!(textField.tag)
            }
            
        }
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if source == "Edit Profile"{
            if let textFieldWithTag = view.viewWithTag(textField.tag) as? UITextField {
                onCompletion!(-textField.tag)
            }
            
        }else{
             onCompletion!(-textField.tag)
        }
    }

//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentText = textField.text ?? ""
//        guard let stringRange = Range(range, in: currentText) else { return false }
//        
//        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//        
//        return updatedText.count <= 10
//    }
//    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let currentText = textView.text ?? ""
//        guard let stringRange = Range(range, in: currentText) else { return false }
//        
//        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
//        
//        return changedText.count <= 10
//    }
    
    
//    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@._"
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    // if source == "Sign Up1"
//        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
//        let filtered = string.components(separatedBy: cs).joined(separator: "")
//
//        return (string == filtered)
//    }

}
