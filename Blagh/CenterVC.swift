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
class CenterVC: GenericTable, PostsDelegate {
    let singleton:Singleton = Singleton.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SwiftSpinner.show("Loading Posts")
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50.0)
            navigationController.title = "BLAGH"
        }
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addPost"))
        self.navigationItem.setRightBarButtonItem(barButton, animated: true)
        
        Singleton.sharedInstance.delegate = self
        self.tableView.reloadData()

    }
    
    func reloadData(data: NSMutableArray) {

        self.tableData = data
        SwiftSpinner.hide()
        self.tableView.reloadData()
    
    }
    
    func addPost() {

        var post = PFObject(className: "Post")
        post["text"] = "No text here"
        post["title"] = "Untitled"
        post["published"] = false
        post["elements"] = []
        tableData.insertObject(post, atIndex: 0)
        newPostAnimated = false
        
        //Save data
        post.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Saved Post")
            } else {
                // There was a problem, check error.description
            }
        }

     //        for p in tableData {
//            let indexPaths = NSMutableArray()
//            indexPaths.addObject(
//        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post: PFObject = (tableData[indexPath.row] as? PFObject)!
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "protoCell")
        cell.textLabel?.text = post["title"] as? String
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        Singleton.sharedInstance.currentPost = tableData[indexPath.row] as? PFObject
        // Get Cell Label
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let textEditorVC = storyBoard.instantiateViewControllerWithIdentifier("TextEditorVC");

       self.navigationController?.pushViewController(PostEditorVC(),animated: true)
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
