//
//  HireMDDViewController.swift
//  MDD
//
//  Created by iOS6 on 10/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import AssetsPickerViewController
import AssetsLibrary
import Photos
import CoreServices
import Alamofire
import MobileCoreServices
import Photos
import CoreServices
import IQKeyboardManagerSwift





class HireMDDViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentPickerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    
    
    
    //MARK:- Outlets
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var yesView: UIView!
    @IBOutlet weak var noView: UIView!
    @IBOutlet weak var selectOptionTextField: UITextField!
    @IBOutlet weak var lossLocationTextField: UITextField!
    @IBOutlet weak var industryTextField: UITextField!
    @IBOutlet weak var insuredTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var dropLineTextField: UITextField!
    @IBOutlet weak var uplaodFileBtn: UIButton!
    @IBOutlet weak var chooseFileLabel: UILabel!
    @IBOutlet weak var documentTypeView: UIView!
    @IBOutlet weak var documentBtn: UIButton!
    @IBOutlet weak var dropLineTextView: IQTextView!
  
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet var pickerInputView: UIView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cancelToolBarBtn: UIBarButtonItem!
    @IBOutlet weak var doneToolBarBtn: UIBarButtonItem!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var myPickerController = UIImagePickerController()
    var index = Int()
    var assets = [PHAsset]()
    var urlsAarray = [URL]()
    var type = String()
    var locationArray = [CategoryObjectModel]()
    var locationsArray = NSArray()
    var industryArray = NSArray()
    var textFieldTag = Int()
    var inputCheckBox = ""
    var getSizeChk = Bool()
    var fileData: Data?
    var mimeType = String()
    var mimeTypeValue = String()
    var fileUrl: URL?
    var checkBool = Bool()
    var check = false
 
    //MARK:- Object Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var height = CGFloat()
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            height = 43
            cancelToolBarBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)], for: .normal)
            doneToolBarBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)], for: .normal)
            
        }
        
        else {
            
            height = 33
        }
        
          uplaodFileBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: height/2)
          submitBtn.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 6)
        
        
        selectOptionTextField.attributedPlaceholder = NSAttributedString(string: "-- Select -Option --",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)])
        lossLocationTextField.attributedPlaceholder = NSAttributedString(string: "Enter Loss Location",
                                                           attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)])
        industryTextField.attributedPlaceholder = NSAttributedString(string: "-- Select -Option --",
                                                              attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)])
        insuredTextField.attributedPlaceholder = NSAttributedString(string: "Name of Insured",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)])
        numberTextField.attributedPlaceholder = NSAttributedString(string: "Enter Insured Contact Name",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)])
        selectOptionTextField.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        industryTextField.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        self.selectOptionTextField.textFieldWithRightView(width:15, icon:#imageLiteral(resourceName: "drop-down"))
        self.industryTextField.textFieldWithRightView(width:15, icon:#imageLiteral(resourceName: "drop-down"))

        
        showPicker()
        //locationApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if check == false {
            locationApi()
        }
        
    }
    
    //MARK:-
    //MARK:- Custom Methods
    
    @objc func showPicker()
    {
        selectOptionTextField.inputView = pickerInputView
        selectOptionTextField.inputAccessoryView = nil
        industryTextField.inputView = pickerInputView
        industryTextField.inputAccessoryView = nil
        
    }
    
    //MARK:-
    //MARK:- TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == selectOptionTextField {
            
            textFieldTag = textField.tag
            showPicker()
            pickerView.reloadAllComponents()
        }
        
        else if textField == industryTextField {
            
            textFieldTag = textField.tag
            showPicker()
            pickerView.reloadAllComponents()
        }
       
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == dropLineTextView {
        
            textView.textContainer.maximumNumberOfLines = 4
            textView.textContainer.lineBreakMode = .byTruncatingTail
        
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
    //Mark:-
    //MARK:- IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        if checkBool {
            
            self.dismiss(animated: true, completion: nil)
        }
            
        else {
            
            sideMenuController?.setContentViewController(with: "\(7)", animated: Preferences.shared.enableTransitionAnimation)
            
            sideMenuController?.hideMenu()
            
        }
        
    }
    
    
    @IBAction func cancelBtnAction(_ sender: Any) {
       
        self.view.endEditing(true)
        
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        
        let row = pickerView.selectedRow(inComponent: 0)
        if textFieldTag == 1 {
            selectOptionTextField.text = (locationsArray[row] as? String)?.html2String
        }
            
        else {
            industryTextField.text = (industryArray[row] as? String)?.html2String
        }
        
        self.view.endEditing(true)
        
    }
    
    
    @IBAction func yesBtnAction(_ sender: Any) {
        
        yesView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        noView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)

    }
    
    
    @IBAction func noBtnAction(_ sender: Any) {
        
        noView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        yesView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)

    }
    
    
    @IBAction func uploadFileBtnAction(_ sender: Any) {
        
        let alertController = UIAlertController()//(title:"", message:"", preferredStyle: .actionSheet)
        let cameraAction =  UIAlertAction(title:"Camera", style:.default) { (action) in
            self.camera()
        }
        let galleryAction = UIAlertAction(title:"Gallery", style:.default) { (action) in
            self.photoLibrary()
        }
        let browseAction = UIAlertAction(title:"Browse", style:.default) { (action) in
            
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypeMovie), String(kUTTypeWaveformAudio) , String(kUTTypeAudio), String(kUTTypeVideo), String(kUTTypePlainText), String(kUTTypeMP3)], in: .import)
            documentPicker.allowsMultipleSelection = true
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = .formSheet
            self.present(documentPicker, animated: true, completion: nil)
            
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .default, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(browseAction)
        alertController.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            alertController.popoverPresentationController?.sourceView = sender as? UIView //self.view
            alertController.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds

        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func documentTypeBtnAction(_ sender: Any) {
      
        if (documentBtn.currentImage?.isEqual(UIImage(named: "check")))! {
        
            documentBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            inputCheckBox = ""
        }
        else {
           
            documentBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            inputCheckBox = "yes"

        }
    }
    
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        hireMddApi()
    }
    
    
    
    //MARK:- PickerView Delegate methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if textFieldTag == 1 {
        return self.locationsArray.count
            
        }
        
        else {
            
            return self.industryArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {

        let pickerLabel = UILabel()
       
        if textFieldTag == 1 {
            pickerLabel.text = (locationsArray[row] as? String)?.html2String
         
        }
        
        else {
            pickerLabel.text = (industryArray[row] as? String)?.html2String
           
        }

        if UIDevice.current.userInterfaceIdiom == .pad {
            
            
            pickerLabel.font = UIFont.systemFont(ofSize: 30)
        }
        pickerLabel.lineBreakMode = .byWordWrapping
        pickerLabel.numberOfLines = 0
        pickerLabel.sizeToFit()
      
        return pickerLabel
    }
 
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            return 50.0
        }
        
        return 30.0
    }
    
    
    private func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: "some string", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        return attributedString

  }
    
    
    //MARK:-
    //MARK:- API Methods
    
    func locationApi()
    {
        
        let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.loggedInUserID)
        
        if userId is String  {
            
            let params = ["user_id":userId!] as [String: Any]
            print(params)
            
            if Server.sharedInstance.isInternetAvailable()
            {
                
                DispatchQueue.main.async {
                    
                    Server.sharedInstance.showLoader()
                    
                }
                
                
                Alamofire.request(K_Base_Url+K_HireMddLocation_Url, method: .post,  parameters: nil, encoding: URLEncoding.default, headers:nil)
                    .responseJSON { response in
                        
                        Server.sharedInstance.stopLoader()
                        self.check = true
                        
                        // check for errors
                        guard response.result.error == nil else {
                            // got an error in getting the data, need to handle it
                            print("error calling GET on /todos/1")
                            print(response.result.error!)
                            return
                        }
                        print(response.result.value!)
                        // make sure we got some JSON since that's what we expect
                        guard let json = response.result.value as? [String: Any] else {
                            print("didn't get todo object as JSON from API")
                            if let error = response.result.error {
                                print("Error: \(error)")
                            }
                            return
                        }
                        
                        print(json)
                        // let status = json["status"] as? Int
                        let status = Server.sharedInstance.checkResponseForString(jsonKey:"success", dict: json as NSDictionary)
                        let msg = Server.sharedInstance.checkResponseForString(jsonKey:"message", dict: json as NSDictionary)
                        if status.boolValue {
                            
                            
                            if let response = json["repsonse"] as? NSArray , response.count > 0 {
                                
                                if let array = (response[0] as AnyObject).value(forKey: "location") as? NSArray {
                                    
                                    self.selectOptionTextField.isUserInteractionEnabled = true
                                    self.selectOptionTextField.isEnabled = true
                                     self.locationsArray = array
                                    
                                }
                                
                                else {
                                    
                                    self.selectOptionTextField.isUserInteractionEnabled = false
                                    self.selectOptionTextField.isEnabled = false
                                    
                                }
                                
                                if let array1 = (response[0] as AnyObject).value(forKey: "Industry") as? NSArray {
                                    
                                    self.industryTextField.isUserInteractionEnabled = true
                                    self.industryTextField.isEnabled = true
                                     self.industryArray = array1
                                    
                                }
                                
                                else {
                                    
                                    self.industryTextField.isUserInteractionEnabled = false
                                    self.industryTextField.isEnabled = false
                                    
                                }

                                self.pickerView.reloadAllComponents()
                            }
                            
                            
                        }
                        else {
                            
                            DispatchQueue.main.async {
                                
                                self.selectOptionTextField.isUserInteractionEnabled = false
                                self.selectOptionTextField.isEnabled = false
                                self.industryTextField.isUserInteractionEnabled = false
                                self.industryTextField.isEnabled = false
                                Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                                
                            }
                        }
                }
                
            }
                
            else {
                DispatchQueue.main.async(execute: {
                
                    self.selectOptionTextField.isUserInteractionEnabled = false
                    self.selectOptionTextField.isEnabled = false
                    self.industryTextField.isUserInteractionEnabled = false
                    self.industryTextField.isEnabled = false
                    Server.sharedInstance.showSnackBarAlert(desc:"Internet connection lost, please check your internet connection.")
                })
            }
        }
            
        else {
           
            Server.sharedInstance.showSnackBarAlert(desc:"UserId is empty.")
            
        }
    }
    
    
    func hireMddApi()
    {
        
        self.view.endEditing(true)
        
        if Server.sharedInstance.isInternetAvailable()
        {
            var name = String()
            var phoneNumber = String()
            var email = String()
            let location:String = (selectOptionTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
            let lossLocation:String = (lossLocationTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
            let industry:String = (industryTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
            let insuredName:String = (insuredTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
            let insuredContactName:String = (numberTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
            let briefDescription:String = (dropLineTextView.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
            
            let userDefaults = UserDefaults.standard
            if (userDefaults.value(forKey: DefaultsIdentifier.name) != nil) {
                
                name = userDefaults.value(forKey: DefaultsIdentifier.name) as! String
                
            }
            
            if (userDefaults.value(forKey: DefaultsIdentifier.phoneNumber) != nil) {
                
                phoneNumber =  userDefaults.value(forKey: DefaultsIdentifier.phoneNumber) as! String
                
            }
            
            if (userDefaults.value(forKey: DefaultsIdentifier.loggedInEmailID) != nil) {
                
                email =  userDefaults.value(forKey: DefaultsIdentifier.loggedInEmailID) as! String
                
            }
            
            if location.isEmpty {
                
                Server.sharedInstance.showSnackBarAlert(desc: "Please select the office you want to work with.")
   
            }
            else if lossLocation.isEmpty {
                
                Server.sharedInstance.showSnackBarAlert(desc: "Loss location is required.")
                
            }
                
            else if lossLocation.count < 3 {
                
                Server.sharedInstance.showSnackBarAlert(desc: "Loss location should be atleast 3 characters.")
                
            }
                
            else if industry.isEmpty {
                
                Server.sharedInstance.showSnackBarAlert(desc: "Please select the industry.")
                
            }
                
            else if insuredName.isEmpty {
                
                Server.sharedInstance.showSnackBarAlert(desc: "Name of insured is required.")
                
            }
                
            else if insuredName.count < 3 {
                
                Server.sharedInstance.showSnackBarAlert(desc: "Name of insured should be atleast 3 characters.")
                
            }
                
            else if insuredContactName.isEmpty {
                
                Server.sharedInstance.showSnackBarAlert(desc: "Insured contact name is required.")
                
            }
                
            else if insuredContactName.count < 3 {
                
                Server.sharedInstance.showSnackBarAlert(desc: "Insured contact name should be atleast 3 characters.")
                
            }
                
            else if briefDescription.isEmpty {
                
                Server.sharedInstance.showSnackBarAlert(desc: "Brief explanation is required.")
                
            }
                
    
            else {
                
                let params = ["full_name":name, "email":email, "company":"fhfffhfh", "phoneNumber":phoneNumber,"losslocation":lossLocation,
                    "industry":industry,"insuredname":insuredName, "insured_contact_name":insuredContactName,
                    "input_checkbox":inputCheckBox, "location":location, "brief_description":briefDescription] as [String: Any]
                print(params)
                
                DispatchQueue.main.async {
                    
                    Server.sharedInstance.showLoader()
                    
                }
                
                if fileData == nil {
                    
                    Alamofire.request(K_Base_Url+K_HireMdd_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
                        .responseJSON { response in
                            
                            Server.sharedInstance.stopLoader()
                            
                            // check for errors
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling GET on /todos/1")
                                print(response.result.error!)
                                return
                            }
                            print(response.result.value!)
                            // make sure we got some JSON since that's what we expect
                            guard let json = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                }
                                return
                            }
                            
                            print(json)
                            // let status = json["status"] as? Int
                            let status = Server.sharedInstance.checkResponseForString(jsonKey:"success", dict: json as NSDictionary)
                            let msg = Server.sharedInstance.checkResponseForString(jsonKey:"message", dict: json as NSDictionary)
                            if status.boolValue {
                                
                                self.fileUrl = nil
                                self.fileData = nil
                                self.mimeType = ""
                                self.mimeTypeValue = ""
                                self.selectOptionTextField.text = ""
                                self.lossLocationTextField.text = ""
                                self.industryTextField.text = ""
                                self.insuredTextField.text = ""
                                self.numberTextField.text = ""
                                self.dropLineTextView.text = ""
                                self.inputCheckBox = ""
                                self.chooseFileLabel.text = "Choose File"
                                self.documentBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: UIControl.State.normal)
                                Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                               
                            }
                            else {
                                
                                DispatchQueue.main.async {
                                    Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                                    
                                }
                            }
                    }
                    
                }
                
                
                else {
                    
                   
                    Alamofire.upload(multipartFormData: { (multipartFormData) in
                        
                        multipartFormData.append(self.fileData!, withName: "upload_file", fileName: "\(Date().ticks).\(self.mimeType)", mimeType: "\(self.mimeTypeValue)")
                        
                        for (key, value) in params {
                            // multipartFormData.append(((value as? String)!.data(using: .utf8))!, withName: key)
                            
                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                            
                        }
                    }, to:K_Base_Url+K_HireMdd_Url, headers:nil)
                    { (result) in
                        
                        switch result {
                            
                            
                            
                        case .success(let upload, _, _):
                            
                            
                            upload.responseJSON { response in
                                
                                Server.sharedInstance.stopLoader()
                                
                                if response.result.isFailure {
                                    
                                    
                                }
                                else {
                                    
                                    let json = response.result.value as? [String: Any]
                                    let status = Server.sharedInstance.checkResponseForString(jsonKey:"success", dict: json! as NSDictionary)
                                    let msg = Server.sharedInstance.checkResponseForString(jsonKey:"message", dict: json! as NSDictionary)
                                    if status.boolValue {
                                        
                                        self.fileUrl = nil
                                        self.fileData = nil
                                        self.mimeType = ""
                                        self.mimeTypeValue = ""
                                        self.selectOptionTextField.text = ""
                                        self.lossLocationTextField.text = ""
                                        self.industryTextField.text = ""
                                        self.insuredTextField.text = ""
                                        self.numberTextField.text = ""
                                        self.dropLineTextView.text = ""
                                        self.inputCheckBox = ""
                                        self.chooseFileLabel.text = "Choose File"
                                        self.documentBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: UIControl.State.normal)
                                     Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                                        
                                       
                                    }
                                        
                                    else {
                                        
                                        DispatchQueue.main.async {
                                            Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                                            
                                        }
                                    }
                                    
                                }

                            }
                        
                        case .failure(let _):
                            DispatchQueue.main.async {
                                
                                Server.sharedInstance.stopLoader()
                            }
                            
                            break
                        }
                    }
                    
                }
                
            }
            
        }
            
        else {
            DispatchQueue.main.async(execute: {
                //   Server.sharedInstance.stopLoader(viewController: UIApplication.topViewController()!)
                Server.sharedInstance.showSnackBarAlert(desc:"Internet connection lost, please check your internet connection.")
            })
        }
        
    }
    
    // MARK:-
    //MARK:- ImagePicker Methods
    
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
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.allowsEditing = true
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
       // uplpdedFile = info[.originalImage] as? UIImage
        
        let cameraImage =  info[UIImagePickerController.InfoKey.originalImage] as! UIImage //image captured from camera
        let image = cameraImage.fixOrientation()
        
        //let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let data = image.jpegData(compressionQuality: 1.0)!
        let size = data.count
        
        let sizeInMb:Float = (Float(size)/Float(1024))/Float(1024)
        if sizeInMb < 5 || sizeInMb == 5 {
            
            if let assetPath = info[UIImagePickerController.InfoKey.referenceURL] as? NSURL  {
                
                let ext = assetPath.pathExtension
                
                let extArray = ["doc","docx","pdf","jpg","jpeg","png","gif","JPG", "JPEG","PNG","GIF","xls","xlsx","xlr", "xml"]
                
                if !(extArray.contains(ext!)) {
                    
                    fileData = nil
                    mimeType = ""
                    fileUrl = nil
                    self.mimeTypeValue = ""
                    self.chooseFileLabel.text = "Invalid File Type"
                    Server.sharedInstance.showSnackBarAlert(desc: "Invalid File Type")
                }
                    
                else {
                    
                    self.fileData = data
                    self.mimeType = ext!
                    fileUrl = info[UIImagePickerController.InfoKey.referenceURL] as? URL
                    self.mimeTypeValue = MimeType(url:self.fileUrl!).value
                    print(MimeType(url:self.fileUrl!).value)
                    
                    
                    ALAssetsLibrary().asset(for: assetPath as URL, resultBlock: { asset in
                        
                        if (asset != nil) {
                            
                            self.chooseFileLabel.text = asset!.defaultRepresentation().filename()
                            
                        }
                        
                        else {

                            self.chooseFileLabel.text =  "\(Date().ticks).\( self.mimeType)"
   
                        }
 
                    }, failureBlock: nil)
                    
                }
                
                
            } else {
                
                 self.fileData = data
                 self.mimeType = "jpeg"
                 self.mimeTypeValue = "image/jpeg"
                 fileUrl = nil
                 self.chooseFileLabel.text =  "\(Date().ticks).jpeg"

            }
         dismiss(animated: true) {
                  
               }
                   
            
        }else {
            
            getSizeChk = true
            self.chooseFileLabel.text =  "Choose File"
          //  Server.sharedInstance.showSnackBarAlert(desc: "The uploaded file size should be less or equal to 5 MB.")
            dismiss(animated: true) {
                       Server.sharedInstance.showSnackBarAlert(desc: "The uploaded file size should be less or equal to 5 MB.")
                  }
                      
            
        }
        
    }
    
    
    
   // MARK:-
    // MARK:- UIDocumentPickerViewController Delegates
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
 
        
        do {
            let attr: NSDictionary = try FileManager.default.attributesOfItem(atPath:url.path) as NSDictionary
            print(attr.fileSize())
            let sizeInMb:Float = (Float(attr.fileSize())/Float(1024))/Float(1024)
            if sizeInMb < 5 || sizeInMb == 5 {

                // self.urlsAarray.append(i)
                print(url)
                
                let extArray = ["doc","docx","pdf","jpg","jpeg","png","gif","JPG", "JPEG","PNG","GIF","xls","xlsx","xlr", "xml"]
                
                 let ext = url.pathExtension
                
                 if !(extArray.contains(ext)) {
                    
                    fileData = nil
                    mimeType = ""
                    fileUrl = nil
                    self.mimeTypeValue = ""
                    self.chooseFileLabel.text = "Invalid File Type"

                   Server.sharedInstance.showSnackBarAlert(desc: "Invalid File Type")
                    
                }
                
                 else {
                    
                    fileData = try Data(contentsOf:url )
                    mimeType = ext
                    fileUrl = url
                    self.mimeTypeValue = MimeType(url:self.fileUrl!).value
                    
                    do{
                        let date = try url.resourceValues(forKeys: [.creationDateKey])
                        print(date.creationDate!)
                        let name = try url.resourceValues(forKeys: [.nameKey])
                        print(name.name!)
                        
                        self.chooseFileLabel.text = name.name!
                        
                    }
                    catch {
                        
                        self.chooseFileLabel.text = "\(Date().ticks).\(ext)"
    
                    }

                }
               
            }
            else {
                getSizeChk = true
            }
            
        } catch {
            print(error)
        }
        
        
        if getSizeChk {
            self.chooseFileLabel.text =  "Choose File"
            Server.sharedInstance.showSnackBarAlert(desc: "The uploaded file size should be less or equal to 5 MB.")
            
        }
    }
    
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        print(urls)
//       // cloudBool = false
//        self.index = 0
//        self.assets.removeAll()
//        self.urlsAarray.removeAll()
//        var getSizeChk = Bool()
//        if urls.count > 0 {
//
//
//            for i in urls {
//
//                do {
//                    let attr: NSDictionary = try FileManager.default.attributesOfItem(atPath:i.path) as NSDictionary
//                    print(attr.fileSize())
//                    let sizeInMb:Float = (Float(attr.fileSize())/Float(1024))/Float(1024)
//                    if sizeInMb < 5 || sizeInMb == 5 {
//
//                        do{
//                            let date = try i.resourceValues(forKeys: [.creationDateKey])
//                            print(date.creationDate!)
//                        }
//                        catch{}
//
//                      self.urlsAarray.append(i)
//                    }
//                    else {
//                        getSizeChk = true
//                    }
//
//                } catch {
//                    print(error)
//                }
//            }
//            if getSizeChk {
//
//                let alertController = UIAlertController(title:"Message", message:"Some of the files size is greater than 20 MB", preferredStyle: .alert)
//                let okAction =  UIAlertAction(title:"OK", style:.default) { (action) in
//
//                }
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion: nil)
//
//            }
//           // self.showFilesLabel(files: self.urlsAarray.count)
//
//
//        }
//        else {
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Cancel")
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
    
//MARK:- Extensions
    
extension UIView {
    
    func setBorder(width:CGFloat , color :UIColor, cornerRaidus:CGFloat) {
        self.layer.borderWidth = width
        self.layer.cornerRadius = cornerRaidus
        self.layer.borderColor = color.cgColor
        
    }
}
