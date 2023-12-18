//
//  ApiManager+Multipart.swift
//  ShowToStream
//
//  Created by Applify on 15/12/20.
//  Copyright © 2020 Applify. All rights reserved.
//

import Alamofire
import Foundation

extension ApiManager {
    class func multipartRequest(_ url: String,
                                params: [String: Any] = [:],
                                dataToUpload: [Data],
                                keyToUploadData: [String],
                                fileNames: [String],
                                headers: HTTPHeaders? = nil,
                                completion: @escaping (_ result: [String: Any]?) -> Void) {
        if NetworkReachabilityManager()?.isReachable == false {
            completion(getNoInternetError())
            return
        }
        
        if var urlRequest = try? URLRequest(url: APIUrl.baseUrl + url,
                                            method: .post,
                                            headers: headers) {
            print(params)
            print(urlRequest)
            
            urlRequest.httpBody = params.percentEscaped().data(using: .utf8)
            let request = AF.upload(multipartFormData: { multipartFormData in
                if dataToUpload.count > 0 {
                    for index in 0 ..< dataToUpload.count  {
                        let data = dataToUpload[index]
                        let key = keyToUploadData[index]
                        
                        let fileName = fileNames[index]
                        multipartFormData.append(data,
                                                 withName: key,
                                                 fileName: fileName,
                                                 mimeType: "")
                    }
                }
            }, with: urlRequest)
            
            request.uploadProgress { progress in
            }
            request.responseJSON { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let value):
                        guard let value = value as? [String: Any] else {
                            completion(self.getNoInternetError())
                            return
                        }
                        print ("success")
                        print("\(value)")
                        completion(value)
                    case .failure:
                        completion(self.getUnknownError(response.error?.localizedDescription))
                    }
                }
            }
            request.resume()
        }
    }
    
    class func multipartRequest(_ url: String,
                                params: [String: Any] = [:],
                                localFileUrl: URL,
                                keyToUploadData: String,
                                fileNames: String,
                                headers: HTTPHeaders? = nil,
                                completion: @escaping (_ result: [String: Any]?) -> Void) {
        if NetworkReachabilityManager()?.isReachable == false {
            completion(getNoInternetError())
            return
        }
        
        if var urlRequest = try? URLRequest(url: APIUrl.baseUrl + url,
                                            method: .post,
                                            headers: headers) {
            
            urlRequest.httpBody = params.percentEscaped().data(using: .utf8)
            
            print(params)
            print(urlRequest)
            let request = AF.upload(localFileUrl, with: urlRequest)
            request.uploadProgress { progress in
            }
            request.responseJSON { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let value):
                        guard let value = value as? [String: Any] else {
                            completion(self.getNoInternetError())
                            return
                        }
                        print ("success")
                        print("\(value)")
                        completion(value)
                    case .failure:
                        completion(self.getUnknownError(response.error?.localizedDescription))
                    }
                }
            }
            request.resume()
        }
    }
}
