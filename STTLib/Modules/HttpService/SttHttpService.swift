//
//  HttpService.swift
//  SttDictionary
//
//  Created by Standret on 5/13/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

class SttHttpService: SttHttpServiceType {
    
    private let url: String!
    private let connectivity = SttConectivity()
    private let tokenGetter: (() -> Observable<String>)?
    
    private let timeout: Double
    
    init(url: String, timeout: Double, tokenGetter: (() -> Observable<String>)? = nil) {
        self.url = url
        self.timeout = timeout
        self.tokenGetter = tokenGetter
    }
    
    func  get(controller: ApiControllerType, data: [String: Any], headers: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)> {
        
        return modifyHeaders(insertToken: insertToken, headers: headers)
            .flatMap({ headers -> Observable<(HTTPURLResponse, Data)> in
                return requestData(.get,
                                   "\(self.url!)\(controller.route)",
                                   parameters: data,
                                   encoding: URLEncoding.default,
                                   headers: headers)
            })
            .timeout(timeout, scheduler: MainScheduler.instance)
    }
    
    /// if key parametr is empty string and parametr is simple type, its will be insert in raw body
    func post(controller: ApiControllerType, data: [String: Any], headers: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)> {
        
        return modifyHeaders(insertToken: insertToken, headers: headers)
            .flatMap({ headers -> Observable<(HTTPURLResponse, Data)> in
                return requestData(.post,
                                   "\(self.url!)\(controller.route)",
                                   parameters: data,
                                   encoding: URLEncoding.httpBody,
                                   headers: headers)
                })
            .timeout(timeout, scheduler: MainScheduler.instance)
    }
    
    func post(controller: ApiControllerType, object: Encodable?, headers: [String:String], insertToken: Bool, isFormUrlEncoding: Bool) -> Observable<(HTTPURLResponse, Data)> {
        
        return modifyHeaders(insertToken: insertToken,
                             headers: self.modifyHeaders(isFormUrlEncoding: isFormUrlEncoding, to: headers))
            .flatMap({ headers -> Observable<(HTTPURLResponse, Data)> in
                
                var request = URLRequest(url: URL(string: "\(self.url!)\(controller.route)")!)
                request.httpMethod = HTTPMethod.post.rawValue
    
                if isFormUrlEncoding {
                    request.httpBody = object?.getData()
                }
                else {
                    request.httpBody = (object?.getJsonString().data(using: .utf8, allowLossyConversion: false))
                }
    
                for lhitem in headers {
                    request.setValue(lhitem.value, forHTTPHeaderField: lhitem.key)
                }
                
                return requestData(request)
            })
            .timeout(timeout, scheduler: MainScheduler.instance)
    }
    
    func upload(controller: ApiControllerType, data: Data, parameter: [String:String], progresHandler: ((Float) -> Void)?) -> Observable<(HTTPURLResponse, Data)> {
        notImplementException()
//        let url = "\(self.url!)\(controller.route)"
//
//        return Observable<(HTTPURLResponse, Data)>.create( { observer in
//            SttLog.trace(message: url, key: Constants.httpKeyLog)
//
//            if !self.connectivity.isConnected {
//                sleep(Constants.timeWaitNextRequest)
//                observer.onError(SttBaseError.connectionError(SttConnectionError.noInternetConnection))
//                return Disposables.create()
//            }
//
//            SttNetworking.sharedInstance.backgroundSessionManager.upload(multipartFormData: { multipartFormData in
//                multipartFormData.append(data, withName: "file", fileName: "file.png", mimeType: "image/png")
//            }, to: url, method: .put, headers: parameter,
//               encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.uploadProgress(closure: { (progress) in
//                        if let handler = progresHandler {
//                            handler(Float(progress.fractionCompleted))
//                        }
//                    })
//
//                    upload.responseData(completionHandler: { (fullData) in
//                        if upload.response != nil && fullData.data != nil {
//                            observer.onNext((upload.response!, fullData.data!))
//                            observer.onCompleted()
//                        }
//                        else {
//                            observer.onError(SttBaseError.connectionError(SttConnectionError.responseIsNil))
//                        }
//                    })
//                case .failure(let encodingError):
//                    observer.onError(SttBaseError.unkown("\(encodingError)"))
//                }
//        })
//            return Disposables.create();
//        })
//            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//            .observeOn(MainScheduler.instance)
//            .timeout(180, scheduler: MainScheduler.instance)
    }
    
    private func modifyHeaders(isFormUrlEncoding: Bool, to headers: [String: String]) -> [String: String] {
        
        var _headers = headers
        
        if isFormUrlEncoding {
            _headers["Content-Type"] = "application/x-www-form-urlencoded"
        }
        else {
            _headers["Content-Type"] = "application/json"
        }
        
        return _headers
    }
        
    private func modifyHeaders(insertToken: Bool, headers: [String: String]) -> Observable<[String: String]> {
            
        if insertToken {
            return self.tokenGetter!()
                .map({ token in
                    var _headers = headers
                    _headers["Authorization"] = token
                    return _headers
                })
        }
        
        return Observable.just(headers)
    }
}
