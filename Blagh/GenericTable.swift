//
//  GenericTable.swift
//  Blagh
//
//  Created by Wilson Zhao on 1/23/16.
//  Copyright © 2016 Innogen. All rights reserved.
//

import Foundation
import UIKit
class GenericTable : UITableViewController, DataDelegate  {
    var tableData: NSMutableArray = []
    var newPostAnimated: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        Singleton.sharedInstance.delegate = self
    }
    
    // Animation function
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == tableData.count - 1 && !newPostAnimated {
            newPostAnimated = true
            cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
            UIView.animateWithDuration(0.3, animations: {
                cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
                },completion: { finished in
                    UIView.animateWithDuration(0.1, animations: {
                        cell.layer.transform = CATransform3DMakeScale(1,1,1)
                    })
            })
        }
    }
    
    // Data for delegate
    func reloadData(data: NSMutableArray) {
        
        self.tableData = data
        SwiftSpinner.hide()
        self.tableView.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
}