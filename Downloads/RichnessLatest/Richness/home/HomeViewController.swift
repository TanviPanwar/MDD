//
//  profileViewController.swift
//  Richness
//
//  Created by Sobura on 6/6/18.
//  Copyright © 2018 Sobura. All rights reserved.
//

import Foundation
import UIKit
//import PullToRefresh
import SDWebImage
import Player
import IQKeyboardManagerSwift
import AVFoundation
import AVKit
class HomeViewController: PanelViewController, UITableViewDataSource, UITableViewDelegate, refreshCommentCountDelegate , GetAvPlayerStatusDelegate{

    func commentCountDidRecieve(count: Int, tag: Int)
     {
      commentCount = count

      guard let cell = tableView.cellForRow(at: IndexPath(row:tag, section: 0)) as? homeCell else {return}
      self.homeArray[tag].total_comments = "\(count)"
      cell.commentLabel.text = self.homeArray[tag].total_comments
      //self.tableView.reloadData()



     }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var totalCommentsLabel: UILabel!
    @IBOutlet weak var lowerView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saySomethingTextView: IQTextView!
    @IBOutlet weak var smileyBtn: UIButton!
    
    
    var profileImage = ""
    var refreshControl = UIRefreshControl()
    var start_index = 0
    var homeArray : [User] = []
    var commentsArray : [Comments] = []
    var player = Player()
    var commentCount : Int?
    var currentIndex :Int?

    var currentPage = CGFloat()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
      //  self.tableView.decelerationRate = UIScrollViewDecelerationRateFast;
        tableView.separatorStyle = .none
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        getDatas()
       // setupPullToRefresh()
        self.tableView.decelerationRate = UIScrollViewDecelerationRateFast
        ProjectManager.shared.avplayerDelegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: Notification.Name(rawValue: "PlayVideo"), object: nil)

//        let indexPath = NSIndexPath(forRow: tag, inSection: 0)
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! homeCell!
     // tableView.prefetchDataSource = self
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //self.updateTableViewContentInset()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    @objc func refresh() {
        
        start_index = 0
        homeArray.removeAll()
        getDatas()
        refreshControl.endRefreshing()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pausePlayeVideos()
    }

      func touchesBegan(_ touches: Set<AnyHashable>, with event: UIEvent) {
        let touch: UITouch? = touches.first as? UITouch
        //location is relative to the current view
        // do something with the touched point
        if touch?.view != commentsView {
            UIView.animate(withDuration: 0.5) {
                self.commentsView.center.y += self.commentsView.frame.height
            }
        }
    }


    //MARK:-
    //MARK:- TableView DataSources
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

           return homeArray.count


    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return UIScreen.main.bounds.size.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


            let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! homeCell
            cell.sideBtn.tag = indexPath.row
            cell.sideBtn.addTarget(self,action:#selector(sidebuttonClicked),
                                   for:.touchUpInside)
