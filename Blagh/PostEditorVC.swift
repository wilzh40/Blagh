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
import SAScrollTableViewCell


class PostEditorVC : GenericTable, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
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
        tableView.estimatedRowHeight = 125.0
        tableView.separatorStyle = .None

     
        // Title for the blog
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 22))
        if let currentPost: PFObject = Singleton.sharedInstance.currentPost {
            textField.text = currentPost["title"] as? String
            
        }
        textField.font = UIFont(name: "Futura", size: 19)
        textField.textColor = UIColor.whiteColor()
        textField.textAlignment = .Center
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.Done

        self.navigationItem.titleView = textField
        

        
        //  SwiftSpinner.hide()
        
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let currentPost: PFObject = Singleton.sharedInstance.currentPost {
            currentPost["title"] = textField.text
            currentPost.saveInBackground()
            
        }
    }
   
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        element["order"] = Singleton.sharedInstance.currentPost?["elementCount"]
        element["type"] = segmentedControl?.selectedSegmentIndex
        element["post"] = Singleton.sharedInstance.currentPost?.objectId
        
        switch (segmentedControl?.selectedSegmentIndex)! {
        case 0:
            element["text"] = "Click to edit"
            break
        case 1:
            
            let imageEditorVC = ImageEditorVC()
            imageEditorVC.element = element             //imageEditorVC.imgView.image = cell.imgView.image
            imageEditorVC.firstImage = true
            self.navigationController?.pushViewController(imageEditorVC, animated: true)

            /*
            let url = NSURL(string: "https://upload.wikimedia.org/wikipedia/en/1/10/Apophysis-100303-104.jpg")
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            let image = UIImage(data: data!)?.resize(toWidth: 200)
            let imageData = UIImagePNGRepresentation(image!)
            let imageFile = PFFile(name:"image.png", data:imageData!)! as PFFile
            imageFile.saveInBackground()
            element["image"] = imageFile
            /*UIImage.contentsOfURL(NSURL(string: "http://www.cosmicmind.io/CM/iTunesArtwork.png")!) { (image: UIImage?, error: NSError?) in
                if let v: UIImage = image {
                    let imageData = UIImagePNGRepresentation(image!)
                    let imageFile = PFFile(name:"image.png", data:imageData!)! as PFFile
                    element["image"] = imageFile
                } else {
                    let imageData = UIImagePNGRepresentation(UIImage(contentsOfFile: "MaterialBackground")!)
                    let imageFile = PFFile(name:"image.png", data:imageData!)! as PFFile
                    element["image"] = imageFile
                }
            }*/
*/
            
            
            break
        case 2:
            let videoEditorVC = VideoEditorVC()
            videoEditorVC.element = element             //imageEditorVC.imgView.image = cell.imgView.image
            videoEditorVC.firstImage = true
            self.navigationController?.pushViewController(videoEditorVC, animated: true)
            
            break
        default: break
            
        }
        
        tableData.addObject(element)
        
        
        if let currentPost = Singleton.sharedInstance.currentPost {
            currentPost.incrementKey("elementCount")
            currentPost.addUniqueObjectsFromArray(tableData as [AnyObject], forKey: "elements")
            currentPost.saveInBackground()
        }
        //Save data
        
        element.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Saved Element")
                //self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.tableData.count, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            } else {
                // There was a problem, check error.description
            }
        }
        
        self.tableView.reloadData()
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
        case 1:
            
            
            let cell = ImageCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "imageCell") as ImageCell
            if let imageData = element.valueForKey("image") as? PFFile {
                imageData.getDataInBackgroundWithBlock({
                    (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil && imageData != nil) {
                        let image = UIImage(data:imageData!)
                        cell.loadImage(image!)
                        
                    }
                })
            }

            //cell.loadItem(element["text"] as! String)
            return cell
            break
            
        case 2:
            let cell = VideoCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "videoCell") as VideoCell
            if let str = element.valueForKey("video") as? String {
                cell.videoURL = /*"file:///" + */str
                cell.loadItem(str)
                return cell
            }

            /*
            let cell = SAScrollTableViewCell(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 230))

            if let video = NSBundle.mainBundle().URLForResource(element.valueForKey("video") as? String, withExtension: "mov"){
                cell.setMedia([SAScrollMedia.mediaWithType(SAScrollMediaType.VideoAsset, object: video)])
                return cell

            } else {
                print("Error, can't load video")
            }*/
            
            break

            //            break
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
        case 1:
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! ImageCell
            let imageEditorVC = ImageEditorVC()
            imageEditorVC.element = element as? PFObject
            imageEditorVC.imgView.image = cell.imgView.image
            imageEditorVC.firstImage = false
             self.navigationController?.pushViewController(imageEditorVC, animated: true)
            break
        case 2:
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! VideoCell
            let videoEditorVC = VideoEditorVC()
            videoEditorVC.element = element as? PFObject
            videoEditorVC.videoURL = cell.videoURL
            videoEditorVC.firstImage = false
            self.navigationController?.pushViewController(videoEditorVC, animated: true)

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

            //tableView.reloadData()
            
            
        }
        
    }
    
    
}