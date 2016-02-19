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
    let imgView = UIImageView()
    var element: PFObject!

    override func viewDidLoad() {
        view.backgroundColor = MaterialColor.white
        
        imagePicker.delegate = self
    
        imgView.frame = view.bounds
        imgView.contentMode = .Center;
        if (imgView.bounds.size.width > imgView.image!.size.width && imgView.bounds.size.height > imgView.image!.size.height) {
            imgView.contentMode = UIViewContentMode.ScaleAspectFit;
        }
        view.addSubview(imgView)
        
        prepareCameraButton()
        preparePhotoLibraryButton()
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("done"))
        self.navigationItem.setRightBarButtonItem(barButton, animated: true)
    }
    func done() {
        let image = imgView.image?.resize(toWidth: 200) //Hacky way to ensure file size
        let imageData = UIImagePNGRepresentation(image!)
        let imageFile = PFFile(name:"image.png", data:imageData!)! as PFFile
        element["image"] = imageFile
        element.saveInBackground()
        self.navigationController?.popViewControllerAnimated(true)
    }
    func handlePhotoLibraryButton() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)

    }
    
    func handleCameraButton() {
        
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
        MaterialLayout.alignFromBottomRight(view, child: button, bottom: 88, right: 16)
        MaterialLayout.size(view, child: button, width: 56, height: 56)
        button.addTarget(self, action: "handlePhotoLibraryButton", forControlEvents: .TouchUpInside)
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgView.contentMode = .ScaleAspectFit
            imgView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)

    }
  
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}