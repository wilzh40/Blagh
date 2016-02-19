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

class VideoEditorVC : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CameraDelegate {
    let imagePicker = UIImagePickerController()
    let imgView = UIImageView()
    var element: PFObject!
    var firstImage: Bool = false
    var videoURL: String?
    
    override func viewDidLoad() {
        view.backgroundColor = MaterialColor.white
        
        imagePicker.delegate = self
        
        imgView.frame = view.bounds
        imgView.contentMode = .Center;
        if !firstImage {
            if (imgView.bounds.size.width > imgView.image!.size.width && imgView.bounds.size.height > imgView.image!.size.height) {
                imgView.contentMode = UIViewContentMode.ScaleAspectFit;
            }
        }
        view.addSubview(imgView)
        
        prepareCameraButton()
        preparePhotoLibraryButton()
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("done"))
        self.navigationItem.setRightBarButtonItem(barButton, animated: true)
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
        
        videoURL = (info[UIImagePickerControllerMediaURL] as! NSURL).absoluteString as String
        self.dismissViewControllerAnimated(true, completion:nil)
        //Here you can manipulate the adquired video
    }
    
    func startMediaBrowserFromViewController(viewController: UIViewController, usingDelegate delegate: protocol<UINavigationControllerDelegate, UIImagePickerControllerDelegate>) -> Bool {
        // 1
        if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) == false {
            return false
        }
        
        // 2
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = .SavedPhotosAlbum
        mediaUI.mediaTypes = [kUTTypeMovie as NSString as String]
        mediaUI.allowsEditing = true
        mediaUI.delegate = delegate
        
        // 3
        presentViewController(mediaUI, animated: true, completion: nil)
        return true
    }
    
    func handleCameraButton() {
        var captureVC = CaptureVC()
        captureVC.delegate = self
        captureVC.captureView.captureMode = .Photo
        
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
        if let img = image {
            imgView.contentMode = .ScaleAspectFit
            imgView.image = img
        }
    }
}