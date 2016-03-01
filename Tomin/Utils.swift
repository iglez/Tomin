//
//  Utils.swift
//  Tomin
//
//  Created by ivan gonzalez on 2/29/16.
//  Copyright © 2016 evolve. All rights reserved.
//

import Foundation
import UIKit

class Util {
    
    var imageCache = [String : UIImage]()
    
    func asyncLoadImage(image: UIImageView, tag: Int, url: String, defaultImage: String = "logo_usana.png") {
        // TODO: Placeholder
        image.tag = tag
        if let imageData = imageCache[url] {
            image.clipsToBounds = true
            image.image = imageData
            return
        }
        
        image.image = nil
        if let imageURL = NSURL(string: url) {
            let request = NSURLRequest(URL: imageURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if error == nil {
                    let imageUi = UIImage(data: data!)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.imageCache[url] = imageUi
                        if image.tag == tag {
                            image.clipsToBounds = true
                            //image.contentMode = .ScaleAspectFit
                            image.image = imageUi
                        }
                    })
                } else {
//                    print("error: \(error!.localizedDescription)")
                    image.image = UIImage(named: defaultImage)
                }
            })
        }
        
    }

}