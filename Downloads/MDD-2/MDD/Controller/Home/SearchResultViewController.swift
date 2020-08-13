//
//  SearchResultViewController.swift
//  MDD
//
//  Created by iOS6 on 09/08/19.
//  Copyright © 2019 IOS3. All rights reserved.
//

import UIKit

class SearchResultViewTableViewCell: UITableViewCell
{
    @IBOutlet weak var cellLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

class SearchResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    var resultArray = [CategoryObjectModel]()
    var catName = String()
    var titleString = String()
    var considercBool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if catName == "Yes" {
            
            if considercBool {
                
                titleLabel.text = "Coverage Considerations"
                
            } else {
            
              titleLabel.text = titleString
                
            }
            
        } else {
            
            titleLabel.text = "Major Industries & Employers"

        }
        
        searchResultTableView.tableFooterView = UIView()

    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    //MARK:-
    //MARK:- TableView DataSources
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return resultArray.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UIDevice.current.userInterfaceIdiom == .pad ? 80 : 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) as! SearchResultViewTableViewCell
        
        
        if catName == "Yes" {
            
            cell.cellLabel.text = resultArray[indexPath.row].link_text
            
            
        } else {
            
            cell.cellLabel.text = resultArray[indexPath.row].result
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if catName == "Yes" {
            
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RecentTweetsViewController") as! RecentTweetsViewController
            
            vc.covidLnk = self.resultArray[indexPath.row].link_url
            vc.covidTitle = self.resultArray[indexPath.row].link_text
            vc.covidSearchBool = true
            self.present(vc, animated: true, completion: nil)
            
            
        } else {
            
            
            
            
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