//            cell.profileBtn.tag = indexPath.row
//            cell.profileBtn.addTarget(self,action:#selector(profilebuttonClicked),
//                                      for:.touchUpInside)
//            cell.likesBtn.tag = indexPath.row
//            cell.likesBtn.addTarget(self,action:#selector(likesbuttonClicked),
//                                    for:.touchUpInside)
            cell.commentBtn.tag = indexPath.row
            cell.commentBtn.addTarget(self,action:#selector(commentbuttonClicked),
                                      for:.touchUpInside)
            cell.shareBtn.tag = indexPath.row
            cell.shareBtn.addTarget(self,action:#selector(sharebuttonClicked),
                                    for:.touchUpInside)



            //        let newaddr = User.sharedInstane.profile_pic.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            print(cell.frame)

        //cell.frame = CGRect(x:0, y: CGFloat(indexPath.row ) * UIScreen.main.bounds.size.height, width:UIScreen.main.bounds.size.width , height: UIScreen.main.bounds.size.height)
            if homeArray.count > 0 {
                if homeArray[indexPath.row].type == "0" {
                    cell.activityIndicator.isHidden = true

                    cell.profileImgView.isHidden = false
                    cell.videoView.isHidden = true
                    //cell.avatarImgView.sd_setImage(with: URL(string : homeArray[indexPath.row].image_profile))
                    cell.profileImgView.sd_setImage(with: URL(string : homeArray[indexPath.row].image))
                    cell.profileImg.sd_setImage(with: URL(string : homeArray[indexPath.row].image_profile))
                    //                cell.profileBtn.sd_setImage(with: URL(string : homeArray[indexPath.row].image_profile), for: .normal)
                    cell.likesLabel.text = homeArray[indexPath.row].likes
                    cell.commentLabel.text = homeArray[indexPath.row].total_comments
                    cell.shareLabel.text = homeArray[indexPath.row].shares
                    cell.rankingLabel.text = homeArray[indexPath.row].ranking
                    cell.configureCell(imageUrl: "", description: "Image", videoUrl:"")

                } else {
                    cell.activityIndicator.isHidden = false
                    DispatchQueue.main.async {
                        cell.activityIndicator.startAnimating()

                    }
                    cell.profileImgView.isHidden = true
                    cell.videoView.isHidden = false
                    cell.configureCell(imageUrl: "", description: "Video", videoUrl:  homeArray[indexPath.row].image)
                    cell.profileImg.sd_setImage(with: URL(string : homeArray[indexPath.row].image_profile))
                    //                cell.profileBtn.sd_setImage(with: URL(string : homeArray[indexPath.row].image_profile), for: .normal)
                    cell.likesLabel.text = homeArray[indexPath.row].likes
                    cell.commentLabel.text = homeArray[indexPath.row].total_comments
                    cell.shareLabel.text = homeArray[indexPath.row].shares
                    cell.rankingLabel.text = homeArray[indexPath.row].ranking
              

                }

                  if homeArray[indexPath.row].is_followed == 1
                  {
                     cell.addfollowerBtn.isHidden = true
                    cell.addFollowerImage.image = UIImage(named: "")
                 }

                  else{
                    cell.addfollowerBtn.isHidden = false
                    cell.addFollowerImage.image = UIImage(named: "side_menu_option_1")

                }

                //   cell.likeLabel.text = homeArray[indexPath.row].likes + " persons"
                //  cell.nameLabel.text = homeArray[indexPath.row].name
                cell.infoTxtView.text = homeArray[indexPath.row].text.decodeEmoji
                        if(homeArray[indexPath.row].user_like == "1"){
                            cell.likeButton.isChecked = true
                        }
                        else{
                            cell.likeButton.isChecked = false
                        }

                cell.on3DotButtonTapped = {

                    (self.owner as! MainViewController).reportAlertView.isHidden = false
                    (self.owner as! MainViewController).idimage = self.homeArray[indexPath.row].id

                }

                cell.onDiamondButtonTapped = {

                    if cell.likeButton.isChecked {
                        self.like_unlike(like_type: 1, imageId: self.homeArray[indexPath.row].id, cell: cell, index : indexPath.row)

                    }
                    else{
                        self.like_unlike(like_type: 2, imageId: self.homeArray[indexPath.row].id, cell: cell, index : indexPath.row)
                    }
                }

                cell.onProfileTapped = {

                    self.owner?.rightToLeft()
                    self.profileImage = self.homeArray[indexPath.row].image
                    let nextView = mainstoryboard.instantiateViewController(withIdentifier: "ImagePreviewController") as! ImagePreviewController
                    nextView.image = self.profileImage
                    print(self.profileImage)
                    self.owner?.present(nextView, animated: false, completion: nil)
                }

                cell.onAvatarTapped = {
                   
                    cell.videoLayer.player?.pause()
                    if self.homeArray[indexPath.row].id_user == RichnessUserDefault.getUserID() {
                        let nextView = mainstoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                        (self.owner as! MainViewController).loadNamedView(nextView: nextView)
                        (self.owner as! MainViewController).tabButton[1].setBackgroundImage(UIImage(named: "profile"), for: .normal)
                        (self.owner as! MainViewController).tabButton[0].setBackgroundImage(UIImage(named: "home1"), for: .normal)
                    }
                    else{
                        let nextView = mainstoryboard.instantiateViewController(withIdentifier: "OtherProfileViewController") as! OtherProfileViewController
                        RichnessUserDefault.setOtherUserID(val: self.homeArray[indexPath.row].id_user)
                        self.owner?.present(nextView, animated: true, completion: nil)
                    }
                }

                cell.addFollowerTapped = {

                    let userFollowed = self.homeArray[indexPath.row].id_user
                    self.addFollowerApi(userFollowed: userFollowed, cell: cell, index : indexPath.row)

                }
            }


             return cell

       


  }


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      currentIndex = indexPath.row
  //cell.frame = CGRect(x:0, y: CGFloat(indexPath.row ) * UIScreen.main.bounds.size.height, width:UIScreen.main.bounds.size.width , height: UIScreen.main.bounds.size.height)
