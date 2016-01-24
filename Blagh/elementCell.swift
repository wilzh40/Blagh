//
//  elementCell.swift
//  Blagh
//
//  Created by Wilson Zhao on 1/23/16.
//  Copyright © 2016 Innogen. All rights reserved.
//

import Foundation
import UIKit
class ElementCell : UITableViewCell {
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

class TextCell: ElementCell {
    override func loadItem(data: String) {
        textLabel?.text = data
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