//
//  ArticleDetailViewController.swift
//  NYTimesArticle
//
//  Created by subramanya on 22/11/17.
//  Copyright © 2017 Chanel. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

class ArticleDetailViewController: UIViewController {
    
    @IBOutlet weak var articleImageView: UIImageView!
    
    @IBOutlet weak var publishedDateLabel: UILabel!
    
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var snippetTextView: UITextView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBAction func goToWebsiteTapped(_ sender: UIButton) {
        let urlToOpen = article?.url
        if let urltoOPEN = urlToOpen {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(urltoOPEN, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(urltoOPEN)
            }
        }
    }
    
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Article details"
        
        if let article = article {
            let imageManager = SDWebImageManager.shared()
            let imageURL = article.xLargeImageUrl
            if let imageURL = imageURL {
                let imageFullURL = URL.init(string: "http://www.nytimes.com/\(imageURL.absoluteString)")
                if let image = SDImageCache.shared().imageFromCache(forKey: imageFullURL!.absoluteString) {
                    self.articleImageView.image = image
                } else {
                    imageManager.imageDownloader?.downloadImage(with: imageFullURL!, options: .continueInBackground, progress: nil, completed: { (image, data, error, didSuceed) in
                        if error == nil {
                            self.articleImageView.image = image
                            SDImageCache.shared().store(image, forKey: imageFullURL!.absoluteString, completion: nil)
                        } else {
                            print("failed to download the article wide image. Error: \(error!.localizedDescription)")
                        }
                    })
                }
            } else {
                self.articleImageView.image = #imageLiteral(resourceName: "Placeholder")
            }
            
            self.headlineLabel.text = article.headline!
            self.snippetTextView.text = article.detailSnippet!
            self.createdByLabel.text = article.createdBy!
            let date = article.publishedDate!
            let calendar = Calendar.autoupdatingCurrent
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            let month = components.month
            let year = components.year
            let day = components.day
            self.publishedDateLabel.text = "\(day!)-\(month!)-\(year!)"
            self.sourceLabel.text = article.source!
        }
    }
}