//        if homeArray[indexPath.row].type == "1" {
//            print(indexPath)
//         if cell is homeCell {
//            let visibleCells = tableView.indexPathsForVisibleRows
//            if let minIndex = visibleCells?.first {
//                    guard let videoUrl: URL = URL(string:homeArray[minIndex.row].image) else { return }
//                    self.player.url = videoUrl
//                    self.player.playFromBeginning()
//            }
//       }
//        else {
//           self.player.pause()
//        }
//
//        }

        if indexPath.row == homeArray.count - 2
        {
           self.getDatas()
        }
        
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }

    @objc func sidebuttonClicked(sender: UIButton)
    {
//        let indexPath = NSIndexPath(row: sender.tag, section: 0)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath as IndexPath) as! homeCell
//
//        cell.sideView.frame = CGRect(x: cell.sideView.frame.origin.x , y: cell.sideView.frame.origin.y, width: cell.sideView.frame.size.width, height: cell.sideView.frame.size.height)

        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as! homeCell

        if cell.sideviewTrailingConstraint.constant == -87
        {

          cell.sideviewTrailingConstraint.constant = -1
          cell.sideBtn.setImage(UIImage(named: ""), for: UIControlState.normal)
        }

        else

        {
             cell.sideviewTrailingConstraint.constant = -87 //-79

        }

    }

//    @objc func profilebuttonClicked(sender: UIButton)
//    {
//
//    }

//    @objc func likesbuttonClicked(sender: UIButton)
//    {
//           // like_unlike(like_type: <#T##Int#>, imageId: <#T##String#>, cell: <#T##homeCell#>, index: <#T##Int#>)
//    }

    @objc func commentbuttonClicked(sender: UIButton)
    {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController

        vc.modalPresentationStyle = .overCurrentContext
        vc.postId = homeArray[sender.tag].id
        vc.tag = sender.tag
        vc.totalCommentCount = homeArray[sender.tag].total_comments
        vc.delegate = self
        self.parent?.present(vc, animated: true, completion: nil)
//        let indexPath = NSIndexPath(row: sender.tag, section: 0)
//        let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as! homeCell
//
//        let post_id = homeArray[indexPath.row].id
//        getCommentsApi(postId: post_id)



    }

    @objc func sharebuttonClicked(sender: UIButton)
    {

    }

    

//
//    var lastContentOffset:CGPoint!
//    var initialIndexPath:IndexPath?
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        lastContentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y)
//        var visibleCellIndexes = tableView.indexPathsForVisibleRows as! [IndexPath]
//        initialIndexPath = visibleCellIndexes[0]
//    }
//
//
//
//    var scrolledToPath:IndexPath?
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//
//        var lastIndexPath:IndexPath!
//        var nextIndexPath:IndexPath!
//        if scrolledToPath != nil {
//            lastIndexPath = scrolledToPath
//        }
//        else if initialIndexPath != nil {
//            lastIndexPath = initialIndexPath
//        }
//        if (lastContentOffset.y <= scrollView.contentOffset.y) {
//            // scrolling down
//            if (lastIndexPath.row == homeArray.count - 1) {
//                // last row in section
//                if (lastIndexPath.section == 0) {
//                    // last  section
//                    nextIndexPath = lastIndexPath
//                }
//                else {
//                    nextIndexPath = IndexPath(row: 0, section: lastIndexPath.section+1)
//                }
//            }
//            else {
//                nextIndexPath = IndexPath(row: lastIndexPath.row+1, section: lastIndexPath.section)
//            }
//        }
//        else if (lastContentOffset.y > scrollView.contentOffset.y) {
//            // scrolling up
//            if (lastIndexPath.row == 0) {
//                // first row in section
//                if (lastIndexPath.section == 0) {
//                    // first section
//                    nextIndexPath = lastIndexPath
//                }
//                else {
//                    nextIndexPath = IndexPath(row: homeArray.count - 1 , section: lastIndexPath.section-1)
//                }
//            }
//            else {
//                nextIndexPath = IndexPath(row: lastIndexPath.row-1 , section: lastIndexPath.section)
//            }
//
//        }
//
//        scrolledToPath = nextIndexPath
//
//
//
//        let rectOfNextIndexPath:CGRect = self.tableView.rectForRow(at: nextIndexPath)
//        targetContentOffset.pointee.y = rectOfNextIndexPath.origin.y
//
//
//    }

