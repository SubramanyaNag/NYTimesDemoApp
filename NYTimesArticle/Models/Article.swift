//
//  Article.swift
//  NYTimesArticle
//
//  Created by subramanya on 17/11/17.
//  Copyright © 2017 Chanel. All rights reserved.
//

import Foundation
import GRDB
import SwiftyJSON


class Article: RowConvertible, MutablePersistable {

    var publishedDate: Date?
    var headline: String?
    var xLargeImageUrl: URL?
    var thumbnailImageUrl: URL?
    var detailSnippet: String?
    var url: URL?
    var source: String?
    var createdBy: String?
    
    init?(from json:JSON) {
        let pubDateStringValue = json["pub_date"].string
        let urlValue = json["web_url"].string
        let publishedDateValue = getDate(from: pubDateStringValue!)
        let headLine = json["headline"]["main"].string
        let imageURLJson = json["multimedia"].array
        var xLargeImgStr: String?
        var thumbnailImgStr: String?
        if let imageURLJson = imageURLJson {
            for imageJson in imageURLJson {
                let subtype = imageJson["subtype"].string
                if subtype == "xlarge" {
                    xLargeImgStr = imageJson["url"].string
                } else if subtype == "thumbnail" {
                    thumbnailImgStr = imageJson["url"].string
                }
            }
        }
        let detailSnippetValue = json["snippet"].string
        let sourceValue = json["source"].string
        let createdByValue = json["byline"]["original"].string
        
        publishedDate = publishedDateValue
        headline = headLine
        detailSnippet = detailSnippetValue
        url = URL.init(string: urlValue!)
        source = sourceValue
        createdBy = createdByValue
        if let xLIStr = xLargeImgStr {
            xLargeImageUrl = URL.init(string: xLIStr)
        }
        if let xthumbStr = thumbnailImgStr {
            thumbnailImageUrl = URL.init(string: xthumbStr)
        }
    }
    
    public static var databaseTableName: String {
        return "article"
    }
    
    required public init(row: Row) {
        var pubDateString: String?
        pubDateString = row["publishedDate"]
        if let datePub = getDate(from: pubDateString!) {
            publishedDate = datePub
        }
        headline = row["headline"]
        detailSnippet = row["detailSnippet"]
        url = row["url"]
        source = row["source"]
        createdBy = row["createdBy"]
        xLargeImageUrl = row["xLargeImageUrl"]
        thumbnailImageUrl = row["thumbnailImageUrl"]
    }
    
    func encode(to container: inout PersistenceContainer) {
        if let dateString = getString(from: publishedDate!) {
            container["publishedDate"] = dateString
        }
        container["headline"] = headline
        container["detailSnippet"] = detailSnippet
        container["url"] = url?.absoluteString
        container["xLargeImageUrl"] = xLargeImageUrl?.absoluteString
        container["thumbnailImageUrl"] = thumbnailImageUrl?.absoluteString
        container["source"] = source
        container["createdBy"] = createdBy
        
    }
    
    public func getDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = formatter.date(from: dateString)
        return date
    }
    
    public func getString(from date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
}
