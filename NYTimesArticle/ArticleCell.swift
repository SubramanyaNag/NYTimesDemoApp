//
//  ArticleCell.swift
//  NYTimesArticle
//
//  Created by subramanya on 22/11/17.
//  Copyright © 2017 Chanel. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

class ArticleCell: UITableViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var headlineLabel: UILabel!
    
    func configureCell(with headLine: String, thumbImageUrl: URL?) {
        self.headlineLabel.text = headLine
        if let thumbImageUrl = thumbImageUrl {
            let imageFullURL = URL.init(string: "http://www.nytimes.com/\(thumbImageUrl)")
            let imageDownloader = SDWebImageDownloader()
            if let imageFullURL = imageFullURL {
                if let image = SDImageCache.shared().imageFromCache(forKey: imageFullURL.absoluteString) {
                    self.thumbImageView.image = image
                } else {
                    imageDownloader.downloadImage(with: imageFullURL, options: .continueInBackground, progress: nil, completed: { (image, data, error, didSuceed) in
                        if error == nil {
                            if let image = image {
                                self.thumbImageView.image = image
                                SDImageCache.shared().store(image, forKey: imageFullURL.absoluteString, completion: nil)
                            }
                        } else {
                            print("Cannot download thumbnail image. Error: \(error!.localizedDescription)")
                        }
                    })
                }
            }
        } else {
            self.thumbImageView.image = #imageLiteral(resourceName: "Placeholder")
        }
    }
}
