//
//  VideoEditorVC.swift
//  Blagh
//
//  Created by Wilson Zhao on 2/19/16.
//  Copyright © 2016 Innogen. All rights reserved.
//

import Foundation
//
//  ImageEditorVC.swift
//  Blagh
//
//  Created by Wilson Zhao on 2/13/16.
//  Copyright © 2016 Innogen. All rights reserved.
//

import Foundation
import UIKit
import Material
import Parse
import AVFoundation
import AVKit
import MediaPlayer
import MobileCoreServices
import Player

class VideoEditorVC : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CameraDelegate, PlayerDelegate {
    let imagePicker = UIImagePickerController()
    let imgView = UIImageView()
    var element: PFObject!
    var firstImage: Bool = false
    var videoURL: String?
    let player = Player()
    
    override func viewDidLoad() {
        view.backgroundColor = MaterialColor.white
        
        imagePicker.delegate = self
        /*
        imgView.frame = view.bounds
        imgView.contentMode = .Center;
        if !firstImage {
            if (imgView.bounds.size.width > imgView.image!.size.width && imgView.bounds.size.height > imgView.image!.size.height) {
                imgView.contentMode = UIViewContentMode.ScaleAspectFit;
            }
        }
        view.addSubview(imgView)*/
        self.player.delegate = self
        self.player.view.frame = self.view.bounds
        
        self.addChildViewController(self.player)
        self.view.addSubview(self.player.view)
        self.player.didMoveToParentViewController(self)
        self.player.playbackLoops = true
        if !firstImage {
            let url = NSURL(fileURLWithPath: videoURL!)
            print("\(url)")
            self.player.setUrl(url)
            self.player.playFromBeginning()
            self.player.fillMode = "AVLayerVideoGravityResizeAspect"
            
        }
        
        prepareCameraButton()
        preparePhotoLibraryButton()
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("done"))
        self.navigationItem.setRightBarButtonItem(barButton, animated: true)
            self.player.playbackLoops = true
            
            let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGestureRecognizer:")
            tapGestureRecognizer.numberOfTapsRequired = 1
            self.player.view.addGestureRecognizer(tapGestureRecognizer)
        }
        
    
        // MARK: UIGestureRecognizer
        
        func handleTapGestureRecognizer(gestureRecognizer: UITapGestureRecognizer) {
            switch (self.player.playbackState.rawValue) {
            case PlaybackState.Stopped.rawValue:
                self.player.playFromBeginning()
            case PlaybackState.Paused.rawValue:
                self.player.playFromCurrentTime()
            case PlaybackState.Playing.rawValue:
                self.player.pause()
            case PlaybackState.Failed.rawValue:
                self.player.pause()
            default:
                self.player.pause()
            }
        }

    
    func done() {
       /* let image = imgView.image?.resize(toWidth: 200) //Hacky way to ensure file size
        let imageData = UIImagePNGRepresentation(image!)
        let imageFile = PFFile(name:"image.png", data:imageData!)! as PFFile*/
        element["video"] = videoURL!
        element.saveInBackground()
        Singleton.sharedInstance.loadElements()
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }
    override func viewWillAppear(animated: Bool) {
        if !firstImage {
            let url = NSURL(fileURLWithPath: videoURL!)
        self.player.setUrl(url)
        player.playFromBeginning()
        }
    }
    
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()){
            if (element["video"] == nil) {
                element.deleteInBackground()
            }
        }
    }
    

    func handlePhotoLibraryButton() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as NSString as String]

        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        /*
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgView.contentMode = .ScaleAspectFit
            imgView.image = pickedImage
        }*/
        print(info)
        
        videoURL = (info[UIImagePickerControllerMediaURL] as! NSURL).path!/*!.stringByReplacingOccurrencesOfString("trim.", withString: "", options: [], range: nil )*/ as String
       /* if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (videoURL!)) {
            UISaveVideoAtPathToSavedPhotosAlbum (videoURL!, nil, nil, nil);
        }*/
        let url = info[UIImagePickerControllerMediaURL] as! NSURL
        print(url)
        player.setUrl(url)
        player.playFromBeginning()

        self.dismissViewControllerAnimated(true, completion:nil)
        //Here you can manipulate the adquired video
    }
    
      func handleCameraButton() {
        var captureVC = CaptureVC()
        captureVC.delegate = self
        
        
        //captureVC.captureView
        presentViewController(captureVC, animated: true, completion: nil)
        
    }
    
    func prepareCameraButton() {
        let image: UIImage? = UIImage(named: "ic_photo_camera_white_36pt")
        let button: FabButton = FabButton()
        button.backgroundColor = MaterialColor.indigo.accent3
        button.setImage(image, forState: .Normal)
        button.setImage(image, forState: .Highlighted)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromBottomRight(view, child: button, bottom: 16, right: 16)
        MaterialLayout.size(view, child: button, width: 56, height: 56)
        button.addTarget(self, action: "handleCameraButton", forControlEvents: .TouchUpInside)
        
    }
    
    
    func preparePhotoLibraryButton() {
        let image: UIImage? = UIImage(named: "ic_menu_white")
        let button: FabButton = FabButton()
        button.backgroundColor = MaterialColor.indigo.accent3
        button.setImage(image, forState: .Normal)
        button.setImage(image, forState: .Highlighted)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromBottomRight(view, child: button, bottom: 88, right: 16)
        MaterialLayout.size(view, child: button, width: 56, height: 56)
        button.addTarget(self, action: "handlePhotoLibraryButton", forControlEvents: .TouchUpInside)
        
    }

    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func captureViewDidEnd(image: UIImage?, videoURL: NSURL?) {
        if let url = videoURL {
            self.videoURL = url.path!
        }
    }
    
    // Player delegate functions
    func playerBufferingStateDidChange(player: Player) {
        
    }
    func playerPlaybackDidEnd(player: Player) {
        
    }
    func playerPlaybackStateDidChange(player: Player) {
        
    }
    func playerPlaybackWillStartFromBeginning(player: Player) {
        
    }
    func playerReady(player: Player) {
        
    }
}