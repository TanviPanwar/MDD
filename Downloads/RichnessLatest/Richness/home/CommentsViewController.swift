//
//  CommentsViewController.swift
//  Richness
//
//  Created by IOS3 on 17/01/19.
//  Copyright © 2019 Sobura. All rights reserved.
//

import Foundation
import UIKit
import PullToRefresh
import SDWebImage

protocol refreshCommentCountDelegate{

    func commentCountDidRecieve(count: Int, tag: Int)

}

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{


    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var totalCommentsLabel: UILabel!
    @IBOutlet weak var lowerView: UIView!
    @IBOutlet weak var growingView: NextGrowingTextView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saySomethingTextView: UITextView!
    @IBOutlet weak var smileyBtn: UIButton!
    @IBOutlet weak var inputContainerViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var lowerViewHeightConstarint: NSLayoutConstraint!
    

    var commentsArray : [Comments] = []
    var refreshControl = UIRefreshControl()
    var start_index = 0
    var postId = String()
    var tag = Int()
    var totalCommentCount = String()
    var count : Int = 0
    var delegate : refreshCommentCountDelegate?


    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.commentsTableView.decelerationRate = UIScrollViewDecelerationRateFast;
        commentsTableView.separatorStyle = .none
        // refreshControl.tintColor = UIColor.white
       // refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
       // commentsTableView.addSubview(refreshControl)
        
        if totalCommentCount == "" || totalCommentCount == "0"
        {
            totalCommentsLabel.text = "No" + " " + "comments"
        }
        else
        {
            totalCommentsLabel.text = totalCommentCount + " " + "comments"
        }

        
        getCommentApi()
        //setupPullToRefresh()
       
        self.growingView.textView.textColor = UIColor(white: 0.9, alpha: 1)
        self.growingView.placeholderAttributedText = NSAttributedString(
            string: "Say Something Nice",
            attributes: [
                .font: self.growingView.textView.font!,
                .foregroundColor: UIColor.gray
            ]
        )

        growingView._maxHeight = 66
        growingView.delegates.didChangeHeight = { [weak self] height in
            guard self != nil else { return }
            print(height)
            if height  < 67 {
                self?.lowerViewHeightConstarint.constant  =  height + 20.0

            }
            // Do something
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }

    @objc func refresh() {

//        start_index = 0
//        commentsArray.removeAll()
//        getCommentApi()
//        refreshControl.endRefreshing()
    }




    @objc func keyboardWillHide(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                //key point 0,
                self.inputContainerViewBottom.constant =  0
                //self.lowerViewHeightConstarint.constant =  59

                //textViewBottomConstraint.constant = keyboardHeight
                UIView.animate(withDuration: 0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
            }
        }
    }
    @objc func keyboardWillShow(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.inputContainerViewBottom.constant = keyboardHeight
                //self.inputContainerViewBottom.constant = keyboardHeight
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }

    //MARK:-
    //MARK:- IB Actions
    
    @IBAction func cencelBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil
        )
    }


    @IBAction func postCommentBtnAction(_ sender: Any) {
//        self.growingView.textView.text = ""
        
        if self.growingView.textView.text == "" {
            
            self.showAlert(errMsg: "Please add comment")
            
        }
        
        else {
            self.view.endEditing(true)
            self.start_index = 0
            self.commentsArray.removeAll()
            self.commentsTableView.reloadData()
            addCommentsApi()
        }
    }

    //MARK:-
    //MARK:- TextView DataSources

