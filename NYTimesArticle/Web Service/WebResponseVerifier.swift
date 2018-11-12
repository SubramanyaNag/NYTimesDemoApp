//
//  WebResponseVerifier.swift
//  NYTimesArticle
//
//  Created by subramanya on 20/11/17.
//  Copyright © 2017 Chanel. All rights reserved.
//

import Foundation

public enum WebResponseError: Error {
    case unknownError
    case invalidRequest
    case notFound
    case invalidResponse
    case noInternet
    
    static func check(response: HTTPURLResponse?, request: URLRequest?, error: NSError?) -> WebResponseError? {
        if let error = error {
            return mapError(error)
        }
        if let response = response {
            if response.statusCode != 200 {
                self.logError("Invalid response status code", request: request, response: response)
                let dataStoreError = WebResponseError.checkErrorCode(response.statusCode)
                return dataStoreError
            }
        } else {
            return .invalidResponse
        }
        return nil
    }
    
    static func checkErrorCode(_ errorCode: Int) -> WebResponseError {
        switch errorCode {
        case 403:
            return .invalidRequest
        case 404:
            return .notFound
        case NSURLErrorNotConnectedToInternet:
            return .noInternet
        default:
            return .unknownError
        }
    }
    
    static fileprivate func mapError(_ error: NSError) -> WebResponseError {
        return self.checkErrorCode(error.code)
    }
    
    static func description(for error: WebResponseError) -> String {
        switch error {
        case .invalidRequest:
            return "Invalid request was made"
        case .notFound:
            return "Not Found"
        case .unknownError:
            return "Encountered an unknown error"
        case .invalidResponse:
            return "Server returned an invalid response"
        case .noInternet:
            return "No Internet Connection. Please connect your device to internet to proceed"
        }
    }
    
    static func logError(_ errorMessage: String, request: URLRequest?, response: HTTPURLResponse?) {
        print(errorMessage)
    }
}
