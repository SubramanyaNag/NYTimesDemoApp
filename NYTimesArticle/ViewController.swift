//
//  ViewController.swift
//  NYTimesArticle
//
//  Created by subramanya on 17/11/17.
//  Copyright © 2017 Chanel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    var articles: [Article] = []
    
    var articleToPass: Article?

    @IBOutlet weak var articleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getArticlesFromWeb { (articles, error) in
            if error != nil {
                print("\n\n Could not get articles from web. Error: \(error!.localizedDescription)")
                let dbBridge = DBBridge()
                dbBridge.getArticle(completion: { (articles, errorMessage) in
                    if errorMessage != nil {
                        print(errorMessage!)
                    } else {
                        if let articles = articles {
                            self.articles = articles
                            self.articleTableView.reloadData()
                        }
                    }
                })
            } else {
                if let articles = articles {
                    self.articles = articles
                    self.articleTableView.reloadData()
                }
            }
        }
        articleTableView.delegate = self
        articleTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getArticlesFromWeb(completion: @escaping (([Article]?, Error?)->Void)) {
        let webserviceManager = WebServiceManager()
        let articleRequest = ArticleRequest()
        var articles: [Article] = []
        var didSucceed = false
        webserviceManager.getResponse(for: articleRequest) { (request, response, data, error) in
            let error = WebResponseError.check(response: response, request: request, error: error)
            if error != nil {
                completion(nil, error)
            } else {
                guard let data = data else {
                    completion(nil, WebResponseError.invalidResponse)
                    return
                }
                let jsonFull = JSON(data: data)
                let jsonResponse = jsonFull["response"]
                let docsJson = jsonResponse["docs"].arrayValue
                for aDoc in docsJson {
                    if let article = Article.init(from: aDoc) {
                        articles.append(article)
                        didSucceed = true
                    } else {
                        print("\n\n Could not get article from json")
                    }
                }
                if didSucceed {
                    completion(articles, nil)
                    let dbBridge = DBBridge()
                    dbBridge.addArticles(articles: articles, completion: { (error) in
                        if error != nil {
                            print("\n\n Could not add articles to DB. Error: \(error!.localizedDescription)")
                        } else {
                            print("\n\n Succesfully updated the articles in DB")
                        }
                    })
                } else {
                    completion(nil, WebResponseError.invalidResponse)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let detailController = segue.destination as! ArticleDetailViewController
            detailController.article = articleToPass
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        let headline = articles[indexPath.row].headline
        let thumbIMGURL = articles[indexPath.row].thumbnailImageUrl
        cell.configureCell(with: headline!, thumbImageUrl: thumbIMGURL)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.articleToPass = articles[indexPath.row]
        self.performSegue(withIdentifier: "showDetails", sender: self)
    }
}
