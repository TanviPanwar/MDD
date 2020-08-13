//
//  SearchCountryViewController.swift
//  MDD
//
//  Created by iOS6 on 02/04/20.
//  Copyright © 2020 IOS3. All rights reserved.
//

import UIKit
import Alamofire

class SearchCountryViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectIndustriesTextField: UITextField!
    @IBOutlet weak var industriesCollectionView: UICollectionView!
    @IBOutlet weak var selectAllIndustryBtn: UIButton!
    @IBOutlet weak var unselectAllIndustryBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
       
       @IBOutlet var pickerInputView: UIView!
       @IBOutlet weak var toolBar: UIToolbar!
       @IBOutlet weak var pickerView: UIPickerView!
       @IBOutlet weak var cancelToolBarBtn: UIBarButtonItem!
       @IBOutlet weak var doneToolBarBtn: UIBarButtonItem!
    

    var textFieldTag = Int()
    var locationsArray = [String]()
    var industryArray = [String]()
    var industryCollArray = [String]()


   
    var locationCollArray = [String]()
    var objc = CategoryObjectModel()
    var searchResultArray = [CategoryObjectModel]()
    
    var regionArray = [String]()
    var areaArray = [String]()
    var regionCollArray = [String]()
    var areaCollArray = [String]()
    var historicBool = Bool()


    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        if historicBool {
            
            titleLabel.text = "Government Stimulus Packages"
            
        } else {
            
            titleLabel.text = "Travel Restrictions & Curfews"

        }
        
        showPicker()
        selectIndustriesTextField.attributedPlaceholder = NSAttributedString(string: "Select",
                                                           attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.6392156863, blue: 0.6666666667, alpha: 1)])
        selectIndustriesTextField.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
         self.selectIndustriesTextField.textFieldWithRightView(width:15, icon:#imageLiteral(resourceName: "drop-down"))
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK:-
       //MARK:- TextField Delegate
       
       func textFieldDidBeginEditing(_ textField: UITextField) {
           if textField == selectIndustriesTextField {
               
               textFieldTag = textField.tag
               if(self.industryArray.count > 0){
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

          industriesCollectionView.reloadData()
    
          
      }
      
      
      @IBAction func unselectAllIndustryBtnAction(_ sender: Any) {
          
           unselectAllIndustryBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
           selectAllIndustryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)

           industryCollArray.removeAll()
           industriesCollectionView.reloadData()
          
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
              }
       
              industriesCollectionView.reloadData()
             
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
           
         //  if textFieldTag == 1 {
               return industryArray.count
               
          
       }
       
       
       func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
       {
           let pickerLabel = UILabel()
          // if textFieldTag == 1 {
               pickerLabel.text = industryArray[row].html2String
          

           
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
         // if collectionView == industriesCollectionView {
              
              if UIDevice.current.userInterfaceIdiom == .pad {
                  
                  size =  CGSize(width:(industryCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 150, height: 39)
              }
              else  {
              size =  CGSize(width:(industryCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 80, height: 29)
              }
              
              return size

         // }
        
    }
    
    
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           
         //  if collectionView == industriesCollectionView {
           return industryCollArray.count
               
        
       }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchInd_EmpCollectionViewCell
          
         // if collectionView == industriesCollectionView {
          
          cell.cellView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 4)
          
          cell.titleLabel.text = industryCollArray[indexPath.row].html2String
          
          cell.onDeleteButtonTapped = {
              
               self.selectAllIndustryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
               self.unselectAllIndustryBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
               self.industryCollArray.remove(at: indexPath.row)
               self.industriesCollectionView.reloadData()
              
          }
    
          return cell
              
         // }
        
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
                
                var urlstring = String()
                if historicBool {
                    
                    urlstring = K_GetGovtCountryListing_Url
                    
                } else {
                    
                    urlstring = K_GetCountryListing_Url

                }
                
                
                Alamofire.request(K_Base_Url+urlstring, method: .post,  parameters: nil, encoding: URLEncoding.default, headers:nil)
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
                                
                                
                                
                                if let array1 = (response[0] as AnyObject).value(forKey: "Country") as? [String] {
                                    
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
                                
                               
                                
    //                            self.locationsArray = (response[0] as AnyObject).value(forKey: "Location") as! [String]
    //                            self.industryArray = (response[0] as AnyObject).value(forKey: "Industry") as! [String]
                                
                                
                                self.pickerView.reloadAllComponents()
                            }
                            
                        }
                        else {
                            
                            DispatchQueue.main.async {
                               
                                self.selectIndustriesTextField.isUserInteractionEnabled = false
                                self.selectIndustriesTextField.isEnabled = false
                                
                                self.selectAllIndustryBtn.isEnabled = false
                                self.unselectAllIndustryBtn.isEnabled = false

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
                    
                    Server.sharedInstance.showSnackBarAlert(desc:"Internet connection lost, please check your internet connection.")
                })
            }
            
        }
    
    func searchApi()
    {
        if Server.sharedInstance.isInternetAvailable()
        {
            
            print(self.regionCollArray.map{$0})
            print((self.regionCollArray.map{String($0)}).joined(separator: ","))
            
            
            var urlstring = String()
            var parmas = [String: Any]()
            if historicBool {
                
                urlstring = K_GetGovtCountrySearch_Url
                parmas = ["countries":(self.industryCollArray.map{String($0)}).joined(separator: "--")] as [String: Any]
                print(parmas)
                
            } else {
                
                urlstring = K_GetCountrySearch_Url
                parmas = ["countries":(self.industryCollArray.map{String($0)}).joined(separator: "--"),
                              "region":(self.regionCollArray.map{String($0)}).joined(separator: "--"), "industries":(self.areaCollArray.map{String($0)}).joined(separator: "--")] as [String: Any]
                print(parmas)

            }

            DispatchQueue.main.async {
                Server.sharedInstance.showLoader()
            }
            
            Alamofire.request(K_Base_Url+urlstring, method: .post,  parameters: parmas, encoding: URLEncoding.default, headers:nil)
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
        
      

}
