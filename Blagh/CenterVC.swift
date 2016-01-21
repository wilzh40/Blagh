//
//  CenterVC.swift
//  ParseStarterProject-Swift
//
//  Created by Wilson Zhao on 1/21/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse
import CCInfiniteScrolling
import AMScrollingNavbar
class CenterVC: UITableViewController {
    let singleton:Singleton = Singleton.sharedInstance
    var tableData:NSMutableArray = ["1","2","3","4","5","6","e","a","b","c"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SwiftSpinner.hide()
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50.0)
            navigationController.title = "BLAGH"
        }
        self.tableView.reloadData()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "protoCell")
        cell.textLabel?.text = tableData[indexPath.row] as? String
        cell.textLabel?.font = UIFont(name:"Futura",size:11.00)
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.textLabel?.numberOfLines = 2
        
        // IF there is an artist display it
        
        // HACKY way when track.use has no data
      
        
        
        //cell.imageView!.image = ConnectionManager.getImageFromURL(track.artwork_url!)
        
        // Opti efforts
        cell.layer.shouldRasterize = false
        // cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
    }

    func newPost() {
        
    }
}
