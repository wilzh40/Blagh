//
//  GenericTable.swift
//  Blagh
//
//  Created by Wilson Zhao on 1/23/16.
//  Copyright © 2016 Innogen. All rights reserved.
//

import Foundation
import UIKit
import Parse
class GenericTable : UITableViewController, DataDelegate  {
    var tableData: NSMutableArray = []
    var newPostAnimated: Bool = false
    var draggable: Bool = false
    struct Drag {
        static var placeholderView: UIView!
        static var sourceIndexPath: NSIndexPath!
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        Singleton.sharedInstance.delegate = self
        let longpress = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        tableView.addGestureRecognizer(longpress)

      
    }
    
    func orderDidChange() {
        
    }
    func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let point = gesture.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        
        switch gesture.state {
        case .Began:
            if let indexPath = indexPath {
                let cell = tableView.cellForRowAtIndexPath(indexPath)!
                Drag.sourceIndexPath = indexPath
                
                var center = cell.center
                Drag.placeholderView = placeholderFromView(cell)
                Drag.placeholderView.center = center
                Drag.placeholderView.alpha = 0
                
                tableView.addSubview(Drag.placeholderView)
                
                UIView.animateWithDuration(0.25, animations: {
                    center.y = point.y
                    Drag.placeholderView.center = center
                    Drag.placeholderView.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    Drag.placeholderView.alpha = 0.95
                    
                    cell.alpha = 0
                    }, completion: { (_) in
                        cell.hidden = true
                })
                
            }
        case .Changed:
            guard let indexPath = indexPath else {
                return
            }
            
            var center = Drag.placeholderView.center
            center.y = point.y
            Drag.placeholderView.center = center
            
            
            if indexPath != Drag.sourceIndexPath {
                var tableDataArr = tableData as [AnyObject]
                swap(&tableDataArr[indexPath.row], &tableDataArr[Drag.sourceIndexPath.row])
                tableData = NSMutableArray(array: tableDataArr)
                tableView.moveRowAtIndexPath(Drag.sourceIndexPath, toIndexPath: indexPath)
                
                // Danger! Must modify if not using elements
                let e1 = tableData[indexPath.row] as! PFObject
                let e2 = tableData[Drag.sourceIndexPath.row] as! PFObject
                swap(&e1["order"], &e2["order"])
                e1.saveInBackground()
                e2.saveInBackground()
                
                Drag.sourceIndexPath = indexPath
                //saveData()
            }
        default:
            if let cell = tableView.cellForRowAtIndexPath(Drag.sourceIndexPath) {
                cell.hidden = false
                cell.alpha = 0
                
                UIView.animateWithDuration(0.25, animations: {
                    Drag.placeholderView.center = cell.center
                    Drag.placeholderView.transform = CGAffineTransformIdentity
                    Drag.placeholderView.alpha = 0
                    cell.alpha = 1
                    }, completion: { (_) in
                        Drag.sourceIndexPath = nil
                        Drag.placeholderView.removeFromSuperview()
                        Drag.placeholderView = nil
                })
            }
        }
    }
    
    func placeholderFromView(view: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        let snapshotView : UIView = UIImageView(image: image)
        snapshotView.layer.masksToBounds = false
        snapshotView.layer.cornerRadius = 0.0
        snapshotView.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        snapshotView.layer.shadowRadius = 5.0
        snapshotView.layer.shadowOpacity = 0.4
        return snapshotView
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
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        
        
    }
    func saveData() {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    //Draggable
}