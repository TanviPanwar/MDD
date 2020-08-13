//
//  ProfileSettingViewController.swift
//  Richness
//
//  Created by IOS3 on 07/02/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import UIKit

protocol UpdateProfileDataDelegate {
    func didGetData()
}


class ProfileSettingViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate
{
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var changeProfileBtn: UIButton!
    @IBOutlet weak var nicknameView: UIView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var genderSelectionView: UIView!
    @IBOutlet weak var maleRadioBtn: UIButton!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var femaleRadioBtn: UIButton!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var changePasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var reciveNotificationView: UIView!
    @IBOutlet weak var reciveLabel: UILabel!
    @IBOutlet weak var reciveSwitchBtn: UISwitch!
    @IBOutlet weak var privateProfileView: UIView!
    @IBOutlet weak var privateProfileLabel: UILabel!
    @IBOutlet weak var privateProfileSwitchBtn: UISwitch!
    @IBOutlet weak var copyrightBtn: UIButton!
    @IBOutlet weak var privacyPolicyBtn: UIButton!
    @IBOutlet weak var termsofUseBtn: UIButton!
    @IBOutlet weak var reportProblemBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!

    var profileDetailArray : [User] = []
    var gender = String()
    var notification = String()
    var visible = String()
    var image = UIImage()
    var avatarImage : Data? = nil
    var isAvatarChanged = false
    var tagValue :Int?
    var tagString :String?
    var delegate : UpdateProfileDataDelegate?
    var maxLength = 60
    var isImageChanged = Bool()



    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nickNameTextField.delegate = self
        descriptionTextView.delegate = self
        cityTextField.delegate = self
        countryTextField.delegate = self
        changePasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self



