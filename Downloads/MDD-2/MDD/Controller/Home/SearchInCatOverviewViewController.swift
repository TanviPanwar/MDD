//
//  SearchInCatOverviewViewController.swift
//  MDD
//
//  Created by iOS6 on 31/03/20.
//  Copyright © 2020 IOS3. All rights reserved.
//

import UIKit
import Alamofire

class SearchInCatOverviewViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iPhoneTableView: UITableView!
    @IBOutlet weak var iPadTableView: UITableView!
    @IBOutlet weak var selectCountriesTextField: UITextField!
    @IBOutlet weak var countriesCollectionView: UICollectionView!
    @IBOutlet weak var selectAllCountryBtn: UIButton!
    @IBOutlet weak var unselectAllCountryBtn: UIButton!
    @IBOutlet weak var selectRegionTextField: UITextField!
    @IBOutlet weak var regionCollectionView: UICollectionView!
    @IBOutlet weak var selectAllregionBtn: UIButton!
    @IBOutlet weak var unselectAllRegionBtn: UIButton!
    @IBOutlet weak var selectIndustriesTextField: UITextField!
    @IBOutlet weak var industryCollectionView: UICollectionView!
    @IBOutlet weak var selectAllIndustryBtn: UIButton!
    @IBOutlet weak var unselectAllIndustryBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet var pickerInputView: UIView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var cancelToolBarBtn: UIBarButtonItem!
    @IBOutlet weak var doneToolBarBtn: UIBarButtonItem!
    
    var textFieldTag = Int()
    var regionArray = [String]()
    var countryArray = [String]()
    var industryArray = [String]()
    var regionCollArray = [String]()
    var countryCollArray = [String]()
    var industryCollArray = [String]()
    
    var objc = CategoryObjectModel()
    var searchResultArray = [CategoryObjectModel]()
    
    var industrySelectAllBool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        showPicker()
        selectIndustriesTextField.attributedPlaceholder = NSAttributedString(string: "Select",
                                                                             attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.6392156863, blue: 0.6666666667, alpha: 1)])
        selectRegionTextField.attributedPlaceholder = NSAttributedString(string: "Select",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.6392156863, blue: 0.6666666667, alpha: 1)])
        selectCountriesTextField.attributedPlaceholder = NSAttributedString(string: "Select",
                                                                            attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.6392156863, blue: 0.6666666667, alpha: 1)])
        selectIndustriesTextField.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        selectRegionTextField.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        selectCountriesTextField.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        
        self.selectRegionTextField.textFieldWithRightView(width:15, icon:#imageLiteral(resourceName: "drop-down"))
        self.selectIndustriesTextField.textFieldWithRightView(width:15, icon:#imageLiteral(resourceName: "drop-down"))
        self.selectCountriesTextField.textFieldWithRightView(width:15, icon:#imageLiteral(resourceName: "drop-down"))
        
        var height = CGFloat()
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            height = 43
            cancelToolBarBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)], for: .normal)
            doneToolBarBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)], for: .normal)
            
        }
            
        else {
            
            height = 33
        }
        
        locationApi()
    }
    
    
    //MARK:-
    //MARK:- TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == selectIndustriesTextField {
            
            textFieldTag = textField.tag
            if(self.industryArray.count > 0){
                showPicker()
                
                pickerView.reloadAllComponents()
            }
            
            
        } else if textField == selectRegionTextField {
            
            textFieldTag = textField.tag
           // self.regionCountriesApi()
            if(self.regionArray.count > 0){
                
                showPicker()
                pickerView.reloadAllComponents()
            }
            
            
        } else if textField == selectCountriesTextField {
            
            textFieldTag = textField.tag
           // self.regionCountriesApi()
            if(self.countryArray.count > 0){
                
                showPicker()
                pickerView.reloadAllComponents()
            }
            
        }
        
    }
    
    //MARK:-
    //MARK:- Custom Methods
    
    @objc func showPicker()
    {
        selectIndustriesTextField.inputView = pickerInputView
        selectIndustriesTextField.inputAccessoryView = nil
        
        selectRegionTextField.inputView = pickerInputView
        selectRegionTextField.inputAccessoryView = nil
        
        selectCountriesTextField.inputView = pickerInputView
        selectCountriesTextField.inputAccessoryView = nil
        
    }
    
    
    //MARK:-
    //MARK:- IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectAllCountryBtnAction(_ sender: Any) {
        
        selectAllCountryBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        unselectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
        
        for i in countryArray {
            
            if !countryCollArray.contains(i) {
                
                countryCollArray.append(i)
            }
        }
        
        countriesCollectionView.reloadData()
        
        
    }
    
    
    @IBAction func unselectAllCountryBtnAction(_ sender: Any) {
        
        unselectAllCountryBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        selectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
        countryCollArray.removeAll()
        countriesCollectionView.reloadData()
        
    }
    
    @IBAction func selectAllRegionBtnAction(_ sender: Any) {
        
        
        industrySelectAllBool = true
        
        selectAllregionBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        unselectAllRegionBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
        
        for i in regionArray {
            
            if !regionCollArray.contains(i) {
                
                regionCollArray.append(i)
            }
        }
        
        regionCollectionView.reloadData()
        
        unselectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        selectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
        
        self.countryCollArray.removeAll()
        self.countryArray.removeAll()
        self.countriesCollectionView.reloadData()
                
        self.regionCountriesApi()
        

    }
    
    
    
    @IBAction func unselectAllRegionBtnAction(_ sender: Any) {
        
        
        industrySelectAllBool = true

        unselectAllRegionBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        selectAllregionBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
        regionCollArray.removeAll()
        regionCollectionView.reloadData()
        
        unselectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        selectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
        self.countryCollArray.removeAll()
        self.countryArray.removeAll()
        self.countriesCollectionView.reloadData()
                      
        self.regionCountriesApi()
        
    }
    
    @IBAction func selectAllAIndustryBtnAction(_ sender: Any) {
        
        industrySelectAllBool = false
        selectAllIndustryBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        unselectAllIndustryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
        for i in industryArray {
            
            if !industryCollArray.contains(i) {
                
                industryCollArray.append(i)
            }
        }
        
        industryCollectionView.reloadData()
        
        
        unselectAllRegionBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        selectAllregionBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        unselectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        selectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
        regionCollArray.removeAll()
        countryCollArray.removeAll()
        regionArray.removeAll()
        countryArray.removeAll()
        regionCollectionView.reloadData()
        countriesCollectionView.reloadData()
        
         self.regionCountriesApi()
    }
    
    
    
    @IBAction func unselectAllIndustryBtnAction(_ sender: Any) {
        
        industrySelectAllBool = false
        
        unselectAllIndustryBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        selectAllIndustryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
        industryCollArray.removeAll()
        industryCollectionView.reloadData()
        
        
        
        unselectAllRegionBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        selectAllregionBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        unselectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        selectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
        regionCollArray.removeAll()
        countryCollArray.removeAll()
        regionArray.removeAll()
        countryArray.removeAll()
        regionCollectionView.reloadData()
        countriesCollectionView.reloadData()
        
        
        
        self.regionCountriesApi()
    }
    
    
    
    @IBAction func searchBtnAction(_ sender: Any) {
        
        searchResultArray.removeAll()
        searchApi()
    }
    
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let row = pickerView.selectedRow(inComponent: 0)
        
        if textFieldTag == 1 {
            
            industrySelectAllBool = false

            self.unselectAllIndustryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            
            //  let arr  = self.dircollectionArray.map{$0.dir_name}
            if !industryCollArray.contains(industryArray[row]) {
                industryCollArray.append(industryArray[row])
            }
            
            industryCollectionView.reloadData()
            
            unselectAllRegionBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            selectAllregionBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            unselectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            selectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            
            regionCollArray.removeAll()
            countryCollArray.removeAll()
            regionArray.removeAll()
            countryArray.removeAll()
            regionCollectionView.reloadData()
            countriesCollectionView.reloadData()
            
            
            
            self.regionCountriesApi()

            
        }
            
        else if textFieldTag == 2 {
            
            industrySelectAllBool = true

            
            self.unselectAllRegionBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            
            if !regionCollArray.contains(regionArray[row]) {
                regionCollArray.append(regionArray[row])
            }
            regionCollectionView.reloadData()
            
            unselectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            selectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            
            self.countryCollArray.removeAll()
            self.countryArray.removeAll()
            self.countriesCollectionView.reloadData()
                          
            self.regionCountriesApi()
            
            
        } else if textFieldTag == 3 {
            
            if(self.countryArray.count > 0 ){
                self.unselectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                
                if !countryCollArray.contains(countryArray[row]) {
                    countryCollArray.append(countryArray[row])
                }
                countriesCollectionView.reloadData()
            }
            
            
            
        }
        //dismiss date picker dialog
        self.view.endEditing(true)
        
    }
    
    
    //MARK:-
    //MARK:- PickerView DataSources
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if textFieldTag == 1 {
            return industryArray.count
            
        } else  if textFieldTag == 2 {
            
            return regionArray.count
        } else {
            
            return countryArray.count
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        if textFieldTag == 1 {
            pickerLabel.text = industryArray[row].html2String
        } else if textFieldTag == 2 {
            pickerLabel.text = regionArray[row].html2String
            
        } else {
            pickerLabel.text = countryArray[row].html2String
            
        }
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            
            pickerLabel.font = UIFont.systemFont(ofSize: 30)
        }
        pickerLabel.lineBreakMode = .byWordWrapping
        pickerLabel.numberOfLines = 0
        pickerLabel.sizeToFit()
        
        pickerLabel.textAlignment = NSTextAlignment.center
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
    
    
    //MARK:-
    //MARK:- CollectionView DataSources
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size: CGSize
        if collectionView == industryCollectionView {
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                size =  CGSize(width:(industryCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 150, height: 39)
            }
            else  {
                size =  CGSize(width:(industryCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 80, height: 29)
            }
            
            return size
            
        } else if collectionView == regionCollectionView  {
            
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                size =  CGSize(width:(regionCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 150, height: 39)
            }
            else  {
                
                size =  CGSize(width:(regionCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 80, height: 29)
                
            }
            return size
            
        } else {
            
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                size =  CGSize(width:(countryCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 150, height: 39)
            }
            else  {
                
                size =  CGSize(width:(countryCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 80, height: 29)
                
            }
            return size
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == industryCollectionView {
            return industryCollArray.count
            
        } else if collectionView == regionCollectionView {
            return regionCollArray.count
            
        } else {
            return countryCollArray.count
            
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchInd_EmpCollectionViewCell
        
        if collectionView == industryCollectionView {
            
            cell.cellView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 4)
            
            cell.titleLabel.text = industryCollArray[indexPath.row].html2String
            
            cell.onDeleteButtonTapped = {
                
                self.industrySelectAllBool =  false
                
                self.selectAllIndustryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.unselectAllIndustryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.industryCollArray.remove(at: indexPath.row)
                self.industryCollectionView.reloadData()
                
                self.unselectAllRegionBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.selectAllregionBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.unselectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.selectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                
                self.regionCollArray.removeAll()
                self.countryCollArray.removeAll()
                self.regionArray.removeAll()
                self.countryArray.removeAll()
                self.regionCollectionView.reloadData()
                self.countriesCollectionView.reloadData()
                
                
                self.regionCountriesApi()
                
                
            }
            
            return cell
            
        } else if collectionView == regionCollectionView {
            
            cell.cellView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 4)
            
            cell.titleLabel.text = regionCollArray[indexPath.row].html2String
            
            cell.onDeleteButtonTapped = {
                
                self.industrySelectAllBool =  true

                self.selectAllregionBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.unselectAllRegionBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.regionCollArray.remove(at: indexPath.row)
                self.regionCollectionView.reloadData()
                
                self.unselectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.selectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                
                
                self.countryCollArray.removeAll()
                self.countryArray.removeAll()
                self.countriesCollectionView.reloadData()
                
                
                self.regionCountriesApi()
                
            }
            
            return cell
            
        } else {
            
            cell.cellView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 4)
            
            cell.titleLabel.text = countryCollArray[indexPath.row].html2String
            
            cell.onDeleteButtonTapped = {
                
                self.selectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.unselectAllCountryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.countryCollArray.remove(at: indexPath.row)
                self.countriesCollectionView.reloadData()
                
            }
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let row = indexPath.row
    }
    
    //MARK:-
    //MARK:- API Methods
    
    func locationApi()
    {
        if Server.sharedInstance.isInternetAvailable()
        {
            
            //                let params = ["cat_name":objc.cat_name] as [String: Any]
            //                print(params)
            
            DispatchQueue.main.async {
                
                Server.sharedInstance.showLoader()
                
            }
            
            
            Alamofire.request(K_Base_Url+K_GetMajorIndustrySearch_Url, method: .post,  parameters: nil, encoding: URLEncoding.default, headers:nil)
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
                    let status = Server.sharedInstance.checkResponseForString(jsonKey:"success", dict: json as NSDictionary)
                    let msg = Server.sharedInstance.checkResponseForString(jsonKey:"message", dict: json as NSDictionary)
                    if status.boolValue {
                        
                        if let response = json["repsonse"] as? NSArray , response.count > 0 {
                            
                            
                            if let array1 = (response[0] as AnyObject).value(forKey: "Industry") as? [String] {
                                
                                self.selectIndustriesTextField.isUserInteractionEnabled = true
                                self.selectIndustriesTextField.isEnabled = true
                                self.selectAllIndustryBtn.isEnabled = true
                                self.unselectAllIndustryBtn.isEnabled = true
                                self.industryArray = array1

                                
                            } else {
                                
                                self.selectIndustriesTextField.isUserInteractionEnabled = false
                                self.selectIndustriesTextField.isEnabled = false
                                self.selectAllIndustryBtn.isEnabled = false
                                self.unselectAllIndustryBtn.isEnabled = false
                            }
                            
                            
                            
//                            if let array1 = (response[0] as AnyObject).value(forKey: "Country") as? [String] {
//
//                                self.selectIndustriesTextField.isUserInteractionEnabled = true
//                                self.selectIndustriesTextField.isEnabled = true
//                                self.selectAllCountryBtn.isEnabled = true
//                                self.unselectAllCountryBtn.isEnabled = true
//                                self.countryArray = array1
//
//                            } else {
//
//                                self.selectIndustriesTextField.isUserInteractionEnabled = false
//                                self.selectIndustriesTextField.isEnabled = false
//                                self.selectAllCountryBtn.isEnabled = false
//                                self.unselectAllCountryBtn.isEnabled = false
//                            }
//
//
//                            if let array = (response[0] as AnyObject).value(forKey: "Region") as? [String] {
//
//                                self.selectRegionTextField.isUserInteractionEnabled = true
//
//                                self.selectRegionTextField.isEnabled = true
//                                self.selectAllregionBtn.isEnabled = true
//                                self.unselectAllRegionBtn.isEnabled = true
//                                self.regionArray = array
//
//                            } else {
//
//                                self.selectRegionTextField.isUserInteractionEnabled = false
//                                self.selectRegionTextField.isEnabled = false
//                                self.selectAllregionBtn.isEnabled = false
//                                self.unselectAllRegionBtn.isEnabled = false
//                            }
     
                            self.pickerView.reloadAllComponents()
                        }
                        
                    }
                    else {
                        
                        DispatchQueue.main.async {
                            self.selectRegionTextField.isUserInteractionEnabled = false
                            self.selectRegionTextField.isEnabled = false
                            self.selectIndustriesTextField.isUserInteractionEnabled = false
                            self.selectIndustriesTextField.isEnabled = false
                            self.selectCountriesTextField.isUserInteractionEnabled = false
                            self.selectCountriesTextField.isEnabled = false
                            self.selectAllregionBtn.isEnabled = false
                            self.unselectAllRegionBtn.isEnabled = false
                            self.selectAllCountryBtn.isEnabled = false
                            self.unselectAllCountryBtn.isEnabled = false
                            self.selectAllIndustryBtn.isEnabled = false
                            self.unselectAllIndustryBtn.isEnabled = false
                            Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                            
                        }
                    }
            }
            
        }
            
        else {
            DispatchQueue.main.async(execute: {
                
                self.selectRegionTextField.isUserInteractionEnabled = false
                self.selectRegionTextField.isEnabled = false
                self.selectIndustriesTextField.isUserInteractionEnabled = false
                self.selectIndustriesTextField.isEnabled = false
                self.selectCountriesTextField.isUserInteractionEnabled = false
                self.selectCountriesTextField.isEnabled = false
                self.selectAllregionBtn.isEnabled = false
                self.unselectAllRegionBtn.isEnabled = false
                self.selectAllCountryBtn.isEnabled = false
                self.unselectAllCountryBtn.isEnabled = false
                self.selectAllIndustryBtn.isEnabled = false
                self.unselectAllIndustryBtn.isEnabled = false
                Server.sharedInstance.showSnackBarAlert(desc:"Internet connection lost, please check your internet connection.")
            })
        }
        
    }
    
    
    
    
    func IndustryApi()
    {
        if Server.sharedInstance.isInternetAvailable()
        {
            
            DispatchQueue.main.async {
                
                Server.sharedInstance.showLoader()
                
            }
            
            
            Alamofire.request(K_Base_Url+K_GetMajorIndustrySearch_Url, method: .post,  parameters: nil, encoding: URLEncoding.default, headers:nil)
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
                    let status = Server.sharedInstance.checkResponseForString(jsonKey:"success", dict: json as NSDictionary)
                    let msg = Server.sharedInstance.checkResponseForString(jsonKey:"message", dict: json as NSDictionary)
                    if status.boolValue {
                        
                        if let response = json["repsonse"] as? NSArray , response.count > 0 {
                            
                            
                            
                            if let array1 = (response[0] as AnyObject).value(forKey: "Industry") as? [String] {
                                
                                self.selectIndustriesTextField.isUserInteractionEnabled = true
                                self.selectIndustriesTextField.isEnabled = true
                                self.selectAllIndustryBtn.isEnabled = true
                                self.unselectAllIndustryBtn.isEnabled = true
                                self.industryArray = array1
                                
                            } else {
                                
                                self.selectIndustriesTextField.isUserInteractionEnabled = false
                                self.selectIndustriesTextField.isEnabled = false
                                self.selectAllIndustryBtn.isEnabled = false
                                self.unselectAllIndustryBtn.isEnabled = false
                            }
                            
                            
                            
                            self.pickerView.reloadAllComponents()
                        }
                        
                    }
                    else {
                        
                        DispatchQueue.main.async {
                            
                            self.selectIndustriesTextField.isUserInteractionEnabled = false
                            self.selectIndustriesTextField.isEnabled = false
                            self.selectAllIndustryBtn.isEnabled = false
                            self.unselectAllIndustryBtn.isEnabled = false
                            
                            self.selectCountriesTextField.isUserInteractionEnabled = false
                            self.selectCountriesTextField.isEnabled = false
                            self.selectAllCountryBtn.isEnabled = false
                            self.unselectAllCountryBtn.isEnabled = false
                            
                            self.selectRegionTextField.isUserInteractionEnabled = false
                            self.selectRegionTextField.isEnabled = false
                            self.selectAllregionBtn.isEnabled = false
                            self.unselectAllRegionBtn.isEnabled = false
                            
                            Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                            
                        }
                    }
            }
            
        }
            
        else {
            DispatchQueue.main.async(execute: {
                
                self.selectIndustriesTextField.isUserInteractionEnabled = false
                self.selectIndustriesTextField.isEnabled = false
                self.selectAllIndustryBtn.isEnabled = false
                self.unselectAllIndustryBtn.isEnabled = false
                
                self.selectCountriesTextField.isUserInteractionEnabled = false
                self.selectCountriesTextField.isEnabled = false
                self.selectAllCountryBtn.isEnabled = false
                self.unselectAllCountryBtn.isEnabled = false
                
                self.selectRegionTextField.isUserInteractionEnabled = false
                self.selectRegionTextField.isEnabled = false
                self.selectAllregionBtn.isEnabled = false
                self.unselectAllRegionBtn.isEnabled = false
                
                Server.sharedInstance.showSnackBarAlert(desc:"Internet connection lost, please check your internet connection.")
            })
        }
        
    }
    
    
    func regionCountriesApi()
    {
        if Server.sharedInstance.isInternetAvailable()
        {
            
            let params = ["industries":(self.industryCollArray.map{String($0)}).joined(separator: "--"), "regions":(self.regionCollArray.map{String($0)}).joined(separator: "--")] as [String: Any]
            print(params)
            
            DispatchQueue.main.async {
                
                Server.sharedInstance.showLoader()
                
            }
            
            
            Alamofire.request(K_Base_Url+K_GetRegionCountries_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
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
                    let status = Server.sharedInstance.checkResponseForString(jsonKey:"success", dict: json as NSDictionary)
                    let msg = Server.sharedInstance.checkResponseForString(jsonKey:"message", dict: json as NSDictionary)
                    if status.boolValue {
                        
                        if let response = json["repsonse"] as? [String: Any] {
                            
                            if self.industrySelectAllBool ==  false {
                                
                                self.industrySelectAllBool = true
                                
                                if let array = response["Region"] as? NSArray, array.count > 0 {
                                    
                                    let regionArray = Server.sharedInstance.GetRegionObjects(array: array)
                                    
                                    self.selectRegionTextField.isUserInteractionEnabled = true
                                    self.selectRegionTextField.isEnabled = true
                                    self.selectAllregionBtn.isEnabled = true
                                    self.unselectAllRegionBtn.isEnabled = true
                                    
                                    self.regionArray.removeAll()
                                    for i in 0...regionArray.count - 1 {
                                        
                                        let item = regionArray[i].region
                                        self.regionArray.append(item)
                                    }
                                    
                                } else {
                                    
                                    self.regionArray.removeAll()
                                    self.selectRegionTextField.isUserInteractionEnabled = false
                                    self.selectRegionTextField.isEnabled = false
                                    self.selectAllregionBtn.isEnabled = false
                                    self.unselectAllRegionBtn.isEnabled = false
                                }
                                
                            }
                          
                            
                            if let array1 = response["Country"]  as? NSArray, array1.count > 0 {
                                
                               
                                 let countryArray = Server.sharedInstance.GetCountryObjects(array: array1)
                                self.selectCountriesTextField.isUserInteractionEnabled = true
                                self.selectCountriesTextField.isEnabled = true
                                self.selectAllCountryBtn.isEnabled = true
                                self.unselectAllCountryBtn.isEnabled = true
                                
                                self.countryArray.removeAll()

                                for i in 0...countryArray.count - 1 {
                                    
                                    let item = countryArray[i].country
                                    self.countryArray.append(item)
                                }
                                
                            } else {
                                
                                self.countryArray.removeAll()
                                self.selectCountriesTextField.isUserInteractionEnabled = false
                                self.selectCountriesTextField.isEnabled = false
                                self.selectAllCountryBtn.isEnabled = false
                                self.unselectAllCountryBtn.isEnabled = false
                            }
                          
                            
                            self.pickerView.reloadAllComponents()
                            self.regionCollectionView.reloadData()
                            self.countriesCollectionView.reloadData()
                        }
                        
                    }
                    else {
                        
                        DispatchQueue.main.async {
                            
                            self.selectCountriesTextField.isUserInteractionEnabled = false
                            self.selectCountriesTextField.isEnabled = false
                            self.selectAllCountryBtn.isEnabled = false
                            self.unselectAllCountryBtn.isEnabled = false
                            
                            self.selectRegionTextField.isUserInteractionEnabled = false
                            self.selectRegionTextField.isEnabled = false
                            self.selectAllregionBtn.isEnabled = false
                            self.unselectAllRegionBtn.isEnabled = false
                            
                            Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                            
                        }
                    }
            }
            
        }
            
        else {
            DispatchQueue.main.async(execute: {
                
                self.selectCountriesTextField.isUserInteractionEnabled = false
                self.selectCountriesTextField.isEnabled = false
                self.selectAllCountryBtn.isEnabled = false
                self.unselectAllCountryBtn.isEnabled = false
                
                self.selectRegionTextField.isUserInteractionEnabled = false
                self.selectRegionTextField.isEnabled = false
                self.selectAllregionBtn.isEnabled = false
                self.unselectAllRegionBtn.isEnabled = false

                Server.sharedInstance.showSnackBarAlert(desc:"Internet connection lost, please check your internet connection.")
            })
        }
        
    }
    
    
    
    
    func searchApi()
    {
        if Server.sharedInstance.isInternetAvailable()
        {
            
            print(self.regionCollArray.map{$0})
            print((self.regionCollArray.map{String($0)}).joined(separator: "--"))
            
            let params = ["countries":(self.countryCollArray.map{String($0)}).joined(separator: "--"),
                          "region":(self.regionCollArray.map{String($0)}).joined(separator: "--"), "industries":(self.industryCollArray.map{String($0)}).joined(separator: "--")] as [String: Any]
            print(params)
            DispatchQueue.main.async {
                Server.sharedInstance.showLoader()
            }
            
            
           // K_GetCountrySearch_Url
            Alamofire.request(K_Base_Url+K_GetMajorSearch_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
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
                    let status = Server.sharedInstance.checkResponseForString(jsonKey:"success", dict: json as NSDictionary)
                    let msg = Server.sharedInstance.checkResponseForString(jsonKey:"message", dict: json as NSDictionary)
                    if status.boolValue {
                        
                        if let response = json["repsonse"] as? NSArray , response.count > 0 {
                            
                            let responseArray = Server.sharedInstance.GetCOVIDSearchResultListObjects(array: response)
                            
                            self.searchResultArray.append(contentsOf: responseArray)
                            print(self.searchResultArray)
                            
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
                            
                            vc.resultArray = self.searchResultArray
                            vc.catName = self.objc.isCovid
                            vc.titleString = self.titleLabel.text!
                            
                            self.present(vc, animated: true, completion: nil)
                            
                        }
                        
                    }
                    else {
                        
                        DispatchQueue.main.async {
                            Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                            
                        }
                    }
            }
            
        }
            
        else {
            DispatchQueue.main.async(execute: {
                
                Server.sharedInstance.showSnackBarAlert(desc:"Internet connection lost, please check your internet connection.")
            })
        }
        
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


