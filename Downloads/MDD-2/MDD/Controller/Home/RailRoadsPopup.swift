//
//  RailRoadsPopup.swift
//  MDD
//
//  Created by iOS6 on 10/06/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit
import PopupDialog

class RailRoadsPopup: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var catNameLabel: UILabel!
    @IBOutlet weak var railRoadsTableView: UITableView!
    
    var itemArray = ["Odisha Rail Map","West Bengal Rail Map","Tripura Rail Map","West Bengal Railway Map","Odisha Railway Map","Mineral Map of West Bengal"]
    
    var cancelAction : blockAction?
    var descriptionArray = [CategoryObjectModel]()
    var categoryName = String()
    var imageUrl = String()
    var parentId = String()
    var childId = String()
    var catastropheid = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        railRoadsTableView.tableFooterView = UIView()
        containerView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: 10)
        catNameLabel.text = categoryName.html2String
        
        var height = CGFloat()
        if UIDevice.current.userInterfaceIdiom == .pad {
            height = 130
        }
       else {
             height = 90
        }
        
        imageContainerView.setBorder(width: 1, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), cornerRaidus: height/2)

       imageView.sd_setImage(with: URL(string : imageUrl), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [.cacheMemoryOnly]) { (image, error, cache, url) in

        }
        
    }
    
    
    //Mark:-
    //MARK:- IB Actions
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        self.cancelAction!()

        
    }
    
    
    //MARK:-
    //MARK:- TableView DataSources
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return descriptionArray.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UIDevice.current.userInterfaceIdiom == .pad ? 94 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"RailRoadsTableViewCell", for: indexPath) as! RailRoadsTableViewCell
        
            cell.accessoryType = .disclosureIndicator
        
         cell.cellLabel.text = descriptionArray[indexPath.row].title.html2String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecentTweetsViewController") as! RecentTweetsViewController
        
        vc.popupObj =  descriptionArray[indexPath.row].link_url
        vc.popupTitle = descriptionArray[indexPath.row].title.html2String
        vc.popupBool = true
        vc.catastropheid = catastropheid
        vc.parentId = parentId
        vc.childId = childId
        vc.linkId = descriptionArray[indexPath.row].linkId 
        self.present(vc, animated: true, completion: nil)
        
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
