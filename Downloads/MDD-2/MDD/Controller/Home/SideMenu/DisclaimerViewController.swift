//
//  DisclaimerViewController.swift
//  MDD
//
//  Created by iOS6 on 02/08/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class DisclaimerViewController: UIViewController {
    
    var fromCoverage = Bool()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.tableFooterView = UIView()

        
        
        let str = "The content of the CAT 365 Hub is provided for information purposes only. No legal liability or other responsibility is accepted by or on behalf of MDD for any errors, omissions, or statements on this site, or any site to which these pages connect.\n\nMDD accepts no responsibility for any loss, damage or inconvenience caused as a result of reliance on such information.\n\nMDD cannot control the content or take responsibility for pages maintained by external providers. Where we provide links to sites, we do not by doing so endorse any information or opinions appearing in them. We accept no liability whatsoever over the availability of linked pages.\n\nMDD reserves the right to refuse the provision of links to any external content, for whatever reason deemed fit."
        
        
        var size = CGFloat()
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            size = 25
            
        } else {
            
            size = 15
        }
        //
        
        
        descriptionLabel.attributedText = NSAttributedString(string: str,
                                                             attributes: [NSAttributedString.Key.font: UIFont.init(name: "Gotham-Book", size: size)!])
     
    }
    
    //Mark:-
    //MARK:- IB Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        if fromCoverage {
            
            self.dismiss(animated: true, completion: nil)
            
            
        } else {
        
        sideMenuController?.setContentViewController(with: "\(7)", animated: Preferences.shared.enableTransitionAnimation)
        
        sideMenuController?.hideMenu()
        
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