//
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//
//        let pageWidth: CGFloat = self.tableView.frame.size.width + 10 /* Optional Photo app like gap between images */;
//
//        currentPage = floor((self.tableView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//
//         print("Dragging - You are now on page %i", currentPage);
//    }
//
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//
//        let pageWidth: CGFloat = self.tableView.frame.size.width + 10;
//
//       var newPage = currentPage;
//
//        if (velocity.x == 0) // slow dragging not lifting finger
//        {
//          newPage = floor((targetContentOffset.pointee.x - pageWidth / 2) / pageWidth) + 1;
//        }
//        else
//        {
//            newPage = velocity.x > 0 ? currentPage + 1 : currentPage - 1;
//
//            if (newPage < 0)
//            {
//            newPage = 0;
//            }
//            if (newPage > self.tableView.contentSize.width / pageWidth) {
//            newPage = ceil(self.tableView.contentSize.width / pageWidth) - 1.0;
//            }
//        }
//
//       print("Dragging - You will be on %i page (from page %i)", newPage, currentPage);
//        let rectOfNextIndexPath:CGRect = self.tableView.rectForRow(at: nextIndexPath)
//         targetContentOffset.pointee.y = CGPoint(x: newPage * pageWidth, y: targetContentOffset.pointee.y)
//
//
////         targetContentOffset = CGPointMake(newPage * pageWidth, targetContentOffset.pointee.y);
//
//    }






    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayeVideos()

        let row = scrollView.contentOffset.y / UIScreen.main.bounds.size.height
        //let indexpath = IndexPath(row:Int(row) , section: 0)
        scrollView.contentOffset = CGPoint(x:0, y: UIScreen.main.bounds.size.height * CGFloat(row ))
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            pausePlayeVideos()
        }

    }

    func pausePlayeVideos(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView)
    }
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView, appEnteredFromBackground: true)
    }
    
    func getDatas() {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        
        let params = [
            "start_index" : self.start_index,
            "user_id" : RichnessUserDefault.getUserID(),
            "key" : key
            ] as [String : Any]
        print(params)
        
        start_index += 1
        
        RichnessAlamofire.POST(GETTIMELINE_URL, parameters: params as [String : AnyObject],showLoading: false,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                print(responseObject)
               // self.tableView.endRefreshing(at: .bottom)
                if(responseObject.object(forKey: "result") != nil){
                    let result = responseObject.object(forKey: "result") as? [NSDictionary]
                    
                    for item in result!{
                        
                        let usermodel = User()
                        
                        usermodel.id = item["id"] as? String ?? ""
                        if (usermodel.id == ""){
                            usermodel.id = String(describing: item["id"] as? Int)
                        }
                        
                        usermodel.country = item["country"] as? String ?? ""
                        usermodel.description = item["description"] as? String ?? ""
                        usermodel.id_user = item["id_user"] as? String ?? ""
                        usermodel.image = item["image"] as? String ?? ""
                        usermodel.image_profile = item["image_profile"] as? String ?? ""
                        usermodel.likes = item["likes"] as? String ?? ""
                        usermodel.name = item["name"] as? String ?? ""
                        usermodel.ranking = item["ranking"] as? String ?? ""
                        usermodel.total_comments = item["total_comments"] as? String ?? ""
                        usermodel.shares = item["shares"] as? String ?? ""
                        usermodel.text = item["text"] as? String ?? ""
                        print(item["text"] as? String ?? "")
                        usermodel.user_like = item["user_like"] as? String ?? ""
                        usermodel.type = item["type"] as? String ?? ""
                        usermodel.is_followed = item["is_followed"] as? Int ?? 0

                        self.homeArray.append(usermodel)
                       
                    }
                    DispatchQueue.main.async {
//                        UIView.performWithoutAnimation {
//                            self.tableView.reloadData()
//                            self.tableView.layoutIfNeeded()
//                            self.tableView.beginUpdates()
//                            self.tableView.endUpdates()
//                        }
                        self.tableView.reloadData()
                        self.tableView.performBatchUpdates({

                        }, completion: { (status) in
                            self.updateTableViewContentInset()

                        })
//                        let lastContentOffset = self.tableView.contentOffset
//                        self.tableView.beginUpdates()
//                        self.tableView.endUpdates()
//                        self.tableView.layer.removeAllAnimations()
//                        self.tableView.setContentOffset(lastContentOffset, animated: false)


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
    
    func like_unlike(like_type : Int, imageId : String, cell : homeCell, index : Int) {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)
        
        let params = [
            "liked_type" : like_type,
            "image_id" : imageId,
            "user_id" : RichnessUserDefault.getUserID(),
            "key" : key


            ] as [String : Any]
        print(params)
        
        RichnessAlamofire.POST(ADDLIKE_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){
                
                if(responseObject.object(forKey: "like_add") != nil){
                    if(like_type == 1){
                        
                        self.homeArray[index].likes = String(Int(self.homeArray[index].likes)! + 1)
                        cell.likesLabel.text = self.homeArray[index].likes //+ " persons"
                    }
                    else{
                        self.homeArray[index].likes = String(Int(self.homeArray[index].likes)! - 1)
                        cell.likesLabel.text = self.homeArray[index].likes //+ " persons"
                        
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

    func getCommentsApi(postId: String)
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

        start_index += 1

        RichnessAlamofire.POST(GETCOMMENTS_URL, parameters: params as [String : AnyObject],showLoading: false,showSuccess: false,showError: false
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

//                        UIView.animate(withDuration: 1.5) {
//                            self.commentsView.center.y -= self.commentsView.frame.height
//                            //self.commentsView.isHidden = false
//                        }



                    }



                    DispatchQueue.main.async {

                        self.commentsTableView.reloadData()
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

    func addFollowerApi(userFollowed: String, cell : homeCell, index : Int)
    {

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH"
        let key = BASE_KEY + "#" + dateFormatter.string(from: currentDate)

        let params = [
            "user_id" : RichnessUserDefault.getUserID(),
            "user_followed": userFollowed ,
            "key" : key
            ] as [String : Any]
        print(params)

        RichnessAlamofire.POST(ADDFOLLOWRES_URL, parameters: params as [String : AnyObject],showLoading: true,showSuccess: false,showError: false
        ) { (result, responseObject)
            in
            if(result){


                cell.addFollowerImage.image = UIImage(named: "")
                cell.addfollowerBtn.isHidden = true
                self.homeArray[index].is_followed = 1
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
    
    
//    func setupPullToRefresh() {
//        if tableView == self.tableView
//        {
//        self.tableView.addPullToRefresh(PullToRefresh(position: .bottom)) { [weak self] in
//            if (self?.homeArray.count)! % 20 != 0{
//                self?.tableView.removePullToRefresh(at: .bottom)
//                return
//            }
//            self?.getDatas()
//        }
//     }
//
//      //  else
////        {
////            self.commentsTableView.addPullToRefresh(PullToRefresh(position: .bottom)) { [weak self] in
////                if (self?.commentsArray.count)! % 20 != 0{
////                    self?.tableView.removePullToRefresh(at: .bottom)
////                    return
////                }
////                self?.getCommentsApi(postId: "")
////            }
//       // }
//    }

    /* Pragma mmrk
     IB Actions */

    @IBAction func cancelBtnAction(_ sender: UIButton)
    {
        UIView.animate(withDuration: 0.5) {
            self.commentsView.center.y += self.commentsView.frame.height
        }
    }

    @IBAction func smileyBtnAction(_ sender: UIButton)
    {


    }

     func stopActivityIndicator() {
        if currentIndex != nil {
        guard let cell = tableView.cellForRow(at: IndexPath(row:currentIndex!, section: 0)) as? homeCell else {return}
        cell.activityIndicator.stopAnimating()
        cell.activityIndicator.isHidden = true
        }
    }

    func updateTableViewContentInset() {
        let viewHeight: CGFloat = view.frame.size.height
        let tableViewContentHeight: CGFloat = tableView.contentSize.height
        let marginHeight: CGFloat = (viewHeight - tableViewContentHeight) / 2.0

        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}


// MARK: - UITableViewDataSourcePrefetching
//extension HomeViewController: UITableViewDataSourcePrefetching {
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        print("prefetchRowsAt \(indexPaths)")
//        indexPaths.forEach { self.getDatas(forItemAtIndex: $0.row) }
//    }
//
//    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
//        print("cancelPrefetchingForRowsAt \(indexPaths)")
//       // indexPaths.forEach { self.cancelDownloadingImage(forItemAtIndex: $0.row) }
//    }
//}







//extension HomeViewController: PlayerPlaybackDelegate , PlayerDelegate{
//    func playerReady(_ player: Player) {
//
//    }
//
//    func playerPlaybackStateDidChange(_ player: Player) {
//
//    }
//
//    func playerBufferingStateDidChange(_ player: Player) {
//
//    }
//
//    func playerBufferTimeDidChange(_ bufferTime: Double) {
//
//    }
//
//    func player(_ player: Player, didFailWithError error: Error?) {
//
//    }
//
//
//    public func playerPlaybackWillStartFromBeginning(_ player: Player) {
//    }
//
//    public func playerPlaybackDidEnd(_ player: Player) {
//    }
//
//    public func playerCurrentTimeDidChange(_ player: Player) {
//        let fraction = Double(player.currentTime) / Double(player.maximumDuration)
//    }
//
//    public func playerPlaybackWillLoop(_ player: Player) {
//    }
//
//}
