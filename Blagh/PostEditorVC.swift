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
    
    enum elementType: Int {
        case text
        case image
        case video
    }
    
    override func viewDidLoad() {
        self.draggable = true
        super.viewDidLoad()
        self.newPostAnimated = false
        if let currentPost = Singleton.sharedInstance.currentPost {
            Singleton.sharedInstance.loadElements()
            //tableData = NSMutableArray(array: (currentPost["elements"] as? [PFObject])!)
        }
        
        SwiftSpinner.show("Loading Post")

        segmentedControl = HMSegmentedControl(sectionTitles: ["Text","Image","Video"])
        let frame = UIScreen.mainScreen().bounds
        segmentedControl!.frame = CGRectMake(frame.minX, frame.maxY - 60,
            frame.width, 60)
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);

        view.addSubview(segmentedControl!)
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addElement"))
        self.navigationItem.setRightBarButtonItem(barButton, animated: true)
        
        // Config height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150.0

        
        //tableView.setNeedsLayout()
        //tableView.layoutIfNeeded()
        
      //  SwiftSpinner.hide()
      

    }
    override func saveData() {
        if let currentPost = Singleton.sharedInstance.currentPost {
            if let postElements : [PFObject] = currentPost["elements"] as? [PFObject]  {
                currentPost["elements"] = postElements
                currentPost.saveInBackground()
            }
        }
        
    }
    override func viewWillDisappear(animated: Bool) {
        saveData()
    }
   
    func addElement() {
        
        var element = PFObject(className: "Element")
        element["type"] = segmentedControl?.selectedSegmentIndex
        element["text"] = "Click to edit\nHelp\nHelp\nHelp\n"
        element["post"] = Singleton.sharedInstance.currentPost?.objectId

        tableData.addObject(element)
        
        if let currentPost = Singleton.sharedInstance.currentPost {
            currentPost.addUniqueObjectsFromArray(tableData as [AnyObject], forKey: "elements")
            currentPost.saveInBackground()
//            if var postElements : [PFObject] = currentPost["elements"] as? [PFObject]  {
//                postElements.append(element)
//                currentPost.saveInBackground()
//               
//            }
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

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.bringSubviewToFront(segmentedControl!)
    }
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        segmentedControl!.transform = CGAffineTransformMakeTranslation(0, scrollView.contentOffset.y);

    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int  {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return tableData.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = ElementCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "elementCell")
        
        let element = tableData[indexPath.row]
        switch element["type"] as! Int {
            case 0:
                let cell = TextCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "textCell") as TextCell
                cell.loadItem(element["text"] as! String)
                return cell
            break
        default:
            break
            
            
        }
        return cell
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let element = tableData[indexPath.row]
        switch element["type"] as! Int {
        case 0:
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let textEditorVC = storyBoard.instantiateViewControllerWithIdentifier("TextEditorVC") as! TextEditorVC
            textEditorVC.element = element as? PFObject
            self.navigationController?.pushViewController(textEditorVC, animated: true)
            
            break
        default:
            break
        }

    }
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let itemToMove = tableData[fromIndexPath.row]
        tableData.removeObjectAtIndex(fromIndexPath.row)
        tableData.insertObject(itemToMove, atIndex: toIndexPath.row)
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let element = tableData[indexPath.row] as! PFObject
            element.deleteInBackground()
            tableData.removeObjectAtIndex(indexPath.row)
            if let currentPost = Singleton.sharedInstance.currentPost {
                currentPost.removeObject(element, forKey: "elements")
        
                currentPost.saveInBackground()
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.reloadData()

            
        }
        
    }
    
  
}