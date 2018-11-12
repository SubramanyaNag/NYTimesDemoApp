//
//  WebServiceManager.swift
//  NYTimesArticle
//
//  Created by subramanya on 20/11/17.
//  Copyright © 2017 Chanel. All rights reserved.
//

import Foundation
import Alamofire


public class WebServiceManager {
    
    fileprivate let alamofireManager :Alamofire.SessionManager
    
    init() {
        alamofireManager = Alamofire.SessionManager.default
        let userDefaults = UserDefaults.standard
        if let timeoutValue = userDefaults.string(forKey: "timeout"), let timeout = Double(timeoutValue) {
            alamofireManager.session.configuration.timeoutIntervalForRequest = timeout
            alamofireManager.session.configuration.timeoutIntervalForResource = timeout
        } else {
            let appDefaults = ["timeout": "30"]
            UserDefaults.standard.register(defaults: appDefaults)
            userDefaults.synchronize()
            alamofireManager.session.configuration.timeoutIntervalForRequest = 30
            alamofireManager.session.configuration.timeoutIntervalForResource = 30
        }
    }
    
    fileprivate func createAlamofireDataRequest(_ request: ModifiableBaseRequest) -> Alamofire.DataRequest {
        return self.alamofireManager.request(request.baseURL.appendingPathComponent(request.endpoint!), parameters: request.parameters, encoding: request.parameterEncoding)
    }
    
    func getResponse(for request : ModifiableBaseRequest, completion: @escaping (URLRequest?, HTTPURLResponse?, Data?, NSError?) -> Void) {
        let alamofireRequest = createAlamofireDataRequest(request)
        
        alamofireRequest.responseData(completionHandler: { (dataResponse) in
            switch dataResponse.result {
            case .success:
                completion(dataResponse.request, dataResponse.response, dataResponse.data, nil)
            case .failure(let error):
                completion(dataResponse.request, dataResponse.response, dataResponse.data, error as NSError?)
            }
        })
    }
}

