//
//  BaseRequest.swift
//  NYTimesArticle
//
//  Created by subramanya on 20/11/17.
//  Copyright © 2017 Chanel. All rights reserved.
//

import Foundation
import Alamofire

struct BaseRequest {
    
    var baseURL : URL
    var endpoint: String?
    var method: Alamofire.HTTPMethod
    var parameterEncoding : ParameterEncoding
    
    var parameters: [String: AnyObject]?
    
    init() {
        baseURL = URL(string: "https://api.nytimes.com")!
        self.method = .get
        self.parameterEncoding = URLEncoding.default
    }
}

protocol ModifiableBaseRequest {
    var baseRequest : BaseRequest { set get }
}

extension ModifiableBaseRequest {
    var baseURL : URL {
        get { return baseRequest.baseURL }
        set { baseRequest.baseURL = newValue }
    }
    
    var endpoint : String? {
        get { return baseRequest.endpoint }
        set { baseRequest.endpoint = newValue }
    }
    
    var method : Alamofire.HTTPMethod {
        get { return baseRequest.method }
        set { baseRequest.method = newValue }
    }
    
    var parameterEncoding : ParameterEncoding {
        get { return baseRequest.parameterEncoding }
        set { baseRequest.parameterEncoding = newValue }
    }
    
    var parameters: [String: AnyObject]? {
        get { return baseRequest.parameters }
        set { baseRequest.parameters = newValue }
    }
}
