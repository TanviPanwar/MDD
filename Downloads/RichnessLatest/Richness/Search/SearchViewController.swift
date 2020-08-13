//
//  SearchViewController.swift
//  Richness
//
//  Created by IOS3 on 31/01/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import Foundation
import UIKit
//import PullToRefresh
import SDWebImage
import Player
import  IQKeyboardManagerSwift
import AVFoundation
import AVKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate
{

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var searchTextView: UITextView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var usersBtn: UIButton!
    @IBOutlet weak var hashtagsBtn: UIButton!
    @IBOutlet weak var searchStatusLabel: UILabel!
    @IBOutlet weak var searchTableView: UITableView!

    var startuser_index = 0
    var starthashtag_index = 0

    var userArray : [SearchUser] = []
    var hastagsArray : [User] = []  //: [SearchHastags] = []
    var selectedTag = Int()
    var boolSent = true
    var boolHashTag = Bool()




    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        searchTextView.delegate = self
        searchTextField.delegate = self
        selectedTag = usersBtn.tag
        searchTableView.separatorStyle = .none
        hashtagsBtn.setTitleColor(#colorLiteral(red: 0.4029453099, green: 0.4029453099, blue: 0.4029453099, alpha: 1), for: .normal)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK:-
    //MARK:-  TextView Delegates

//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if (searchTextView.text == "Search") {
//           searchTextView.text = ""
//            // commentTextView.textColor = UIColor.black
//        }
//    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if (searchTextView.text == "") {
//            //commentTextView.textColor = UIColor.gray
//            searchTextView.text = "Search"
//            self.searchTableView.isHidden = true
//            self.searchStatusLabel .isHidden = false
//        }
//    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (searchTextField.text == "Search") {
            searchTextField.text = ""
            // commentTextView.textColor = UIColor.black
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (searchTextField.text == "") {
            //commentTextView.textColor = UIColor.gray
            searchTextField.text = "Search"
            self.searchTableView.isHidden = true
           // self.searchStatusLabel.textColor = #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1)
            self.searchStatusLabel .isHidden = false
        }
    }


    // MARK:-
    //MARK:-  IB Actions

    @IBAction func cancelBtnAction(_ sender: Any) {

        self.dismiss(animated: true, completion: nil
        )
    }


    @IBAction func searchBtnAction(_ sender: Any) {

        self.view.endEditing(true)

        self.startuser_index = 0
        self.starthashtag_index = 0


     if selectedTag == usersBtn.tag
      {
         self.userArray.removeAll()
         self.searchTableView.reloadData()
         getUsers()
      }


     else if selectedTag == hashtagsBtn.tag
        {
            self.hastagsArray.removeAll()
            self.searchTableView.reloadData()
            getHashtags()
        }
    }


    @IBAction func selectuserBtnAction(_ sender: Any) {

        selectedTag = usersBtn.tag
        usersBtn.setTitleColor(#colorLiteral(red: 0.878090322, green: 0.8020213246, blue: 0.6706185937, alpha: 1), for: .normal)
        hashtagsBtn.setTitleColor(#colorLiteral(red: 0.4015546739, green: 0.4015546739, blue: 0.4015546739, alpha: 1), for: .normal)
        //self.searchStatusLabel.textColor = #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1)
        searchStatusLabel.text = "Search Users"
        searchStatusLabel.isHidden = false
        searchTableView.isHidden = true

    }

    @IBAction func selecthashtagsBtnAction(_ sender: Any) {

        selectedTag = hashtagsBtn.tag
        usersBtn.setTitleColor(#colorLiteral(red: 0.3985091746, green: 0.3985091746, blue: 0.3985091746, alpha: 1), for: .normal)
        hashtagsBtn.setTitleColor(#colorLiteral(red: 0.878090322, green: 0.8020213246, blue: 0.6706185937, alpha: 1), for: .normal)
        //self.searchStatusLabel.textColor = #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1)
        searchStatusLabel.text = "Search Hashtags"
        searchStatusLabel.isHidden = false
        searchTableView.isHidden = true

    }

    // MARK:-
    //MARK:-  TableView DataSources

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if selectedTag == usersBtn.tag
        {
        return userArray.count
        }
        else
        {
            return hastagsArray.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedTag == usersBtn.tag
        {
            //return 100
            return UITableViewAutomaticDimension
        }
        else
        {
            return 66
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if selectedTag == usersBtn.tag
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath) as! UsersCell

           // cell.userProfileImage.sd_setImage(with: URL(string : userArray[indexPath.row].user_image))
            
            cell.userProfileImage.sd_setImage(with: URL(string : userArray[indexPath.row].user_image), placeholderImage:  UIImage(named: "img_placeholder"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
                if image != nil {
                    
                }
                    
                else {
                    
                    cell.userProfileImage.image = UIImage(named: "img_placeholder")
                }
            }
            
            
            cell.userNameLabel.text = userArray[indexPath.row].user_name
            cell.descriptionLabel.text = userArray[indexPath.row].descriptionText

            if userArray[indexPath.row].user_follow == 1{
                cell.followUnfollowBtn.setTitle("Unfollow", for: .normal)
            }

            else if userArray[indexPath.row].user_follow == 0{
                cell.followUnfollowBtn.setTitle("Follow", for: .normal)
            }

               cell.onFollowUnfollowButtonTapped = {

                if cell.followUnfollowBtn.currentTitle == "Follow" {

                    cell.followUnfollowBtn.setTitle("Unfollow", for: .normal)
                }
                else {

                    cell.followUnfollowBtn.setTitle("Follow", for: .normal)
                }

                self.followerApi(index : indexPath.row )
            }

     

        return cell


        }

            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HashtagsCell", for: indexPath) as! HashtagsCell

                 cell.hastagLabel.text =  hastagsArray[indexPath.row].hashtag_name

                return cell

            }

    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if selectedTag == usersBtn.tag
        {

            if indexPath.row == userArray.count - 1 && userArray.count > 19
            {
                startuser_index += 1
                self.getUsers()
            }

        }

        else
        {
            if indexPath.row == hastagsArray.count - 1 && hastagsArray.count > 19
            {
                starthashtag_index += 1
                self.getHashtags()
            }

        }


    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {



        if selectedTag == usersBtn.tag
        {
            if userArray[indexPath.row].user_id == RichnessUserDefault.getUserID() {
                let vc:ProfileVC = self.storyboard?.instantiateViewController(withIdentifier:"ProfileVC") as! ProfileVC
//                 let vc:ExampleViewController = self.storyboard?.instantiateViewController(withIdentifier:"ExampleViewController") as! ExampleViewController
               // vc.objc = userArray[indexPath.row]
                
                vc.boolRecived = boolSent
                 let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true, completion: nil)


            }

            else {

                let vc:UserProfileViewController = self.storyboard?.instantiateViewController(withIdentifier:"UserProfileViewController") as! UserProfileViewController
                vc.objc = userArray[indexPath.row].user_id
                let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true, completion: nil)

            }
        }

        else {
            
//            boolHashTag = true
//
            let vc:HashTagSelectionViewController = self.storyboard?.instantiateViewController(withIdentifier:"HashTagSelectionViewController") as! HashTagSelectionViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.cellIndex = indexPath.row
            //vc.homeArray = hastagsArray
           // vc.start_index = starthashtag_index
            //vc.user_ID = RichnessUserDefault.getUserID() //hastagsArray[indexPath.row].id_user
            vc.hashTagName = hastagsArray[indexPath.row].hashtag_name
            //let nav = UINavigationController(rootViewController: vc)
            self.present(vc, animated:true, completion:nil)

            

        }
    }

    // MARK:-
    //MARK:-  Api Methods


    func getUsers() {

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        let searchStr:String = (searchTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!

        let params = [
            "start_index" : self.startuser_index,
            "id_user" : RichnessUserDefault.getUserID(),
            "key" : key,
            "name" : searchStr
            ] as [String : Any]
        print(params)

       // startuser_index += 1

        RichnessAlamofire.POST(SEARCHUSERS_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                print(responseObject)
                // self.tableView.endRefreshing(at: .bottom)
                if(responseObject.object(forKey: "result") != nil){
                    let result = responseObject.object(forKey: "result") as? [NSDictionary]

                    print(result)
                    self.searchStatusLabel.isHidden = true
                    self.searchTableView.isHidden = false

                    for item in result!{

                        let searchUsermodel = SearchUser()

                        searchUsermodel.user_id = item["id"] as? String ?? ""
                        if (searchUsermodel.user_id == ""){
                            searchUsermodel.user_id = String(describing: item["id"] as? Int)
                        }

                        searchUsermodel.user_name = item["name"] as? String ?? ""
                        searchUsermodel.descriptionText = item["description"] as? String ?? ""
                        searchUsermodel.user_image = item["image"] as? String ?? ""
                        searchUsermodel.user_follow = item["follow"] as? Int ?? 0
                        self.userArray.append(searchUsermodel)

                    }
                    DispatchQueue.main.async {

                        self.searchTableView.reloadData()
                    }
                }

                else
                {
                    if self.startuser_index == 0 {
                        //self.searchStatusLabel.textColor = #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1)
                       self.searchStatusLabel.isHidden = false
                       self.searchStatusLabel.text = "No user found"
                    }
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

   func getHashtags()
   {

    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy HH"
    let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
    let hashtagsStr:String = (searchTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces))!


    let params = [
        "start_index" : self.starthashtag_index,
        "user_id" : RichnessUserDefault.getUserID(),
        "key" : key,
        "hashtag" : hashtagsStr
        ] as [String : Any]
    print(params)

//    starthashtag_index += 1

    RichnessAlamofire.POST(SEARCHHASHTAGS_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
    ) { (result, responseObject)
        in
        if(result){
            print(responseObject)
            // self.tableView.endRefreshing(at: .bottom)
            if(responseObject.object(forKey: "result") != nil){
                let result = responseObject.object(forKey: "result") as? [NSDictionary]

                print(result)
                self.searchStatusLabel.isHidden = true
                self.searchTableView.isHidden = false


                for item in result!{

                    let searchHastagsmodel = User()


                    searchHastagsmodel.hashtag_name = item["hashtag"] as? String ?? ""
                    self.hastagsArray.append(searchHastagsmodel)

                }
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
            }

            else
            {
                if self.startuser_index == 0 {
                    //self.searchStatusLabel.textColor = #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1)
                    self.searchStatusLabel.isHidden = false
                    self.searchStatusLabel.text = "No hashtag found"
                }
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

    func followerApi(index: Int)
    {

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)

        let params = [
            "user_id" : RichnessUserDefault.getUserID(),
            "user_followed": userArray[index].user_id,
            "key" : key
            ] as [String : Any]
        print(params)

        RichnessAlamofire.POST(ADDFOLLOWRES_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){

                print(responseObject)

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