        profileImageView.layer.borderWidth = 2
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.737254902, blue: 0.5843137255, alpha: 1)
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        profileImageView.clipsToBounds = true

        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.masksToBounds = false
        descriptionTextView.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.737254902, blue: 0.5843137255, alpha: 1)
        descriptionTextView.layer.cornerRadius = 4
        descriptionTextView.clipsToBounds = true

        maleLabel.layer.borderWidth = 1
        maleLabel.layer.masksToBounds = false
        maleLabel.layer.cornerRadius = maleLabel.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        maleLabel.clipsToBounds = true

        femaleLabel.layer.borderWidth = 1
        femaleLabel.layer.masksToBounds = false
        femaleLabel.layer.cornerRadius = femaleLabel.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        femaleLabel.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(imageTapped(tapGestureRecognizer:)))
        
       profileImageView.isUserInteractionEnabled = true
       profileImageView.addGestureRecognizer(tapGestureRecognizer)
      

        self.isAvatarChanged = false
        getProfileDetailApi()

    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    //MARK:-
    //MARK:- TextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == nickNameTextField {
            let maxLen = 60
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLen
        }
            
        else if textField == cityTextField {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
            
        else if textField == countryTextField {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
            
        else if textField == changePasswordTextField {
            let maxLen = 15
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLen
        }
            
        else
        {
            let maxLen = 15
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLen
        }
        
    }
    
    
    //MARK:-
    //MARK:- TextView Delegate Methods
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 300    // 10 Limit Value
    }
    
    //MARK:-
    //MARK:- Image Tap Gesture Method
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
       
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


    //MARK:-
    //MARK:- IB Actions

    @IBAction func cancelBtnAction(_ sender: Any) {

//        self.dismiss(animated: true, completion: nil
//        )
        self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func saveBtnAction(_ sender: Any) {
        //changeAvatarApi()
        updateProfileDetailApi()

    }

    @IBAction func changeProfileBtnAction(_ sender: Any) {
        if isImageChanged {
       changeAvatarApi()
        }
        
    }

    @IBAction func maleRadioBtnAction(_ sender: Any) {
        maleLabel.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.7960784314, blue: 0.6117647059, alpha: 1)
        femaleLabel.backgroundColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5137254902, alpha: 1)
        gender = "0"
        tagValue = maleRadioBtn.tag
        maleRadioBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        femaleRadioBtn.setTitleColor(#colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5137254902, alpha: 1), for: .normal)


    }

    @IBAction func femaleRadioBtnAction(_ sender: Any) {
        femaleLabel.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.7960784314, blue: 0.6117647059, alpha: 1)
        maleLabel.backgroundColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5137254902, alpha: 1)
        gender = "1"
        tagValue = femaleRadioBtn.tag
        femaleRadioBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        maleRadioBtn.setTitleColor(#colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5137254902, alpha: 1), for: .normal)
    }

    @IBAction func reciveSwitchAction(_ sender: UISwitch) {

        if reciveSwitchBtn.isOn {
            notification = "1"
            reciveSwitchBtn.onTintColor = #colorLiteral(red: 0.862745098, green: 0.7137254902, blue: 0.5294117647, alpha: 1)
            reciveSwitchBtn.thumbTintColor = #colorLiteral(red: 0.862745098, green: 0.7137254902, blue: 0.5294117647, alpha: 1)
        }
        else {
            notification = "0"
            reciveSwitchBtn.onTintColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5137254902, alpha: 1)
            reciveSwitchBtn.thumbTintColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5137254902, alpha: 1)
            
        }
    }

    @IBAction func PrivateSwitchAction(_ sender: UISwitch) {

        if privateProfileSwitchBtn.isOn {
            visible = "1"
            privateProfileSwitchBtn.onTintColor = #colorLiteral(red: 0.862745098, green: 0.7137254902, blue: 0.5294117647, alpha: 1)
            privateProfileSwitchBtn.thumbTintColor = #colorLiteral(red: 0.862745098, green: 0.7137254902, blue: 0.5294117647, alpha: 1)
        }
        else {
            visible = "0"
            privateProfileSwitchBtn.onTintColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5137254902, alpha: 1)
            privateProfileSwitchBtn.thumbTintColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5137254902, alpha: 1)
        }
    }

    @IBAction func copyrightBtnAction(_ sender: Any) {

       if let url = URL(string: profileDetailArray[0].copyright) {
            UIApplication.shared.open(url, options: [:])
        }
    }

    @IBAction func privacyPolicyBtnAction(_ sender: Any) {

        if let url = URL(string: profileDetailArray[0].privacy) {
            UIApplication.shared.open(url, options: [:])
        }
    }

    @IBAction func termsofUseBtnAction(_ sender: Any) {

        if let url = URL(string: profileDetailArray[0].therms) {
            UIApplication.shared.open(url, options: [:])
        }
    }

    @IBAction func reportProblemBtnAction(_ sender: Any) {

        if let url = URL(string: profileDetailArray[0].report) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func logoutBtnAction(_ sender: Any) {

    // self.showAlert(errMsg: "Are you sure you want to logout?")



                let alert = UIAlertController(title: "Alert", message: "Are you sure you want to logout?", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
         alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            RichnessUserDefault.setUserID(val: "")
            //                    RichnessUserDefault.setUserID(val: "123")
            RichnessUserDefault.setFirstUser(val: false)
            RichnessUserDefault.setUserRanking(val: "")
            let nextView = mainstoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let nav = UINavigationController(rootViewController: nextView)
            self.present(nav, animated: true, completion: nil)

        }))
                present(alert, animated: true, completion: nil)
     
    }


    // MARK:-
    //MARK:-  Methods

    func setUI() {

        profileImageView.sd_setImage(with:URL(string :profileDetailArray[0].image) , placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [], completed: nil)
       // profileImageView.sd_setImage(with: URL(string :profileDetailArray[0].image))
        nickNameTextField.text = profileDetailArray[0].name
        descriptionTextView.text = profileDetailArray[0].description
        cityTextField.text = profileDetailArray[0].city
        countryTextField.text = profileDetailArray[0].country
        if profileDetailArray[0].gender == "0" {
            maleLabel.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.7960784314, blue: 0.6117647059, alpha: 1)
            femaleLabel.backgroundColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5137254902, alpha: 1)
            maleRadioBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            femaleRadioBtn.setTitleColor(#colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5137254902, alpha: 1), for: .normal)

        }

        else if profileDetailArray[0].gender == "1" {
            femaleLabel.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.7960784314, blue: 0.6117647059, alpha: 1)
            maleLabel.backgroundColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5137254902, alpha: 1)
            femaleRadioBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            maleRadioBtn.setTitleColor(#colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5137254902, alpha: 1), for: .normal)
        }

        if profileDetailArray[0].notification == "0" {
            reciveSwitchBtn.isOn = false
            reciveSwitchBtn.onTintColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5137254902, alpha: 1)
            reciveSwitchBtn.thumbTintColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5137254902, alpha: 1)
        }
        else if profileDetailArray[0].notification == "1" {
            reciveSwitchBtn.isOn = true
            reciveSwitchBtn.onTintColor = #colorLiteral(red: 0.862745098, green: 0.7137254902, blue: 0.5294117647, alpha: 1)
            reciveSwitchBtn.thumbTintColor = #colorLiteral(red: 0.862745098, green: 0.7137254902, blue: 0.5294117647, alpha: 1)
        }

        if profileDetailArray[0].visible == "0" {
            privateProfileSwitchBtn.isOn = false
            privateProfileSwitchBtn.onTintColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5137254902, alpha: 1)
            privateProfileSwitchBtn.thumbTintColor = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5137254902, alpha: 1)
        }
        else if profileDetailArray[0].visible == "1" {
            privateProfileSwitchBtn.isOn = true
            privateProfileSwitchBtn.onTintColor = #colorLiteral(red: 0.862745098, green: 0.7137254902, blue: 0.5294117647, alpha: 1)
            privateProfileSwitchBtn.thumbTintColor = #colorLiteral(red: 0.862745098, green: 0.7137254902, blue: 0.5294117647, alpha: 1)
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
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.allowsEditing = true
            self.present(myPickerController, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        image = info[UIImagePickerControllerEditedImage] as! UIImage
        isImageChanged = true
        profileImageView.image = image
        self.avatarImage = UIImageJPEGRepresentation(image, 0.8)
        dismiss(animated:true, completion: nil)
       // changeAvatarApi()

    }


    // MARK:-
    //MARK:-  Api Methods

    func getProfileDetailApi() {

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        let params = ["user_id" : RichnessUserDefault.getUserID(),                      
                       "key" : key
            ] as [String : Any]
        print(params)



        RichnessAlamofire.POST(GETUSERDETAIL_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                print(responseObject)
                // self.tableView.endRefreshing(at: .bottom)
                if(responseObject.object(forKey: "result") != nil){
                    let result = responseObject.object(forKey: "result") as? [NSDictionary]

                    print(result)

                    for item in result!{

                        let userDatamodel = User()

                        //                        usermodel.id = item["id"] as? String ?? ""
                        if (userDatamodel.id == ""){
                            userDatamodel.id = String(describing: item["id"] as? Int)
                        }

                        userDatamodel.country = item["country"] as? String ?? ""
                        userDatamodel.description = item["description"] as? String ?? ""
                        userDatamodel.image = item["image"] as? String ?? ""
                        userDatamodel.name = item["name"] as? String ?? ""
                        userDatamodel.city = item["city"] as? String ?? ""
                        userDatamodel.notification = item["notification"] as? String ?? ""
                        userDatamodel.gender = item["gender"] as? String ?? ""
                        userDatamodel.copyright = item["copyright"] as? String ?? ""
                        userDatamodel.privacy = item["privacy"] as? String ?? ""
                        userDatamodel.report = item["report"] as? String ?? ""
                        userDatamodel.therms = item["therms"] as? String ?? ""
                        userDatamodel.visible = item["visible"] as? String ?? ""

                        self.profileDetailArray.append(userDatamodel)

                    }

                          self.setUI()


//                    DispatchQueue.main.async {
//
//                        self.profileTableView.reloadData()
//                    }
                }

                else
                {
                    print("Result is nil")

                }
            }
            else
            {
                let error = responseObject.object(forKey: "error") as? String
                if (error == "#997") {
                    self.showError(errMsg: user_error_unknown)
                }
                else {
                    self.showError(errMsg: error_on_server)
                }
            }
        }
    }

    func updateProfileDetailApi() {

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        let nickName :String = (nickNameTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let descriptionText :String = (descriptionTextView.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let city :String = (cityTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let country :String = (countryTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let password :String = (changePasswordTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        let confirmPassword :String = (confirmPasswordTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
         self.view.endEditing(true)
        var notification = String()
        if reciveSwitchBtn.isOn {
            notification = "1"
        }
        else {
            notification = "0"
        }

        var visible = String()
        if privateProfileSwitchBtn.isOn {
            visible = "1"
        }
        else {
            visible = "0"
        }

        if tagValue == nil {
            gender = profileDetailArray[0].gender

        }

        let params = ["user_id" : RichnessUserDefault.getUserID(),
                      "nickname":nickName,
                      "city":city,
                      "country":country,
                      "description":descriptionText,
                      "notification":notification,
                      "visible":visible,
                      "password":password,
                      "gender":gender,
                      "key" : key
            ] as [String : Any]
        print(params)

        if nickName.isEmpty {
            self.showAlert(errMsg: "Please enter the name")
        }

        else if city.isEmpty {
            self.showAlert(errMsg: "Please enter the city")
        }
        else if description.isEmpty {
            self.showAlert(errMsg: "Please enter the description")
        }
        else if !password.isEmpty {
           if password.count < 6 {
                self.showAlert(errMsg: "Please enter atleast 6 characters password")
            }
            else if !(password == confirmPassword) {
                self.showAlert(errMsg: "Password and confirm password should be same")
            }
        }

        else if !confirmPassword.isEmpty {
            if confirmPassword.count < 6 {
                self.showAlert(errMsg: "Please enter atleast 6 characters confirm password")
            }
            else if !(password == confirmPassword) {
                self.showAlert(errMsg: "Password and confirm password should be same")
            }
        }

        else{
            RichnessAlamofire.POST(UPDATEUSERDETAIL_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
            ) { (result, responseObject)
                in
                if(result){
                    print(responseObject)
                    // self.tableView.endRefreshing(at: .bottom)
                    if(responseObject.object(forKey: "result") != nil){
                        //let result = responseObject.object(forKey: "result") as? [NSDictionary]
                        let result = responseObject.object(forKey: "result")
                        print(result)
                        if self.delegate != nil {
                            self.delegate?.didGetData()
                        }
                        //self.dismiss(animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: true)

                    }

                    else
                    {
                        print("Result is nil")

                    }
                }
                else
                {
                    let error = responseObject.object(forKey: "error") as? String
                    if (error == "#997") {
                        self.showError(errMsg: user_error_unknown)
                    }
                    else {
                        self.showError(errMsg: error_on_server)
                    }
                }
            }
        }
    }

    func changeAvatarApi() {

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)

        let params = [
            "user_id" : RichnessUserDefault.getUserID(),
            "key" : key
        ]
        print(params)

        avatarImage = UIImageJPEGRepresentation(image, 0.6)

        print(params)

        RichnessAlamofire.showIndicator()
        RichnessAlamofire.shareInstance.upload(multipartFormData: { multipartFormData in

            if(self.avatarImage != nil)
            {
                multipartFormData.append(self.avatarImage!, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            }

            let contentDict = params
            for (key, value) in contentDict
            {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }

        }, usingThreshold: RichnessAlamofire.multipartFormDataEncodingMemoryThreshold, to: CHANGEAVATA_URL, method: .post, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)

                    switch response.result {
                    case .success(let JSON):
                        let res = JSON as! NSDictionary

                        if(res.object(forKey: "#001") != nil){

                            self.isAvatarChanged = true
                            //RichnessAlamofire.hideIndicator()

                           // self.tableView.reloadData()
                        }
                        RichnessAlamofire.hideIndicator()
                       // self.updateProfileDetailApi()

                        

                    case .failure(let error):
                        print(error)
                        RichnessAlamofire.hideIndicator()
                       // self.updateProfileDetailApi()
                    }
                  


                }
            case .failure(let encodingError):
                print(encodingError)
                RichnessAlamofire.hideIndicator()
               // self.updateProfileDetailApi()
            }
            
            //self.updateProfileDetailApi()

            
        })
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