//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.lightGray {
//            textView.text = nil
//            textView.textColor =  #colorLiteral(red: 0.8431372549, green: 0.6823529412, blue: 0.4901960784, alpha: 1)
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Say Somehing Nice"
//            textView.textColor = UIColor.lightGray
//        }
//    }

    //MARK:-
    //MARK:- TableView DataSources

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return commentsArray.count

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

            return UITableViewAutomaticDimension
    
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell", for: indexPath) as! CommentsCell
           // cell.cellImg.sd_setImage(with:URL(string:commentsArray[indexPath.row].image_profile))
        
          cell.cellImg.sd_setImage(with: URL(string :commentsArray[indexPath.row].image_profile), placeholderImage:  UIImage(named: "img_placeholder"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in
           
        }
        
           cell.cellImg.tag = indexPath.row
           cell.cellImg.isUserInteractionEnabled = true
             let tapgesture = UITapGestureRecognizer(target: self, action: #selector(userImageAction(sender:)))
            cell.cellImg.addGestureRecognizer(tapgesture)
            cell.nameLabel.text = commentsArray[indexPath.row].name
            cell.commentLabel.text = commentsArray[indexPath.row].comment
            cell.dateTimeLabel.text = commentsArray[indexPath.row].datetime
            cell.totalLikesLabel.text = "\(commentsArray[indexPath.row].single_tot_like)"

            return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == commentsArray.count - 1 && self.commentsArray.count > 19
        {
             self.start_index = commentsArray.count
             // self.start_index += 1
             self.getCommentApi()
        }
        
    }

    
    @objc func userImageAction(sender:UITapGestureRecognizer)  {
        let tag = (sender.view as? UIImageView)?.tag
        //        let indexPath = NSIndexPath(row: tag!, section: 0)
        //
        //        let cell = self.notificationTableView.cellForRow(at: indexPath as IndexPath) as! NotificationCell
        
        if commentsArray[tag!].id_user == RichnessUserDefault.getUserID() {
            let vc:ProfileVC = self.storyboard?.instantiateViewController(withIdentifier:"ProfileVC") as! ProfileVC
            let nav = UINavigationController(rootViewController: vc)
            vc.boolRecived = true
            
            self.present(nav, animated: true, completion: nil)
        }
            
        else {
            let vc:UserProfileViewController = self.storyboard?.instantiateViewController(withIdentifier:"UserProfileViewController") as! UserProfileViewController
            vc.objc = commentsArray[tag!].id_user
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
    }
    //MARK:-
    //MARK:- Api Methods

    func getCommentApi()
    {

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)

        let params = [
            "start_index" : self.start_index,
            "post_id" :postId,
            "key" : key
            ] as [String : Any]
        print(params)

       // start_index += 1

        RichnessAlamofire.POST(GETCOMMENTS_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                print(responseObject)
                self.commentsTableView.endRefreshing(at: .bottom)
                if(responseObject.object(forKey: "result") != nil){
                    let result = responseObject.object(forKey: "result") as? [NSDictionary]
                    print(result)

                    for item in result!{

                        let commentmodel = Comments()

                        commentmodel.id = item["id"] as? String ?? ""
                        if (commentmodel.id == ""){
                            commentmodel.id = String(describing: item["id"] as? Int)
                        }

                        commentmodel.comment = item["comment"] as? String ?? ""
                        commentmodel.data = item["data"] as? String ?? ""
                        commentmodel.datetime = item["datetime"] as? String ?? ""
                        commentmodel.id = item["id"] as? String ?? ""
                        commentmodel.id_user = item["id_user"] as? String ?? ""
                        commentmodel.image_profile = item["image_profile"] as? String ?? ""
                        commentmodel.name = item["name"] as? String ?? ""
                        commentmodel.single_tot_like = item["single_tot_like"] as? Int ?? 0
                        self.commentsArray.append(commentmodel)
                    }
                    
                   // self.totalCommentsLabel.text = "\(self.commentsArray.count)" + " " + "comments"
                  
                    
//                    if self.delegate != nil {
//                        self.delegate?.commentCountDidRecieve(count: self.commentsArray.count, tag: self.tag)
//                    }
                    
                    DispatchQueue.main.async {
                        self.commentsTableView.reloadData()
                    }
                }
               else //if self.start_index == 0
                {
                    //self.totalCommentsLabel.text = "0" + " " + "comments"
                }
            }
            else
            {
                let error = responseObject.object(forKey: "error") as? String
                if error == "#997" {
                    self.showError(errMsg: user_error_unknown)
                }
                else {
                    self.showError(errMsg: error_on_server)
                }
            }
        }
    }

    func addCommentsApi()
    {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        let addedComent :String = (growingView.textView.text?.trimmingCharacters(in: CharacterSet.whitespaces))!        
    
            let params = [
                "post_id" :postId,
                "comment" : addedComent,
                "user_id": RichnessUserDefault.getUserID(),
                "key" : key
                ] as [String : Any]
            print(params)
            
            //start_index += 1
            
            RichnessAlamofire.POST(ADDCOMMENTS_URL, parameters: params as [String : AnyObject],showLoading: false,showSuccess: false,showError: false
            ) { (result, responseObject)
                in
                if(result){
                    print(responseObject)
                    //self.commentsTableView.endRefreshing(at: .bottom)
                    if(responseObject.object(forKey: "result") != nil){
                        let result = responseObject.object(forKey: "result") as? [NSDictionary]
                        print(result)
                        self.commentsArray.removeAll()
                        self.growingView.textView.text = ""
                        
                        
                        
                        // var incCount : Int = Int(self.totalCommentCount)!
                        
                        if self.count == 0 {
                            self.count  = Int(self.totalCommentCount)!
                            self.count += 1
                        }
                        else {
                            self.count += 1
                        }
                        // incCount += 1
                        self.totalCommentsLabel.text = "\(self.count)" + " " + "comments"
                        
                        // let total: Int = (Int(self.totalCommentCount)! + 1)
                        // DispatchQueue.main.async {
                        //self.totalCommentsLabel.text = "\(total)" + " " + "comments"
                        //}
                        
                        if self.delegate != nil {
                            self.delegate?.commentCountDidRecieve(count: self.count , tag: self.tag)
                        }
                        
                        //                    self.getCommentApi()
                        
                        //                    if self.count > 0
                        //                    {
                        //                        self.count += 1
                        //                        self.totalCommentsLabel.text = "\(self.count)" + " " + "comments"
                        //
                        //                    }
                        //
                        //                    else
                        //                    {
                        //                        if self.totalCommentCount == "" {
                        //                            self.totalCommentCount = "0"
                        //                        }
                        //                      self.count = Int(self.totalCommentCount)!
                        //                      self.count += 1
                        //                      self.totalCommentsLabel.text = "\(self.count)" + " " + "comments"
                        //                    }
                        self.getCommentApi()
                        
                        //                    DispatchQueue.main.async {
                        //                        self.commentsTableView.reloadData()
                        //                    }
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

    //MARK:-
    //MARK:- Methods

    func setupPullToRefresh() {

//            self.commentsTableView.addPullToRefresh(PullToRefresh(position: .bottom)) { [weak self] in
//                if (self?.commentsArray.count)! % 20 != 0{
//                    self?.commentsTableView.removePullToRefresh(at: .bottom)
//                    return
//                }
//                self?.getCommentApi()
//            }

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
