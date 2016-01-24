//
//  TextEditorVC.swift
//  Blagh
//
//  Created by Wilson Zhao on 1/21/16.
//  Copyright © 2016 Innogen. All rights reserved.
//

import UIKit
import Parse
import CCInfiniteScrolling
import ZSSRichTextEditor
import RichEditorView

class TextEditorVC: UIViewController, RichEditorDelegate, RichEditorToolbarDelegate {
    
    @IBOutlet var htmlTextView: UITextView!
    
    @IBOutlet var editorView: RichEditorView!
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.options = RichEditorOptions.all()
        return toolbar
    }()
    
    var element: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editorView.delegate = self
        editorView.inputAccessoryView = toolbar
        
        
        toolbar.delegate = self
        toolbar.editor = editorView
        
        // We will create a custom action that clears all the input text when it is pressed
        let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
            toolbar?.editor?.setHTML("")
        }
        
        var options = toolbar.options
        options.append(item)
        toolbar.options = options
        
        // Done button
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("addPost"))
        self.navigationItem.setRightBarButtonItem(barButton, animated: true)
        // Set title
        
//        if let navigationController = self.navigationController {
//            
//            navigationController.title = Singleton.sharedInstance.currentPost!["title"] as? String
//        }
        
        //Load element data
        editorView.setHTML((element["text"] as? String)!)

    }
    override func viewWillDisappear(animated: Bool) {
        element["text"] = editorView.contentHTML
        element.pinInBackground()
    }
    
}

extension ViewController: RichEditorDelegate {
    
    func richEditor(editor: RichEditorView, heightDidChange height: Int) { }
    
    func richEditor(editor: RichEditorView, contentDidChange content: String) {
        if content.isEmpty {
       //     htmlTextView.text = "HTML Preview"
        } else {
       //     htmlTextView.text = content
        }
    }
    
    func richEditorTookFocus(editor: RichEditorView) { }
    
    func richEditorLostFocus(editor: RichEditorView) { }
    
    func richEditorDidLoad(editor: RichEditorView) { }
    
    func richEditor(editor: RichEditorView, shouldInteractWithURL url: NSURL) -> Bool { return true }
    
    func richEditor(editor: RichEditorView, handleCustomAction content: String) { }
    
}

extension ViewController: RichEditorToolbarDelegate {
    
    private func randomColor() -> UIColor {
        let colors = [
            UIColor.redColor(),
            UIColor.orangeColor(),
            UIColor.yellowColor(),
            UIColor.greenColor(),
            UIColor.blueColor(),
            UIColor.purpleColor()
        ]
        
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }
    
    func richEditorToolbarChangeTextColor(toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }
    
    func richEditorToolbarChangeBackgroundColor(toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }
    
    func richEditorToolbarInsertImage(toolbar: RichEditorToolbar) {
        toolbar.editor?.insertImage("http://gravatar.com/avatar/696cf5da599733261059de06c4d1fe22", alt: "Gravatar")
    }
    
    func richEditorToolbarInsertLink(toolbar: RichEditorToolbar) {
        // Can only add links to selected text, so make sure there is a range selection first
        if let hasSelection = toolbar.editor?.rangeSelectionExists() where hasSelection {
            toolbar.editor?.insertLink("http://github.com/cjwirth/RichEditorView", title: "Github Link")
        }
    }
}