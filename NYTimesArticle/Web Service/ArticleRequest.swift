//
//  ArticleRequest.swift
//  NYTimesArticle
//
//  Created by subramanya on 20/11/17.
//  Copyright © 2017 Chanel. All rights reserved.
//

import Foundation

public struct ArticleRequest : ModifiableBaseRequest {
    var baseRequest: BaseRequest = BaseRequest()
    let apiKey = "0b759c1406bb4cdabff977b2d5f2a8d4"//"0b759c1406bb4cdabff977b2d5f2a8d4"
    //let sortOrder = "newest"
    init() {
        let calendar = Calendar.autoupdatingCurrent
        let components = calendar.dateComponents([.year, .month], from: Date())
        let year = components.year!
        let month = components.month!
        self.endpoint = "svc/archive/v1/\(year)/\(month).json"///svc/search/v2/articlesearch.json"
        self.parameters = ["api-key": apiKey as AnyObject]
    }
}
