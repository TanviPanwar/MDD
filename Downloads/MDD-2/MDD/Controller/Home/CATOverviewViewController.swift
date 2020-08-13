//
//  CATOverviewViewController.swift
//  MDD
//
//  Created by iOS6 on 10/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import Alamofire
import PopupDialog

class CATOverviewViewController: UIViewController, UITextFieldDelegate , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var catOverviewHorizonatlCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var SearchBtn: UIButton!
    @IBOutlet weak var serachMajorImpactBtn: UIButton!
    @IBOutlet weak var transportationCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var searchTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var coverageConsiderationTableView: UITableView!
    
    @IBOutlet weak var selectLawFirmsTextField: UITextField!
    @IBOutlet weak var lawFirmsCollectionView: UICollectionView!
    @IBOutlet weak var selectAllLawFirmsBtn: UIButton!
    @IBOutlet weak var unselectAllLawFirmsBtn: UIButton!
    @IBOutlet weak var selectMonthTextField: UITextField!
    @IBOutlet weak var monthCollectionView: UICollectionView!
    @IBOutlet weak var selectAllMonthBtn: UIButton!
    @IBOutlet weak var unselectAllMonthBtn: UIButton!
    
    
    
    @IBOutlet var pickerInputView: UIView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var cancelToolBarBtn: UIBarButtonItem!
    @IBOutlet weak var doneToolBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var disclaimerBtn: UIButton!
    
    var itemsArray = ["Airports","Airport Closures", "Ports","Railroads", "Highways & Roads", "Transport"]
    var covidItemsArray = ["Government Resources and Statistics","Ongoing Issues","Coverage Considerations","Resources and Articles"]
    
    var itemsImageArray =  [#imageLiteral(resourceName: "airports"), #imageLiteral(resourceName: "closures"), #imageLiteral(resourceName: "ports"), #imageLiteral(resourceName: "ports1"), #imageLiteral(resourceName: "Highway-roads"), #imageLiteral(resourceName: "transport")]
    var horizontalImageArray = [#imageLiteral(resourceName: "Cat1"), #imageLiteral(resourceName: "Cat3"), #imageLiteral(resourceName: "Cat5"), #imageLiteral(resourceName: "Cat7"), #imageLiteral(resourceName: "Cat9")]
    var selectedImageArray = [#imageLiteral(resourceName: "Cat2"), #imageLiteral(resourceName: "Cat4"), #imageLiteral(resourceName: "Cat6"), #imageLiteral(resourceName: "Cat8"), #imageLiteral(resourceName: "Cat10")]
    
    var horizontalCovidImageArray = [#imageLiteral(resourceName: "Historical-data1"), #imageLiteral(resourceName: "Ongoing-issue1"),#imageLiteral(resourceName: "umb-1") , #imageLiteral(resourceName: "Articles-1")]
    var selectedCovidImageArray = [#imageLiteral(resourceName: "Historical-data2"), #imageLiteral(resourceName: "Ongoing-issue2"), #imageLiteral(resourceName: "umb-2"), #imageLiteral(resourceName: "Articles-2")]
    
    var selectedIndex = Int()
    var objc = CategoryObjectModel()
    var itemArray = [CategoryObjectModel]()
    var check = false
    var parentId = String()
    
    var textFieldTag = Int()
    var lawFirmsArray = [String]()
    var monthArray = [String]()
    var monthIDArray = [String]()
    var lawFirmsCollArray = [String]()
    var monthCollArray = [String]()
    var monthIDCollArray = [String]()
    
    var monthsNameArray = [MonthsObject]()
    var searchResultArray = [CategoryObjectModel]()
    var HistoricBool = Bool()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if objc.isCovid == "Yes" {
            
            HistoricBool = true
            titleLabel.text = "Government Resources and Statistics"
            SearchBtn.isHidden = true
            serachMajorImpactBtn.isHidden = false
            searchTopConstraint.constant = 99
            serachMajorImpactBtn.setTitle("Government Stimulus Packages", for: .normal)
            collectionViewTopConstraint.constant = -30
            loadJson(filename: "months")

            
        } else {
            
            titleLabel.text = "Demographics"
            SearchBtn.isHidden = false
            serachMajorImpactBtn.isHidden = true
            searchTopConstraint.constant = 30
            SearchBtn.setTitle("Search Major Industries & Employers", for: .normal)
            collectionViewTopConstraint.constant = 30
            
        }
        
         showPicker()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if check == false {
            
            if objc.isCovid == "Yes" {
                
                parentId = "578" //"576"  //"578"
                self.catOverviewApi(parentId: "578")
                
            } else {
                parentId = "454"
                self.catOverviewApi(parentId: "454")
                
            }
        }
        
    }
    
    //MARK:- Custom Methods
    
    @objc func showPicker()
    {
        selectLawFirmsTextField.inputView = pickerInputView
        selectLawFirmsTextField.inputAccessoryView = nil
        
        selectMonthTextField.inputView = pickerInputView
        selectMonthTextField.inputAccessoryView = nil
        
        
    }
    
     func loadJson(filename fileName: String){
           if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
               do {
                   let data = try Data(contentsOf: url)
                   let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                   if let array = object as? NSArray {
                       print(array)
                       self.monthsNameArray = Server.sharedInstance.GetMonthsIDObjects(array: array)
                       print(monthsNameArray)
                    for i in 0...monthsNameArray.count - 1 {
                        
                        
                        let item = monthsNameArray[i].monthName
                        self.monthArray.append(item)
                    }
                    
                    for i in 0...monthsNameArray.count - 1 {
                        
                        let item = monthsNameArray[i].MonthId
                        self.monthIDArray.append(item)
                    }
                    
                       //countryId = countriesArray[0].id
                   }
               } catch {
                   print("Error!! Unable to parse  \(fileName).json")
               }
           }
    
       }
    
    
    
    //MARK:-
    //MARK:- TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == selectLawFirmsTextField {
            
            textFieldTag = textField.tag
            if(self.lawFirmsArray.count > 0){
                showPicker()
                
                pickerView.reloadAllComponents()
            }
            
            
        } else if textField == selectMonthTextField {
            
            textFieldTag = textField.tag
           // self.regionCountriesApi()
            if(self.monthArray.count > 0){
                
                showPicker()
                pickerView.reloadAllComponents()
            }
            
            
        }
        
    }
    
    
    
    
    
    //Mark:-
    //MARK:- IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func selectAllLawFirmsBtnAction(_ sender: Any) {
        
        selectAllLawFirmsBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        unselectAllLawFirmsBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
        
        for i in lawFirmsArray {
            
            if !lawFirmsCollArray.contains(i) {
                
                lawFirmsCollArray.append(i)
            }
        }
        
        lawFirmsCollectionView.reloadData()
        
        
    }
    
    
    @IBAction func unselectAllLawFirmsBtnAction(_ sender: Any) {
        
        unselectAllLawFirmsBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        selectAllLawFirmsBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
        lawFirmsCollArray.removeAll()
        lawFirmsCollectionView.reloadData()
        
    }
    
    @IBAction func selectAllMonthBtnAction(_ sender: Any) {
        
        selectAllMonthBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        unselectAllMonthBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
        
        for i in monthArray {
            
            if !monthCollArray.contains(i) {
                
                monthCollArray.append(i)
            }
        }
        
        for i in monthIDArray {
            
            if !monthIDCollArray.contains(i) {
                
                monthIDCollArray.append(i)
            }
        }
        
        
        
        monthCollectionView.reloadData()
    }
    
    
    
    @IBAction func unselectAllMonthBtnAction(_ sender: Any) {
        
        unselectAllMonthBtn.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        selectAllMonthBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        
        monthCollArray.removeAll()
        monthIDCollArray.removeAll()
        monthCollectionView.reloadData()
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
    }
    
    @IBAction func doneBtnAction(_ sender: Any) {
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
        let row = pickerView.selectedRow(inComponent: 0)
        
        if textFieldTag == 1 {
            
            self.unselectAllLawFirmsBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            
            //  let arr  = self.dircollectionArray.map{$0.dir_name}
            if !lawFirmsCollArray.contains(lawFirmsArray[row]) {
                lawFirmsCollArray.append(lawFirmsArray[row])
            }
            
            lawFirmsCollectionView.reloadData()
            
        }
            
        else if textFieldTag == 2 {
            
            self.unselectAllMonthBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            
            if !monthCollArray.contains(monthArray[row]) {
                monthCollArray.append(monthArray[row])
            }
            
            if !monthIDCollArray.contains(monthIDArray[row]) {
                monthIDCollArray.append(monthIDArray[row])
            }
            
            monthCollectionView.reloadData()
            
            
        }
        
        self.view.endEditing(true)

    }

    
    @IBAction func serachBtnAction(_ sender: Any) {
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            
            if objc.isCovid == "Yes" {
                
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IndustriesSearchiPadViewController") as! IndustriesSearchiPadViewController
                    
                    vc.objc = objc
                    self.present(vc, animated: true, completion: nil)
                
            } else {
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchInd_EmpViewControllerIPad") as! SearchInd_EmpViewControllerIPad
                
                vc.objc = objc
                self.present(vc, animated: true, completion: nil)
                
            }
        } else {
            
            if objc.isCovid == "Yes" {
          
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchInCatOverviewViewController") as! SearchInCatOverviewViewController
                    
                    vc.objc = objc
                    self.present(vc, animated: true, completion: nil)
                
            } else {
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchInd_EmpViewController") as! SearchInd_EmpViewController
                
                vc.objc = objc
                self.present(vc, animated: true, completion: nil)
                
                
            }
   
    }
        
    }
    
    @IBAction func searchMajorImpactBtnAction(_ sender: Any) {
         
         if UIDevice.current.userInterfaceIdiom == .pad{
             
             
             if objc.isCovid == "Yes" {
                 
                 let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchCountryViewController") as! SearchCountryViewController
                 
                 vc.objc = objc
                 vc.historicBool = HistoricBool
                 self.present(vc, animated: true, completion: nil)
                 
             } else {
                 
                
                 
             }
         } else {
             
             if objc.isCovid == "Yes" {
                 
                 let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchCountryViewController") as! SearchCountryViewController
                 
                 vc.objc = objc
                 vc.historicBool = HistoricBool
                 self.present(vc, animated: true, completion: nil)
                 
             } else {
                
                 
                 
             }
    
     }
         
     }
    
    
    @IBAction func searchCoverageBtnAction(_ sender: Any) {
        
        searchResultArray.removeAll()
        self.searchApi()
    }
    
    
    @IBAction func disclaimerBtnAction(_ sender: Any) {
        
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DisclaimerViewController") as! DisclaimerViewController
        
        
        vc.fromCoverage = true
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    
    //MARK:-
       //MARK:- PickerView DataSources
       
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           
           if textFieldTag == 1 {
            
           return lawFirmsArray.count
            
           } else {
               
               return monthArray.count
           }
       }
       
       
       func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
       {
           let pickerLabel = UILabel()
           if textFieldTag == 1 {
            
               pickerLabel.text = lawFirmsArray[row].html2String
            
           } else {
            
               pickerLabel.text = monthArray[row].html2String
               
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
        if collectionView == lawFirmsCollectionView {
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                size =  CGSize(width:(lawFirmsCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 150, height: 39)
            }
            else  {
                size =  CGSize(width:(lawFirmsCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 80, height: 29)
            }
            
            return size
            
        } else if collectionView == monthCollectionView  {
            
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                size =  CGSize(width:(monthCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 150, height: 39)
            }
            else  {
                
                size =  CGSize(width:(monthCollArray[indexPath.row] as NSString).size(withAttributes: nil).width + 80, height: 29)
                
            }
            return size
            
        }   else if collectionView == catOverviewHorizonatlCollectionView {
            
            if objc.isCovid == "Yes" {
                
                
                  return CGSize(width: collectionView.frame.size.width/4 - 10, height:  collectionView.frame.size.width/4)
                
            } else {
       
            return CGSize(width: collectionView.frame.size.width/5 - 10, height:  collectionView.frame.size.width/5)
                
            }
        }
        
        else {
        
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
           var size = CGFloat()
            if UIDevice.current.userInterfaceIdiom == .pad {
                size = (transportationCollectionView.frame.size.width - (space + flowayout!.minimumInteritemSpacing ?? 0.0)) / 3.0
            }
            else {
                size = (transportationCollectionView.frame.size.width - space) / 2.0
                
            }
   
          return CGSize(width: size, height: size)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == lawFirmsCollectionView {
            return lawFirmsCollArray.count
            
        } else if collectionView == monthCollectionView {
            return monthCollArray.count
            
        } else if collectionView == catOverviewHorizonatlCollectionView {
            
            
            if objc.isCovid == "Yes" {
                
                return horizontalCovidImageArray.count

                
            } else {
                
                return horizontalImageArray.count
                
            }
        }
        
        else {
            return itemArray.count
            
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        if collectionView == lawFirmsCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchInd_EmpCollectionViewCell
            
            cell.cellView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 4)
            
            cell.titleLabel.text = lawFirmsCollArray[indexPath.row].html2String
            
            cell.onDeleteButtonTapped = {
                
                self.selectAllLawFirmsBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.unselectAllLawFirmsBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.lawFirmsCollArray.remove(at: indexPath.row)
                self.lawFirmsCollectionView.reloadData()
                
            }
            
            return cell
            
        } else if collectionView == monthCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchInd_EmpCollectionViewCell
            
            cell.cellView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 4)
            
            cell.titleLabel.text = monthCollArray[indexPath.row].html2String
            
            cell.onDeleteButtonTapped = {
                
                self.selectAllMonthBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.unselectAllMonthBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                self.monthCollArray.remove(at: indexPath.row)
                self.monthIDCollArray.remove(at: indexPath.row)
                self.monthCollectionView.reloadData()
                
            }
            
            return cell
            
        } else if collectionView == catOverviewHorizonatlCollectionView {
            
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CATOverviewHorizonatlCollectionViewCell", for: indexPath) as! CATOverviewHorizonatlCollectionViewCell
            
            
            if indexPath.row == selectedIndex {
                cell.cellLineView.isHidden = false
                if objc.isCovid == "Yes" {
                    
                    
                    cell.cellImageView.image = selectedCovidImageArray[selectedIndex]

                    
                } else {
                
                
                cell.cellImageView.image = selectedImageArray[selectedIndex]
                    
                }

            }
            else {
                cell.cellLineView.isHidden = true
                
                if objc.isCovid == "Yes" {
                    
                    cell.cellImageView.image = horizontalCovidImageArray[indexPath.row]

                } else {
                    
 
                    cell.cellImageView.image = horizontalImageArray[indexPath.row]
                    
                }

            }
 
            return cell
         
        }
        
        else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransportationCell", for: indexPath) as! DetailCollectionViewCell
        
       cell.cellView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 10)
        
        cell.cellLabel.text = itemArray[indexPath.row].cat_name.html2String
        
        cell.cellImgView.sd_setImage(with: URL(string : itemArray[indexPath.row].image), placeholderImage:#imageLiteral(resourceName: "placeholder"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
          
        }
            
        return cell
            
        }
        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == catOverviewHorizonatlCollectionView {
            
            let cell = collectionView.cellForItem(at:indexPath) as! CATOverviewHorizonatlCollectionViewCell
            
            
            let row = indexPath.row
            selectedIndex = row
            catOverviewHorizonatlCollectionView.reloadData()
            
            if objc.isCovid == "Yes" {
                
                switch indexPath.row {
                case 0:
                    
                    self.view.endEditing(true)
                    self.HistoricBool = true
                    self.contentView.isHidden = false
                    self.coverageConsiderationTableView.isHidden = true
                    titleLabel.text = "Government Resources and Statistics"
                    serachMajorImpactBtn.setTitle("Government Stimulus Packages", for: .normal)
                    SearchBtn.isHidden = true
                    serachMajorImpactBtn.isHidden = false
                    collectionViewTopConstraint.constant = -30
                    self.itemArray.removeAll()
                    parentId = "578" //"576"   //"578"
                    catOverviewApi(parentId: "578")
                    
                case 1:
                    
                    self.view.endEditing(true)
                    self.HistoricBool = false
                    self.contentView.isHidden = false
                    self.coverageConsiderationTableView.isHidden = true
                    titleLabel.text = "Ongoing Issues"
                     serachMajorImpactBtn.setTitle("Travel Restrictions & Curfews", for: .normal)
                    SearchBtn.setTitle("Impact To Major Industries", for: .normal)
                    SearchBtn.isHidden = false
                    serachMajorImpactBtn.isHidden = false
                    collectionViewTopConstraint.constant =  30
                    self.itemArray.removeAll()
                    parentId = "582" //"577" //"582"
                    catOverviewApi(parentId: "582")
                    
                case 2:
    
                    self.view.endEditing(true)
                    self.HistoricBool = false
                    self.contentView.isHidden = true
                    self.coverageConsiderationTableView.isHidden = false
                    self.lawFirmsArray.removeAll()
                    self.monthsNameArray.removeAll()
                    self.monthArray.removeAll()
                    self.monthIDArray.removeAll()
                    self.lawFirmsCollArray.removeAll()
                    self.monthCollArray.removeAll()
                    self.monthIDCollArray.removeAll()
                    selectAllLawFirmsBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                    unselectAllLawFirmsBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                    selectAllMonthBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                    unselectAllMonthBtn.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                    self.lawFirmsCollectionView.reloadData()
                    self.monthCollectionView.reloadData()
                    self.loadJson(filename: "months")
                    self.lawFirmApi()
                    
                case 3:
                    
                    self.view.endEditing(true)
                    self.HistoricBool = false
                    self.contentView.isHidden = false
                    self.coverageConsiderationTableView.isHidden = true
                    titleLabel.text = "Resources and Articles"
                    SearchBtn.isHidden = true
                    serachMajorImpactBtn.isHidden = true
                    collectionViewTopConstraint.constant = -100
                    self.itemArray.removeAll()
                    parentId = "584" //"578"  //"584"
                    catOverviewApi(parentId: "584")
                    
                    
                default:
                    
                    print(indexPath.row)
                }
                
                
            } else {
                
            self.HistoricBool = false
            self.contentView.isHidden = false
            self.coverageConsiderationTableView.isHidden = true
            
            switch indexPath.row {
            case 0:

              titleLabel.text = "Demographics"
              SearchBtn.setTitle("Search Major Industries & Employers", for: .normal)
              SearchBtn.isHidden = false
              serachMajorImpactBtn.isHidden = true
              collectionViewTopConstraint.constant = 30
              self.itemArray.removeAll()
              parentId = "454"
              catOverviewApi(parentId: "454")

            case 1:
            
              titleLabel.text = "Affected Area Information"
              SearchBtn.isHidden = true
              serachMajorImpactBtn.isHidden = true
              collectionViewTopConstraint.constant =  -70
              self.itemArray.removeAll()
              parentId = "468"
              catOverviewApi(parentId: "468")

            case 2:
                
                 titleLabel.text = "Insurance Considerations"
                 SearchBtn.isHidden = true
                 serachMajorImpactBtn.isHidden = true
                 collectionViewTopConstraint.constant = -70
                 self.itemArray.removeAll()
                 parentId = "458"
                 catOverviewApi(parentId: "458")

            case 3:
               
                titleLabel.text = "Transportation"
                SearchBtn.isHidden = true
                serachMajorImpactBtn.isHidden = true
                collectionViewTopConstraint.constant = -70
                self.itemArray.removeAll()
                parentId = "452"
                catOverviewApi(parentId: "452")

            case 4:
                
                
                titleLabel.text = "MDD Tool Box"
                SearchBtn.isHidden = true
                serachMajorImpactBtn.isHidden = true
                collectionViewTopConstraint.constant = -70
                self.itemArray.removeAll()
                parentId = "466"
                catOverviewApi(parentId: "466")

            default:

                print(indexPath.row)
            }
            
        }
            
        } else if collectionView == transportationCollectionView   {
            
            DispatchQueue.main.async {
                
                self.saveStatusApi(parentId: self.parentId, childId: self.itemArray[indexPath.row].cat_id)
            }
            
            if itemArray[indexPath.row].descriptionArray.count > 0 {
                
                let alertVC :RailRoadsPopup = (self.storyboard?.instantiateViewController(withIdentifier: "RailRoadsPopup") as? RailRoadsPopup)!
                alertVC.descriptionArray = itemArray[indexPath.row].descriptionArray
                alertVC.categoryName = itemArray[indexPath.row].cat_name
                alertVC.imageUrl = itemArray[indexPath.row].image
                alertVC.parentId = self.parentId
                alertVC.childId = self.itemArray[indexPath.row].cat_id
                alertVC.catastropheid = objc.cat_id
                
                let popup = PopupDialog(viewController: alertVC, buttonAlignment:.vertical, transitionStyle: .bounceDown
                , tapGestureDismissal: false, panGestureDismissal: false) {
                    let overlayAppearance = PopupDialogOverlayView.appearance()
                    
                    overlayAppearance.opacity = 1.0
                }
                
                alertVC.cancelAction = {
                    
                    popup.dismiss({
                        
                        
                    })
                }
                
                
                self.present(popup, animated: true, completion: nil)
                
                
            }
            
            else {
                
                
              
            }
            
        } else {
            
            
        }
        
    }
    
    
    
    
    //MARK:-
    //MARK:- API Methods
    
    func catOverviewApi(parentId: String)
    {
        
        
        let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.loggedInUserID)
        
        if userId is String  {
            
            let params = ["user_id":userId!, "cat_id": objc.cat_id, "parent_id" : parentId, "source": "ios"] as [String: Any]
            print(params)
            
            if Server.sharedInstance.isInternetAvailable()
            {
                
                DispatchQueue.main.async {
                    
                    Server.sharedInstance.showLoader()
                    
                }
                
//                var urlStr = String()
//               if objc.isCovid == "Yes" {
//
//                    urlStr = K_CovidCatOverview_Url
//
//                } else {
//
//                    urlStr = K_CatOverview_Url
//
//                }
                
                Alamofire.request(K_Base_Url+K_CatOverview_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
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
                                
                                self.alertLabel.isHidden = true

                                let responseArray = Server.sharedInstance.GetCategoryOverviewObjects(array: response)
                                
                                self.itemArray.append(contentsOf: responseArray)
                                
                                self.transportationCollectionView.reloadData()
                                
                            } else {
                                
                                self.alertLabel.isHidden = false
                                self.transportationCollectionView.reloadData()

                            }
                            
                            
                        }
                        else {
                            
                            DispatchQueue.main.async {
                                
                                self.alertLabel.isHidden = false
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
            
            
        else {

            Server.sharedInstance.showSnackBarAlert(desc:"UserId is empty.")
    
        }
    }
    
    
    func saveStatusApi(parentId: String, childId: String)
    {
        
        
        let userId = UserDefaults.standard.value(forKey: DefaultsIdentifier.loggedInUserID)
        
        if userId is String  {
            
            let params = ["userid":userId!, "catastropheid": objc.cat_id, "parentcategoryid": parentId,"childcategoryid": childId, "linkid": "", "source":"ios"] as [String: Any]
            print(params)
            
            if Server.sharedInstance.isInternetAvailable()
            {
           
                
                Alamofire.request(K_Base_Url+K_SaveStatus_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
                    .responseJSON { response in
                        
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
                        let status = Server.sharedInstance.checkResponseForString(jsonKey:"status", dict: json as NSDictionary)
                        let msg = Server.sharedInstance.checkResponseForString(jsonKey:"message", dict: json as NSDictionary)
                        if status == "success" {
                            
                        }
                        else {
                            
                        }
                }
                
            }
                
            else {
                DispatchQueue.main.async(execute: {
                    
                    Server.sharedInstance.showAlertwithTitle(title:"Internet Connection Lost", desc: "Check internet connection", vc:UIApplication.topViewController()!)
                })
            }
            
            
        } else {
            
            //              Server.sharedInstance.showAlertwithTitle(title:"", desc: "UserId is Empty", vc:UIApplication.topViewController()!)
            
        }
    }
    
    
    func lawFirmApi()
    {
        if Server.sharedInstance.isInternetAvailable()
        {
            
//            let params = ["cat_name":objc.cat_name] as [String: Any]
//            print(params)
//
            DispatchQueue.main.async {
                
                Server.sharedInstance.showLoader()
                
            }
            
            
            Alamofire.request(K_Base_Url+K_LawFirmListing_Url, method: .post,  parameters: nil, encoding: URLEncoding.default, headers:nil)
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
                            
                            if let array = (response[0] as AnyObject).value(forKey: "Law Firm") as? [String] {
                                
                                self.selectLawFirmsTextField.isUserInteractionEnabled = true
                                self.selectLawFirmsTextField.isEnabled = true
                                self.selectAllLawFirmsBtn.isEnabled = true
                                self.unselectAllLawFirmsBtn.isEnabled = true
                                self.lawFirmsArray = array
                                
                            } else {
                                
                                self.selectLawFirmsTextField.isUserInteractionEnabled = false
                                self.selectLawFirmsTextField.isEnabled = false
                                self.selectAllLawFirmsBtn.isEnabled = false
                                self.unselectAllLawFirmsBtn.isEnabled = false
                            }
                            
                           
                            
                            self.pickerView.reloadAllComponents()
                        }
                        
                    }
                    else {
                        
                        DispatchQueue.main.async {
                            
                            
                            self.selectLawFirmsTextField.isUserInteractionEnabled = false
                                       self.selectLawFirmsTextField.isEnabled = false
                                       self.selectMonthTextField.isUserInteractionEnabled = false
                                       self.selectMonthTextField.isEnabled = false
                                       
                                       self.selectAllLawFirmsBtn.isEnabled = false
                                       self.unselectAllLawFirmsBtn.isEnabled = false
                                       self.selectAllMonthBtn.isEnabled = false
                                       self.unselectAllMonthBtn.isEnabled = false
                            
                             Server.sharedInstance.showSnackBarAlert(desc:msg as String)
                            
                        }
                    }
            }
            
        }
            
        else {
            DispatchQueue.main.async(execute: {
                
                self.selectLawFirmsTextField.isUserInteractionEnabled = false
                self.selectLawFirmsTextField.isEnabled = false
                self.selectMonthTextField.isUserInteractionEnabled = false
                self.selectMonthTextField.isEnabled = false
                
                self.selectAllLawFirmsBtn.isEnabled = false
                self.unselectAllLawFirmsBtn.isEnabled = false
                self.selectAllMonthBtn.isEnabled = false
                self.unselectAllMonthBtn.isEnabled = false
                
                Server.sharedInstance.showSnackBarAlert(desc:"Internet connection lost, please check your internet connection.")
            })
        }
        
    }
    
    
    
    func searchApi()
    {
        if Server.sharedInstance.isInternetAvailable()
        {
          
            let params = [
                          "law_firm":(self.lawFirmsCollArray.map{String($0)}).joined(separator: "--"), "months":(self.monthIDCollArray.map{String($0)}).joined(separator: "--")] as [String: Any]
            print(params)
            DispatchQueue.main.async {
                Server.sharedInstance.showLoader()
            }
            
            Alamofire.request(K_Base_Url+K_LawFirmSearch_Url, method: .post,  parameters: params, encoding: URLEncoding.default, headers:nil)
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
                            vc.considercBool = true
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


extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}


extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
