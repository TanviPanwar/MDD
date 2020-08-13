//
//  NewCollectionViewController.swift
//  Richness
//
//  Created by iOS6 on 24/04/19.
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


class NewCollectionViewController: PanelViewController, UITableViewDelegate , UITableViewDataSource ,refreshCommentCountDelegate,GetAvPlayerStatusDelegate , UICollectionViewDelegateFlowLayout , RefreshHomeDelegate{
    

    
    
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playPauseBtn: UIButton!
    
    
    
    //MARK:- Varaiables
    let shotTableViewCellIdentifier = "ShotTableViewCell"
    let loadingCellTableViewCellCellIdentifier = "LoadingCellTableViewCell"
    var profileImage = ""
    var refreshControl = UIRefreshControl()
    var start_index = 0
    var homeArray : [User] = []
    var commentsArray : [Comments] = []
    //var player = Player()
    var currentIndex :Int?
    var commentCount : Int?
    var isFristtime : Bool = false
    var selectIndex:Int = -1
    var scrollBool = Bool()
    var currentCell :ShotTableViewCell?
    var isScroll = Bool()

    
    
    
    
    //MARK:- Object Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()

         viewDidLoadFunction()
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pausePlayeVideos()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pausePlayeVideos()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if currentCell != nil {
            if currentCell?.videoLayer != nil {
                currentCell?.videoLayer.player?.pause()
                ASVideoPlayerController.sharedVideoPlayer.pauseVideo(forLayer: (currentCell?.videoLayer)!, url:  homeArray[currentIndex!].image)
            }
            
        }
    }
    
    //MARK:- Functions
    func viewDidLoadFunction(){
        currentIndex = 0
        getDatas()
        
       
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = UIScreen.main.bounds.size.height
        tableView.rowHeight = UITableViewAutomaticDimension
        var cellNib = UINib(nibName:shotTableViewCellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: shotTableViewCellIdentifier)
        cellNib = UINib(nibName:loadingCellTableViewCellCellIdentifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: loadingCellTableViewCellCellIdentifier)
        tableView.separatorStyle = .none
      
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
        tableView.addSubview(refreshControl)
       
        ProjectManager.shared.avplayerDelegate = self
       
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarHeightChanged), name: NSNotification.Name.UIApplicationWillChangeStatusBarFrame, object: nil)
       // NotificationCenter.default.addObserver(self, selector: #selector(self.updateCollection), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        
        
        ProjectManager.shared.refreshHomeDelegate = self
    }
    
    
    
    //MARK:- Table view methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            print(UIApplication.shared.statusBarFrame.height)
            if UIScreen.main.bounds.size.height > 800 {
                if UIApplication.shared.statusBarFrame.height > 44 {
                    
                    return
                        UIScreen.main.bounds.size.height - (UIApplication.shared.statusBarFrame.height - 20)
                } else {
                    return  UIScreen.main.bounds.size.height - bottomPadding!
                }
            } else {
                if UIApplication.shared.statusBarFrame.height > 20 {
                    
                    return
                        UIScreen.main.bounds.size.height - (UIApplication.shared.statusBarFrame.height - 20)
                } else {
                    return  UIScreen.main.bounds.size.height
                }
            }
           
        }
        else {
            if UIApplication.shared.statusBarFrame.height > 20 {
                
                return  UIScreen.main.bounds.size.height - (UIApplication.shared.statusBarFrame.height - 20)
            } else {
                return  UIScreen.main.bounds.size.height
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: shotTableViewCellIdentifier, for: indexPath) as! ShotTableViewCell
        
        
          print("cell height--\(cell.shotImageView.frame.height)")
        
        
        cell.infoTextView.textContainer.maximumNumberOfLines = 5
        
        
        cell.profileImg.layer.borderWidth = 1
        cell.profileImg.layer.masksToBounds = false
        cell.profileImg.layer.borderColor = #colorLiteral(red: 0.8549019608, green: 0.737254902, blue: 0.5843137255, alpha: 1)
        cell.profileImg.layer.cornerRadius = cell.profileImg.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        cell.profileImg.clipsToBounds = true
        
        cell.sideBtn.tag = indexPath.row
        cell.sideBtn.addTarget(self,action:#selector(sidebuttonClicked),
                               for:.touchUpInside)
        cell.commentBtn.tag = indexPath.row
        cell.commentBtn.addTarget(self,action:#selector(commentbuttonClicked),
                                  for:.touchUpInside)
        cell.shareBtn.tag = indexPath.row
        cell.shareBtn.addTarget(self,action:#selector(sharebuttonClicked),
                                for:.touchUpInside)
        
        
        if homeArray.count > 0 {
            currentCell = cell
            if homeArray[indexPath.row].type == "0" {
                
                cell.playPauseBtn.isHidden = true
                cell.activityIndicator.isHidden = true
               // cell.profileImageView.isHidden = false
               // cell.videoView.isHidden = true
                
                cell.shotImageView.sd_setImage(with: URL(string : homeArray[indexPath.row].image), placeholderImage: nil, options: [.cacheMemoryOnly]) { (image, error, cache, url) in
                    if image != nil {
                        let width: CGFloat = image!.size.width
                        let height: CGFloat = image!.size.height
                        if height > width {
                            cell.shotImageView.contentMode = .scaleAspectFill
                            cell.shotImageView.clipsToBounds = true
                        }
                            
                        else {
                            cell.shotImageView.contentMode = .scaleAspectFit
                        }
                    }
                }
                
                
                cell.profileImg.sd_setImage(with: URL(string : homeArray[indexPath.row].image_profile))
                
                cell.likesLabel.text = homeArray[indexPath.row].likes
                cell.commentLabel.text = homeArray[indexPath.row].total_comments
                cell.shareLabel.text = homeArray[indexPath.row].shares
                cell.rankingLabel.text = homeArray[indexPath.row].ranking
                
               // ASVideoPlayerController.sharedVideoPlayer.pauseVideo(forLayer: cell.videoLayer, url:  homeArray[indexPath.row].image)
              //  cell.configureCell(imageUrl: "", description: "Image", videoUrl:"")
                cell.configureCell(imageUrl: homeArray[indexPath.row].image, description: "Image", videoUrl: nil)
                
            }
            else {
                
                let videourl = (homeArray[indexPath.row].image)
                if videourl.hasPrefix("https") {
                    
                    
                    
                    
                  
                  
                   
                    
                   // stopActivityIndicator()
                   
                    cell.playPauseBtn.isHidden = false
                    DispatchQueue.main.async {
                        
                        cell.playPauseBtn.setImage(#imageLiteral(resourceName: "pause-video"), for: .normal)
                        cell.playPauseBtn.setImage(#imageLiteral(resourceName: "pause-video"), for: .selected)
                        
                       // cell.videoView.tag = indexPath.row
                        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(self.imageTapped(tapGestureRecognizer:)))
                        
                        //cell.videoView.isUserInteractionEnabled = true
                       // cell.videoView.addGestureRecognizer(tapGestureRecognizer)
                        
                        
                        
                        
                     cell.activityIndicator.isHidden = false
                    cell.activityIndicator.startAnimating()
                        
                    }
                    
                   // cell.shotImageView.isHidden = true
                  //  cell.videoView.isHidden = false
                    
                      cell.configureCell(imageUrl: "", description: "Video", videoUrl: homeArray[indexPath.row].image)
                  
                    
                    
                }
                    
                else {
                    cell.activityIndicator.isHidden = true
                  //  cell.profileImageView.isHidden = true
                  //  cell.videoView.isHidden = true
                    cell.playPauseBtn.isHidden = true
                   
                }
                
                cell.profileImg.sd_setImage(with: URL(string : homeArray[indexPath.row].image_profile))
                
                cell.likesLabel.text = homeArray[indexPath.row].likes
                cell.commentLabel.text = homeArray[indexPath.row].total_comments
                cell.shareLabel.text = homeArray[indexPath.row].shares
                cell.rankingLabel.text = homeArray[indexPath.row].ranking
            }
            
            
           
            cell.infoTextView.text = homeArray[indexPath.row].text.decodeEmoji
            
            let size = cell.infoTextView.sizeThatFits(CGSize(width: cell.infoTextView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            if size.height != cell.infoTextHeightConstarint.constant && size.height > cell.infoTextView.frame.size.height {
                cell.infoTextHeightConstarint.constant = size.height
                cell.infoTextView.setContentOffset(CGPoint.zero, animated: false)
                
                
            }
            
            
            
            
            
            if !(homeArray[indexPath.row].id_user == RichnessUserDefault.getUserID()) {
                
                if homeArray[indexPath.row].is_followed == 1
                {
                    cell.addfollowerBtn.isHidden = true
                    cell.addFollowerImage.image = UIImage(named: "")
                }
                    
                else{
                    cell.addfollowerBtn.isHidden = false
                    cell.addFollowerImage.image = UIImage(named: "side_menu_option_1")
                    
                }
                
            }
                
            else {
                
                cell.addfollowerBtn.isHidden = true
                cell.addFollowerImage.image = UIImage(named: "")
                
            }
            
           
            cell.infoTextView.text = homeArray[indexPath.row].text.decodeEmoji
            if(homeArray[indexPath.row].user_like == "1"){
                cell.likeButton.isChecked = true
            }
            else{
                cell.likeButton.isChecked = false
            }
            
            
            //-------Cell Buttons---------------
            cell.onPlayPauseButtonTapped = {
                
                if cell.playPauseBtn.currentImage!.isEqual(UIImage(named: "pause-video")) {
                    
                    cell.playPauseBtn.setImage(UIImage(named: "play-video1"), for: .normal)
                    //self.pausePlayeVideos()
                    
                    ASVideoPlayerController.sharedVideoPlayer.pauseVideo(forLayer: cell.videoLayer, url: (self.homeArray[indexPath.row].image))
                    
                }
                    
                else {
                    cell.playPauseBtn.setImage(UIImage(named: "pause-video"), for: .normal)
                    
                    ASVideoPlayerController.sharedVideoPlayer.playVideo(withLayer: cell.videoLayer, url: (self.homeArray[indexPath.row].image))
                    
                }
                
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
                   
                    let nextView = mainstoryboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                    
                    (self.owner as! MainViewController).loadNamedView(nextView: nextView)
                    (self.owner as! MainViewController).tabButton[1].setBackgroundImage(UIImage(named: "profile"), for: .normal)
                    (self.owner as! MainViewController).tabButton[0].setBackgroundImage(UIImage(named: "home1"), for: .normal)
                }
                else{
                   
                    let nextView = mainstoryboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
                    RichnessUserDefault.setOtherUserID(val: self.homeArray[indexPath.row].id_user)
                    nextView.objc = self.homeArray[indexPath.row].id_user
                    let nav = UINavigationController(rootViewController:nextView )
                    self.owner?.present(nav, animated: true, completion: nil)
                }
            }
            
            cell.addFollowerTapped = {
                
                let userFollowed = self.homeArray[indexPath.row].id_user
                self.addFollowerApi(userFollowed: userFollowed, cell: cell, index : indexPath.row)
                
            }
            
            
        }
        
       
        
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //let cell = tableView.cellForRow(at: indexPath) as! NewTableViewCell
            //tableView.dequeueReusableCell(withIdentifier: "NewTableViewCell", for: indexPath) as! NewTableViewCell
      //  cell.playPauseBtn.setImage(UIImage(named: "pause-video"), for: .normal)
        
        currentIndex = indexPath.row
        if indexPath.row == homeArray.count - 1 && homeArray.count > 19  {
           
            self.getDatas()
           
        }
        
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayeVideos()
        
        
        if !scrollBool {
            scrollBool = true
        }else {
            for i in tableView.visibleCells {
                let indxpath = tableView.indexPath(for:i)
                
                if let cell = i as? ShotTableViewCell {
                    cell.playPauseBtn.setImage(#imageLiteral(resourceName: "pause-video"), for: .normal)
                    cell.sideviewTrailingConstraint.constant = -87
                }
             }
        }
        
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
    
    
    func layoutTableView() {
        var height = CGFloat()
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            print(UIApplication.shared.statusBarFrame.height)
            if UIScreen.main.bounds.size.height > 800 {
                if UIApplication.shared.statusBarFrame.height > 44 {
                    
                    height =
                        UIScreen.main.bounds.size.height - (UIApplication.shared.statusBarFrame.height - 20)
                } else {
                    height =   UIScreen.main.bounds.size.height - bottomPadding!
                }
            } else {
                if UIApplication.shared.statusBarFrame.height > 20 {
                    
                    height =
                        UIScreen.main.bounds.size.height - (UIApplication.shared.statusBarFrame.height - 20)
                } else {
                    height =   UIScreen.main.bounds.size.height
                }
            }
            
        }
        else {
            if UIApplication.shared.statusBarFrame.height > 20 {
                
                height =   UIScreen.main.bounds.size.height - (UIApplication.shared.statusBarFrame.height - 20)
            } else {
                height =   UIScreen.main.bounds.size.height
            }
            
        }
//        tableView.frame = view.bounds
//        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let contentSize: CGSize = tableView.contentSize
        let boundsSize: CGSize = tableView.bounds.size
        var yOffset: CGFloat = 0
        if contentSize.height > boundsSize.height {
            yOffset = CGFloat(floorf(Float((boundsSize.height - contentSize.height) / 2)))
        }
        if currentIndex != nil {
            tableView.contentOffset = CGPoint(x: 0, y: yOffset)
        }
      
    }
    //MARK:- Actions
    
    @objc func statusBarHeightChanged() {
        self.tableView.reloadData()
        if homeArray.count > 0{
            self.tableView.scrollToRow(at: IndexPath(item:0, section: 0), at: .top, animated: true)
            //self.tableView.scrollToItem(at:IndexPath(item:0, section: 0), at: .top, animated: true)
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        
        let tag = (tapGestureRecognizer.view)?.tag
        let indexPath = NSIndexPath(row: tag!, section: 0)
        
        let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as! ShotTableViewCell
            //self.tableView.cellForItem(at: indexPath as IndexPath) as! CollectionViewCell
        
        if  cell.playPauseBtn.isHidden {
            cell.playPauseBtn.isHidden = false
        } else {
            cell.playPauseBtn.isHidden = true
        }
        
    }
    
    
    
    @objc func sidebuttonClicked(sender: UIButton) {
      
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
       
        let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as? ShotTableViewCell
            //self.tableView.cellForItem(at: indexPath as IndexPath) as? NewTableViewCell
        
        if cell!.sideviewTrailingConstraint.constant == -87
        {
             cell!.sideviewTrailingConstraint.constant = -1
            cell!.sideBtn.setImage(UIImage(named: ""), for: UIControlState.normal)
        }else{
            cell!.sideviewTrailingConstraint.constant = -87 //-79
        }
        
    }
    
    
    
    
    @objc func commentbuttonClicked(sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.postId = homeArray[sender.tag].id
        vc.tag = sender.tag
        vc.totalCommentCount = homeArray[sender.tag].total_comments
        vc.delegate = self
        self.parent?.present(vc, animated: true, completion: nil)
        
    }
    
    
    
    @objc func sharebuttonClicked(sender: UIButton) {
        
        let url = URL(string:homeArray[sender.tag].image)
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
    }
    

 
    @IBAction func searchBtnAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        vc.modalPresentationStyle = .overCurrentContext
       
        let nav = UINavigationController(rootViewController: vc )
        self.present(nav, animated:true, completion:nil)
        
    }
    
    
    func stopActivityIndicator() {
        if currentIndex != nil {
            guard let cell = tableView.cellForRow(at:IndexPath(row: currentIndex!, section: 0)) as? ShotTableViewCell
                
                else {return}
            
        DispatchQueue.main.async {
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.isHidden = true
            }
        }
    }

    
    
    
    
    //MARK:- Delegates
    
    func commentCountDidRecieve(count: Int, tag: Int) {
        commentCount = count
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: currentIndex!, section: 0)) as? ShotTableViewCell
        else {return}
            //tableView.cellForItem(at: IndexPath(row: currentIndex!, section: 0)) as? CollectionViewCell else {return}
        self.homeArray[tag].total_comments = "\(count)"
        cell.commentLabel.text = self.homeArray[tag].total_comments
        //self.tableView.reloadData()
      }

    @objc func refresh() {
        
        start_index = 0
        homeArray.removeAll()
        self.tableView.reloadData()
        getDatas()
        refreshControl.endRefreshing()
    }
    
    
    //MARK:- API calls
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
                        self.tableView.reloadData()
                        self.pausePlayeVideos()
                        self.layoutTableView()
                       // self.tableView.scrollRectToVisible(CGRect(x: 0 , y: 0 , width : UIScreen.main.bounds.width , height : UIScreen.main.bounds.width), animated: true)
                       
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
    
    
    
    
    func like_unlike(like_type : Int, imageId : String, cell : ShotTableViewCell, index : Int) {
        
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
    
    
    func addFollowerApi(userFollowed: String, cell : ShotTableViewCell, index : Int)
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
    
    
    //END
}

