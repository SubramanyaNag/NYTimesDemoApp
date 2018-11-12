//
//  DataStore.swift
//  NYTimesArticle
//
//  Created by subramanya on 17/11/17.
//  Copyright © 2017 Chanel. All rights reserved.
//

import Foundation
import GRDB

class DataStore {
    public func setupDatabase() {
        
        var migrator = DatabaseMigrator()
        //try migrator.migrate(dbQueue)
        
        migrator.registerMigration("CreateArticleTable") { db in
            // Compare names in a localized case insensitive fashion
            // See https://github.com/groue/GRDB.swift/#unicode
            try db.create(table: "article") { t in
                t.column("publishedDate", .text).notNull().collate(.localizedCaseInsensitiveCompare)
                t.column("headline", .text).notNull()
                t.column("detailSnippet", .text).notNull()
                t.column("url", .text).primaryKey().unique()
                t.column("source", .text)
                t.column("createdBy", .text)
                t.column("xLargeImageUrl", .text)
                t.column("thumbnailImageUrl", .text)
            }
        }
        
        try! migrator.migrate(dbQueue)
    }
}
