//
//  PostEditorVC.swift
//  Blagh
//
//  Created by Wilson Zhao on 1/23/16.
//  Copyright © 2016 Innogen. All rights reserved.
//

import Foundation
import UIKit
import Parse
import HMSegmentedControl

class PostEditorVC : GenericTable {
    var segmentedControl : HMSegmentedControl?
    var elements: [PFObject] = []
    
    enum elementType: Int {
        case text
        case image
        case video
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newPostAnimated = false
        if let currentPost = Singleton.sharedInstance.currentPost {
            tableData = NSMutableArray(array: (currentPost["elements"] as? [PFObject])!)
        }
        
        SwiftSpinner.show("Loading Post")

        segmentedControl = HMSegmentedControl(sectionTitles: ["Text","Image","Video"])
        let frame = UIScreen.mainScreen().bounds
        segmentedControl!.frame = CGRectMake(frame.minX + 10, frame.maxY - 50,
            frame.width - 20, frame.height*0.1)
        view.addSubview(segmentedControl!)
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addElement"))
        self.navigationItem.setRightBarButtonItem(barButton, animated: true)
        
        // Config height
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        SwiftSpinner.hide()
      

    }
   
    func addElement() {
        
        var element = PFObject(className: "Element")
        element["type"] = segmentedControl?.selectedSegmentIndex
        element["text"] = "Click to edit\n Helphelpehlehelehhep im dyinnnngggggg"
        tableData.addObject(element)
        
        if let currentPost = Singleton.sharedInstance.currentPost {
            if var postElements : [PFObject] = currentPost["elements"] as? [PFObject]  {
                postElements.append(element)
                currentPost["elements"] = postElements
                currentPost.saveInBackground()
            }
        }
        //Save data
        element.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Saved Element")
            } else {
                // There was a problem, check error.description
            }
        }
        
        self.tableView.reloadData()
    }
    
  
    override func viewDidAppear(animated: Bool) {
        
        tableView.reloadData()
        
    }

    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return segmentedControl
        

    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int  {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return tableData.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "protoCell")
        let element = tableData[indexPath.row]
        switch element["type"] as! Int {
            case elementType.image.rawValue:
              
                
            
            break
        default:
            break
            
            
            
        }
        cell.textLabel!.text = element["text"] as? String
        cell.textLabel!.numberOfLines = 0;
        return cell
    }
    
  
}