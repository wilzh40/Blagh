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

@objc protocol SavedSongsDelegate {
    optional func reloadData()
}


class Singleton {
    var delegate: SavedSongsDelegate?
    
     func setupData() {
        
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