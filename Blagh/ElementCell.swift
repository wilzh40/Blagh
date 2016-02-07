//
//  elementCell.swift
//  Blagh
//
//  Created by Wilson Zhao on 1/23/16.
//  Copyright © 2016 Innogen. All rights reserved.
//

import Foundation
import UIKit
import MDHTMLLabel
class ElementCell : UITableViewCell {
   // @IBOutlet var webView: UIWebView? = UIWebView()

    @IBOutlet weak var webView: UIWebView!
    var BGimage : UIImageView?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        BGimage = UIImageView(frame: self.frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   
    func loadItem(data: String) {
        
    }
}

class TextCell: ElementCell, UIWebViewDelegate, MDHTMLLabelDelegate {
    //@IBOutlet var htmlLabel: MDHTMLLabel!

    

    override func loadItem(data: String) {
        //textLabel?.text = data
        /*webView.frame = self.bounds
        webView.delegate = self
        webView.scalesPageToFit = false
        webView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        webView.dataDetectorTypes = .None
        webView.backgroundColor = UIColor.clearColor()
        webView.scrollView.scrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.clipsToBounds = false
        webView.loadHTMLString(data, baseURL: nil)
        webView.userInteractionEnabled = false
        webView.opaque = false
        
        self.alpha = 0.3;
        self.addSubview(webView)*/
        let frame = CGRectMake(10, 0, self.bounds.width - 20, self.bounds.height)
        let htmlLabel = MDHTMLLabel(frame: frame)
      
        
        
       /* var bounds = htmlLabel.bounds
        bounds.size.height = CGFloat.max
        let minimumRect = htmlLabel.textRectForBounds(bounds, limitedToNumberOfLines: 0)
        let heightDelta = minimumRect.size.height - htmlLabel.frame.size.height
        var frame = htmlLabel.frame
        frame.size.height += heightDelta
        htmlLabel.frame = frame*/
        htmlLabel.delegate = self;
        htmlLabel.htmlText = data;
        htmlLabel.numberOfLines = 0
        htmlLabel.sizeToFit()
        contentView.addSubview(htmlLabel)
    
        NSLayoutConstraint(item: htmlLabel, attribute: .Top, relatedBy: .Equal, toItem: htmlLabel.superview, attribute: .Top, multiplier: 1.0, constant: 15.0).active = true
        NSLayoutConstraint(item: htmlLabel, attribute: .Bottom, relatedBy: .Equal, toItem: htmlLabel.superview, attribute: .Bottom, multiplier: 1.0, constant: 15.0).active = true
        NSLayoutConstraint(item: htmlLabel, attribute: .Leading, relatedBy: .Equal, toItem: htmlLabel.superview, attribute: .Leading, multiplier: 1.0, constant: 15.0).active = true
        NSLayoutConstraint(item: htmlLabel, attribute: .Trailing, relatedBy: .Equal, toItem: htmlLabel.superview, attribute: .Trailing, multiplier: 1.0, constant: 15.0).active = true
       // self.layoutIfNeeded()
       // self.layoutSubviews()
      //  self.sizeToFit()
    }
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        webView.alpha = 0.1
        return true
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        UIView.animateWithDuration(0.3, animations:{
            self.alpha = 1;
            webView.alpha = 1
        })

    }
}

class ImageCell: ElementCell {
    override func loadItem(data: String) {
        ImageLoader.sharedLoader.imageForUrl(data, completionHandler:{(image: UIImage?, url: String) in
            self.BGimage?.image = image
            self.BGimage?.alpha = 1
            UIView.animateWithDuration(0.3, animations:{
                
            })
        })
    }
}

class VideoCell: ElementCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}