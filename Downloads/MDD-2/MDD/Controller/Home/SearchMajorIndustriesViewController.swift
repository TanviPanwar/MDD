//
//  SearchMajorIndustriesViewController.swift
//  MDD
//
//  Created by iOS6 on 02/04/20.
//  Copyright © 2020 IOS3. All rights reserved.
//

import UIKit
import Alamofire

class SearchMajorIndustriesViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var iPhoneTableView: UITableView!
    @IBOutlet weak var iPadTableView: UITableView!
    @IBOutlet weak var industryView: UIView!
    @IBOutlet weak var industryTopConstarint: NSLayoutConstraint!
    @IBOutlet weak var industryHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var selectIndustriesTextField: UITextField!
    @IBOutlet weak var industriesCollectionView: UICollectionView!
    @IBOutlet weak var selectAllIndustryBtn: UIButton!
    @IBOutlet weak var unselectAllIndustryBtn: UIButton!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationTopConstarint: NSLayoutConstraint!
    @IBOutlet weak var locationHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var selectLocationTextField: UITextField!
    @IBOutlet weak var locationCollectionView: UICollectionView!
    @IBOutlet weak var selectAllLocationBtn: UIButton!
    @IBOutlet weak var unselectAllLocationBtn: UIButton!
    @IBOutlet weak var selectAreaTextField: UITextField!
    @IBOutlet weak var areaCollectionView: UICollectionView!
    @IBOutlet weak var selectAllAreaBtn: UIButton!
    @IBOutlet weak var unselectAllAreaBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var sectorView: UIView!
    @IBOutlet weak var sectorTopConstarints: NSLayoutConstraint!
    @IBOutlet weak var sectorHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var selectSectorTextField: UITextField!
    @IBOutlet weak var sectorCollectionView: UICollectionView!
    @IBOutlet weak var selectAllSectorBtn: UIButton!
    @IBOutlet weak var unselectAllSectorBtn: UIButton!
    
    
    @IBOutlet var pickerInputView: UIView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var cancelToolBarBtn: UIBarButtonItem!
    @IBOutlet weak var doneToolBarBtn: UIBarButtonItem!
    
    var textFieldTag = Int()
    var locationsArray = [String]()
    var industryArray = [String]()
    var areaArray = [String]()
    var locationCollArray = [String]()
    var industryCollArray = [String]()
    var areaCollArray = [String]()
    var sectorArray = [String]()
    var sectorCollArray = [String]()



    var objc = CategoryObjectModel()
    var searchResultArray = [CategoryObjectModel]()
    var sectoryObj = [CategoryObjectModel]()
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
        showPicker()
        selectIndustriesTextField.attributedPlaceholder = NSAttributedString(string: "Select",
                                                           attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.6392156863, blue: 0.6666666667, alpha: 1)])
        selectLocationTextField.attributedPlaceholder = NSAttributedString(string: "Select",
                                                              attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.6392156863, blue: 0.6666666667, alpha: 1)])
        selectAreaTextField.attributedPlaceholder = NSAttributedString(string: "Select",
                                                                           attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.6392156863, blue: 0.6666666667, alpha: 1)])
        selectIndustriesTextField.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        selectLocationTextField.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        selectAreaTextField.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)

        
        self.selectLocationTextField.textFieldWithRightView(width:15, icon:#imageLiteral(resourceName: "drop-down"))
        self.selectIndustriesTextField.textFieldWithRightView(width:15, icon:#imageLiteral(resourceName: "drop-down"))
        self.selectAreaTextField.textFieldWithRightView(width:15, icon:#imageLiteral(resourceName: "drop-down"))

        var height = CGFloat()
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            height = 43
            cancelToolBarBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)], for: .normal)
            doneToolBarBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)], for: .normal)
            
        }
            
        else {
            
            height = 33
        }
        
        sectorHeightConstarint.constant = 0
        locationTopConstarint.constant = 15
        locationHeightConstarint.constant = 674
        sectorView.isHidden = true
        
        
        
        
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
           
            
        } else if textField == selectLocationTextField {
            
            textFieldTag = textField.tag
            if(self.locationsArray.count > 0){
                showPicker()
                 pickerView.reloadAllComponents()
            }
           
            
        } else if textField == selectAreaTextField {
            
            textFieldTag = textField.tag
            if(self.areaArray.count > 0){
                showPicker()
                pickerView.reloadAllComponents()
            }
         
        } else if textField == selectSectorTextField {
            
            textFieldTag = textField.tag
            if(self.sectorArray.count > 0){
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
        
        selectLocationTextField.inputView = pickerInputView
        selectLocationTextField.inputAccessoryView = nil
        
        selectAreaTextField.inputView = pickerInputView
        selectAreaTextField.inputAccessoryView = nil
        
        selectSectorTextField.inputView = pickerInputView
        selectSectorTextField.inputAccessoryView = nil
        
    }
    
   
    //MARK:-
    //MARK:- IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectAllIndustryBtnAction(_ sender: Any) {
        
        selectAllIndustryBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        unselectAllIndustryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
        

            
            for i in industryArray {

                if !industryCollArray.contains(i) {
                   
                    industryCollArray.append(i)
                }
        
            }
        
        
        if industryArray.count > 0 {
        for j in 0...industryArray.count - 1 {
            
            let item = sectoryObj[j].sectorArray
            if item.count > 0 {
            
                for k in item {
                    
                    if !sectorCollArray.contains(k) {
                        sectorCollArray.append(k)
                        
                    }
                    
                    if !sectorArray.contains(k) {
                        sectorArray.append(k)
                        
                    }
                    
                }
                
            } else {
            
            }
            
        }
        }
        
        if sectorArray.count > 0 {
        sectorHeightConstarint.constant = 319
        locationTopConstarint.constant = 349
        sectorView.isHidden = false
      //  self.sectorArray = sectoryObj[row].sectorArray
            
        }

        industriesCollectionView.reloadData()
  
        
    }
    
    
    @IBAction func unselectAllIndustryBtnAction(_ sender: Any) {
        
         unselectAllIndustryBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
         selectAllIndustryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
        sectorHeightConstarint.constant = 0
        locationTopConstarint.constant = 15
        locationHeightConstarint.constant = 674
        sectorView.isHidden = true
        self.sectorArray.removeAll()
        sectorCollArray.removeAll()


         industryCollArray.removeAll()
         industriesCollectionView.reloadData()
        
    }
    
    @IBAction func selectAllLocationBtnAction(_ sender: Any) {
        
        selectAllLocationBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        unselectAllLocationBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)

        
            for i in locationsArray {
                
                if !locationCollArray.contains(i) {
                    
                    locationCollArray.append(i)
                }
            }

        locationCollectionView.reloadData()
    }
    
    
    
    @IBAction func unselectAllLocationBtnAction(_ sender: Any) {
        
         unselectAllLocationBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
         selectAllLocationBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
         locationCollArray.removeAll()
         locationCollectionView.reloadData()
    }
    
    @IBAction func selectAllAreaBtnAction(_ sender: Any) {
        
        selectAllAreaBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        unselectAllAreaBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
 
        for i in areaArray {
            
            if !areaCollArray.contains(i) {
                
                areaCollArray.append(i)
            }
        }

        areaCollectionView.reloadData()
    }
    
    
    
    @IBAction func unselectAllAreaBtnAction(_ sender: Any) {
        
        unselectAllAreaBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        selectAllAreaBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
        areaCollArray.removeAll()
        areaCollectionView.reloadData()
    }
    
    @IBAction func selectAllSectorBtnAction(_ sender: Any) {
        
        selectAllSectorBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        unselectAllSectorBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
        for i in sectorArray {
            
            if !sectorCollArray.contains(i) {
                
                sectorCollArray.append(i)
            }
        }
        
        sectorCollectionView.reloadData()
    }
    
    
    
    @IBAction func unselectAllSectorBtnAction(_ sender: Any) {
        
        unselectAllSectorBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        selectAllSectorBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
        sectorCollArray.removeAll()
        sectorCollectionView.reloadData()
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
            
            self.unselectAllIndustryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)

          //  let arr  = self.dircollectionArray.map{$0.dir_name}
            if !industryCollArray.contains(industryArray[row]) {
                industryCollArray.append(industryArray[row])
                
                if sectoryObj[row].sectorArray.count > 0 {
                    
                    sectorHeightConstarint.constant = 319
                    locationTopConstarint.constant = 349
                    locationHeightConstarint.constant = 674
                    sectorView.isHidden = false
                    self.sectorArray = sectoryObj[row].sectorArray
                    
                } else {
                    
                    sectorHeightConstarint.constant = 0
                    locationTopConstarint.constant = 15
                    locationHeightConstarint.constant = 674
                    sectorView.isHidden = true
                    self.sectorArray.removeAll()

                    
                }
            }
     
            industriesCollectionView.reloadData()
           
        }
            
        else if textFieldTag == 2 {
            
            self.unselectAllLocationBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)

            if !locationCollArray.contains(locationsArray[row]) {
                locationCollArray.append(locationsArray[row])
            }
            locationCollectionView.reloadData()

            
        } else if textFieldTag == 3 {
            
            if(self.areaArray.count > 0 ){
                self.unselectAllAreaBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                
                if !areaCollArray.contains(areaArray[row]) {
                    areaCollArray.append(areaArray[row])
                }
                areaCollectionView.reloadData()
            }
           
            
            
        } else if textFieldTag == 4 {
            
            if(self.sectorArray.count > 0 ){
                self.unselectAllSectorBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                
                if !sectorCollArray.contains(sectorArray[row]) {
                    sectorCollArray.append(sectorArray[row])
                }
                sectorCollectionView.reloadData()
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
            
            return locationsArray.count
        } else if textFieldTag == 3 {
            
            return areaArray.count
        } else {
            
            return sectorArray.count

        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        if textFieldTag == 1 {
            pickerLabel.text = industryArray[row].html2String
        } else if textFieldTag == 2 {
            pickerLabel.text = locationsArray[row].html2String
            
        } else if textFieldTag == 3 {
            pickerLabel.text = areaArray[row].html2String
            
        } else {
            
            pickerLabel.text = sectorArray[row].html2String

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
        if collectionView == industriesCollectionView {
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                size =  CGSize(width:(industryCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 150, height: 39)
            }
            else  {
            size =  CGSize(width:(industryCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 80, height: 29)
            }
            
            return size

        } else if collectionView == locationCollectionView  {
            
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                size =  CGSize(width:(locationCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 150, height: 39)
            }
            else  {
            
             size =  CGSize(width:(locationCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 80, height: 29)
                
            }
            return size

        } else if collectionView == areaCollectionView {
            
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                size =  CGSize(width:(areaCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 150, height: 39)
            }
            else  {
                
                size =  CGSize(width:(areaCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 80, height: 29)
                
            }
            return size
            
        } else  {
            
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                size =  CGSize(width:(sectorCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 150, height: 39)
            }
            else  {
                
                size =  CGSize(width:(sectorCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 80, height: 29)
                
            }
            return size
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == industriesCollectionView {
        return industryCollArray.count
            
        } else if collectionView == locationCollectionView {
            return locationCollArray.count
            
        } else  if collectionView == areaCollectionView {
            return areaCollArray.count
            
        } else {
            return sectorCollArray.count
            
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchInd_EmpCollectionViewCell
        
        if collectionView == industriesCollectionView {
        
        cell.cellView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 4)
        
        cell.titleLabel.text = industryCollArray[indexPath.row].html2String
        
        cell.onDeleteButtonTapped = {
            
             self.selectAllIndustryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
             self.unselectAllIndustryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
             self.industryCollArray.remove(at: indexPath.row)
             self.industriesCollectionView.reloadData()
            
        }
  
        return cell
            
        } else if collectionView == locationCollectionView {
            
            cell.cellView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 4)
            
            cell.titleLabel.text = locationCollArray[indexPath.row].html2String
            
            cell.onDeleteButtonTapped = {
                
                self.selectAllLocationBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.unselectAllLocationBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.locationCollArray.remove(at: indexPath.row)
                self.locationCollectionView.reloadData()
                
            }
            
            return cell
            
        } else if collectionView == areaCollectionView  {
            
            cell.cellView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 4)
            
            cell.titleLabel.text = areaCollArray[indexPath.row].html2String
            
            cell.onDeleteButtonTapped = {
                
                self.selectAllAreaBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.unselectAllAreaBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.areaCollArray.remove(at: indexPath.row)
                self.areaCollectionView.reloadData()
                
            }
            
            return cell
            
        } else {
            
            cell.cellView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 4)
            
            cell.titleLabel.text = sectorCollArray[indexPath.row].html2String
            
            cell.onDeleteButtonTapped = {
                
                self.selectAllSectorBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.unselectAllSectorBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.sectorCollArray.remove(at: indexPath.row)
                self.sectorCollectionView.reloadData()
                
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
            
//            let params = ["cat_name":objc.cat_name] as [String: Any]
//            print(params)
            
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
                            
                            if let array = (response[0] as AnyObject).value(forKey: "Location") as? [String] {
                                
                                self.selectLocationTextField.isUserInteractionEnabled = true
                                self.selectLocationTextField.isEnabled = true
                                self.selectAllLocationBtn.isEnabled = true
                                self.unselectAllLocationBtn.isEnabled = true
                                self.locationsArray = array
                                
                                } else {
                                
                                self.selectLocationTextField.isUserInteractionEnabled = false
                                self.selectLocationTextField.isEnabled = false
                                self.selectAllLocationBtn.isEnabled = false
                                self.unselectAllLocationBtn.isEnabled = false
                            }
                            
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
                            
                            if let array2 = (response[0] as AnyObject).value(forKey: "AffectedArea") as? [String] {
                                
                                self.selectAreaTextField.isUserInteractionEnabled = true
                                self.selectAreaTextField.isEnabled = true
                                self.selectAllAreaBtn.isEnabled = true
                                self.unselectAllAreaBtn.isEnabled = true
                                self.areaArray = array2
                                
                            } else {
                                
                                self.selectAreaTextField.isUserInteractionEnabled = false
                                self.selectAreaTextField.isEnabled = false
                                self.selectAllAreaBtn.isEnabled = false
                                self.unselectAllAreaBtn.isEnabled = false
                            }
                            
//                            self.locationsArray = (response[0] as AnyObject).value(forKey: "Location") as! [String]
//                            self.industryArray = (response[0] as AnyObject).value(forKey: "Industry") as! [String]
                            
                            self.sectorApi()
                            self.pickerView.reloadAllComponents()
                        }
                        
                    }
                    else {
                        
                        DispatchQueue.main.async {
                            self.selectLocationTextField.isUserInteractionEnabled = false
                            self.selectLocationTextField.isEnabled = false
                            self.selectIndustriesTextField.isUserInteractionEnabled = false
                            self.selectIndustriesTextField.isEnabled = false
                            self.selectAreaTextField.isUserInteractionEnabled = false
                            self.selectAreaTextField.isEnabled = false
                            self.selectAllLocationBtn.isEnabled = false
                            self.unselectAllLocationBtn.isEnabled = false
                            self.selectAllIndustryBtn.isEnabled = false
                            self.unselectAllIndustryBtn.isEnabled = false
                            self.selectAllAreaBtn.isEnabled = false
                            self.unselectAllAreaBtn.isEnabled = false
                            Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                            
                        }
                    }
            }
            
        }
            
        else {
            DispatchQueue.main.async(execute: {

                self.selectLocationTextField.isUserInteractionEnabled = false
                self.selectLocationTextField.isEnabled = false
                self.selectIndustriesTextField.isUserInteractionEnabled = false
                self.selectIndustriesTextField.isEnabled = false
                self.selectAreaTextField.isUserInteractionEnabled = false
                self.selectAreaTextField.isEnabled = false
                self.selectAllLocationBtn.isEnabled = false
                self.unselectAllLocationBtn.isEnabled = false
                self.selectAllIndustryBtn.isEnabled = false
                self.unselectAllIndustryBtn.isEnabled = false
                self.selectAllAreaBtn.isEnabled = false
                self.unselectAllAreaBtn.isEnabled = false
                Server.sharedInstance.showSnackBarAlert(desc:"Internet connection lost, please check your internet connection.")
            })
        }
        
    }
    
    
    func sectorApi()
    {
        if Server.sharedInstance.isInternetAvailable()
        {
            
            //            let params = ["cat_name":objc.cat_name] as [String: Any]
            //            print(params)
            
            DispatchQueue.main.async {
                
                Server.sharedInstance.showLoader()
                
            }
            
            
            Alamofire.request(K_Base_Url+K_GetSectorListing_Url, method: .post,  parameters: nil, encoding: URLEncoding.default, headers:nil)
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
                            
                            print(response)

                            if let listing = (response[0] as AnyObject).value(forKey: "Listing") as? NSArray {
                                
                                print(listing)
                                
                                let objc = Server.sharedInstance.GetSectorListObjects(array: listing)
                                print(objc)
                                self.sectoryObj = objc
                               
                            }
                           
                            
                            self.pickerView.reloadAllComponents()
                        }
                        
                    }
                    else {
                        
                        DispatchQueue.main.async {
//                            self.selectLocationTextField.isUserInteractionEnabled = false
//                            self.selectLocationTextField.isEnabled = false
//                            self.selectIndustriesTextField.isUserInteractionEnabled = false
//                            self.selectIndustriesTextField.isEnabled = false
//                            self.selectAreaTextField.isUserInteractionEnabled = false
//                            self.selectAreaTextField.isEnabled = false
//                            self.selectAllLocationBtn.isEnabled = false
//                            self.unselectAllLocationBtn.isEnabled = false
//                            self.selectAllIndustryBtn.isEnabled = false
//                            self.unselectAllIndustryBtn.isEnabled = false
//                            self.selectAllAreaBtn.isEnabled = false
//                            self.unselectAllAreaBtn.isEnabled = false
                            Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                            
                        }
                    }
            }
            
        }
            
        else {
            DispatchQueue.main.async(execute: {
                
//                self.selectLocationTextField.isUserInteractionEnabled = false
//                self.selectLocationTextField.isEnabled = false
//                self.selectIndustriesTextField.isUserInteractionEnabled = false
//                self.selectIndustriesTextField.isEnabled = false
//                self.selectAreaTextField.isUserInteractionEnabled = false
//                self.selectAreaTextField.isEnabled = false
//                self.selectAllLocationBtn.isEnabled = false
//                self.unselectAllLocationBtn.isEnabled = false
//                self.selectAllIndustryBtn.isEnabled = false
//                self.unselectAllIndustryBtn.isEnabled = false
//                self.selectAllAreaBtn.isEnabled = false
//                self.unselectAllAreaBtn.isEnabled = false
                Server.sharedInstance.showSnackBarAlert(desc:"Internet connection lost, please check your internet connection.")
            })
        }
        
    }
    
    
    
    
    func searchApi()
    {
        if Server.sharedInstance.isInternetAvailable()
        {
            
            print(self.industryCollArray.map{$0})
            print((self.industryCollArray.map{String($0)}).joined(separator: ","))

            let params = [ "industries":(self.industryCollArray.map{String($0)}).joined(separator: ","),
                          "countries":(self.locationCollArray.map{String($0)}).joined(separator: ","), "region":(self.areaCollArray.map{String($0)}).joined(separator: ","), "sectors":(self.sectorCollArray.map{String($0)}).joined(separator: ",")] as [String: Any]
            print(params)
            DispatchQueue.main.async {
                Server.sharedInstance.showLoader()
            }
            
            //K_GetMajorSearch_Url
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
