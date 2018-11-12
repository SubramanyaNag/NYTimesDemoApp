//
//  DBBridge.swift
//  NYTimesArticle
//
//  Created by subramanya on 17/11/17.
//  Copyright © 2017 Chanel. All rights reserved.
//

import Foundation
import GRDB

class DBBridge {

    public func getArticle(completion: ([Article]?, String?) -> Void)  {
        var articlesToReturn: [Article] = []

        do {
            try dbQueue.inDatabase{ db in
                articlesToReturn = try Article.fetchAll(db)
                completion(articlesToReturn, nil)
            }
        } catch let error {
            let errorMessage = "Could not fetch articles. Error: \(error)"
            completion(nil, errorMessage)
        }
    }
    
    public func addArticles(articles: [Article], completion: (Error?) -> Void) {
        do {
            try dbQueue.inTransaction{ db in
                //delete previous contents of the table.
                do {
                    try Article.deleteAll(db)
                } catch let tableDeleteError {
                    print("\n\n Could not delete contents of Article table. Error: \(tableDeleteError.localizedDescription)")
                }
                for article in articles {
                    var articleToInsert = article
                    //add new contents to table.
                    try articleToInsert.insert(db)
                }
                return .commit
            }
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
}



