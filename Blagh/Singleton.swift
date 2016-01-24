//
//  Singleton.swift
//  SwiftSkeleton
//
//  Created by Wilson Zhao on 1/28/15.
//  Copyright (c) 2015 Innogen. All rights reserved.
//
import Foundation
import UIKit
import AVFoundation
import AVKit
import CoreData
import Parse

@objc protocol DataDelegate {
    optional func reloadData(data:NSMutableArray)

}


class Singleton {
    var delegate: DataDelegate?
    
    var currentBlog: PFObject?
    var currentPost: PFObject?

    
    func loadPosts() {
        // Retrieve Blogs
        
        // Retrieve Posts
        var query = PFQuery(className:"Post")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    objects.sort{a,b in
                           return a.updatedAt?.timeIntervalSinceReferenceDate < b.updatedAt?.timeIntervalSinceReferenceDate
                    }
                    for object in objects {
                        print(object.objectId)
                    }
                    self.delegate?.reloadData!(NSMutableArray(array: objects))
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }

    }
    
    func loadElements() {
        //Loading Elements
        var query = PFQuery(className:"Element")
       // query.includeKey("type")
        query.whereKey("post", equalTo:(currentPost?.objectId)!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print(self.currentPost?.objectId)
                print("Successfully retrieved \(objects!.count) elements.")
                // Do something with the found objects
                if let objects = objects {
                    self.delegate?.reloadData!(NSMutableArray(array: objects))
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }

    }
    
    func saveData() {
    
    }
    
    class var sharedInstance : Singleton {
        struct Static {
            static let instance : Singleton = Singleton()
        }
        return Static.instance
    }
    
 }