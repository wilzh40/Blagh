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

class ImageEditorVC : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let imagePicker = UIImagePickerController()
    let imageView = UIImageView()
    override func viewDidLoad() {
        view.backgroundColor = MaterialColor.white
        
        imagePicker.delegate = self
    
        imageView.frame = view.bounds
        
        prepareCameraButton()
        preparePhotoLibraryButton()
        
    }
    
    func handlePhotoLibraryButton(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func handleCameraButton(sender: UIButton) {
        
    }
    
    func prepareCameraButton() {
        let image: UIImage? = UIImage(named: "ic_photo_camera_white_36pt")
        let button: FabButton = FabButton()
        button.backgroundColor = MaterialColor.blue.accent3
        button.setImage(image, forState: .Normal)
        button.setImage(image, forState: .Highlighted)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromBottomRight(view, child: button, bottom: 16, right: 16)
        MaterialLayout.size(view, child: button, width: 56, height: 56)
        button.addTarget(self, action: "handleCameraButton", forControlEvents: .TouchUpInside)

    }
    
    
    func preparePhotoLibraryButton() {
        let image: UIImage? = UIImage(named: "ic_photo_camera_white_36pt")
        let button: FabButton = FabButton()
        button.backgroundColor = MaterialColor.blue.accent3
        button.setImage(image, forState: .Normal)
        button.setImage(image, forState: .Highlighted)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromBottomRight(view, child: button, bottom: 88, right: 88)
        MaterialLayout.size(view, child: button, width: 56, height: 56)
        button.addTarget(self, action: "handlePhotoLibraryButton", forControlEvents: .TouchUpInside)
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)

    }
  
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}