//
//  ApiManager.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import Alamofire
import UIKit

class ApiManager: BaseApiManager {
    class func makeApiCall(_ url: String,
                           params: [String: Any] = [:],
                           headers: [String: String]? = nil,
                           method: HTTPMethod = .post,
                           completion: @escaping ( _ result: [String: Any]?,  _ jsonResponse: Data?) -> Void) {
        if method == .get {
            let dataRequest = self.getDataRequest(url,
                                                  params: params,
                                                  method: .get,
                                                  encoding: URLEncoding.default,
                                                  headers: headers)
            self.executeDataRequest(dataRequest, with: completion)
        } else {
            let dataRequest = self.getDataRequest(url,
                                                  params: params,
                                                  method: method,
                                                  headers: headers)
            self.executeDataRequest(dataRequest, with: completion)
        }
    }
        
    private class func executeDataRequest(_ dataRequest: DataRequest,
                                          with completion: @escaping ( _ result: [String: Any]?,  _ jsonResponse: Data?) -> Void) {
        if NetworkReachabilityManager()?.isReachable == false {
            completion(getNoInternetError(), nil)
            return
        }
        dataRequest.responseJSON { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let value):
                    guard let value = value as? [String: Any] else {
                       // completion(self.getNoInternetError(), response.data)
                        completion(self.getUnknownError(response.error?.localizedDescription), response.data)
                        return
                    }
                    print ("success")
                    print("\(value)")
                    completion(value, response.data)
                case .failure:
                    completion(self.getUnknownError(response.error?.localizedDescription), response.data)
                }
            }
        }
    }
}

class BaseApiManager: NSObject {
    
    class func getDataRequest(_ baseUrl: String,
                              _ url: String,
                              params: [String: Any]? = nil,
                              method: HTTPMethod = .post,
                              encoding: ParameterEncoding = URLEncoding.default,
                              headers: [String: String]? = nil) -> DataRequest {

        var httpHeaders: HTTPHeaders = []
        if let headers = headers {
            for (key, value) in headers {
                httpHeaders[key] = value
            }
        }
        let dataRequest = AF.request(baseUrl + url,
                                     method: method,
                                     parameters: params,
                                     encoding: encoding,
                                     headers: httpHeaders)
        
        return dataRequest
    }
    
    
    class func getDataRequest(_ url: String,
                              params: [String: Any] = [:],
                              method: HTTPMethod = .post,
                              encoding: ParameterEncoding = JSONEncoding.default,
                              headers: [String: String]? = nil) -> DataRequest {

        var httpHeaders: HTTPHeaders = []
        if let headers = headers {
            for (key, value) in headers {
                httpHeaders[key] = value
            }
        }
        let dataRequest = AF.request(url,
                                     method: method,
                                     parameters: params,
                                     encoding: encoding,
                                     headers: httpHeaders)
        print(url)
        print(headers)
        print(params)
        return dataRequest
    }
}

extension BaseApiManager {
    
    static func getNoInternetError() -> [String: Any] {
        return [APIConstants.message: GenericErrorMessages.noInternet,
                APIConstants.code: 503]
    }
    
    static func getUnknownError(_ message: String? = nil) -> [String: Any] {
        return [APIConstants.message: message ?? GenericErrorMessages.internalServerError,
                APIConstants.code: 503]
    }
}


