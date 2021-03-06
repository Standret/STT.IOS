//
//  SttResultConverter.swift
//  SttDictionary
//
//  Created by Standret on 22.06.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType where E == (HTTPURLResponse, Data) {
    
    func getCookie(action: @escaping (String?) -> Void) -> Observable<(HTTPURLResponse, Data)> {
        return self.map({ (result) -> (HTTPURLResponse, Data) in
            let header = result.0.allHeaderFields as NSDictionary
            let tockenval = header.value(forKey: "authenticate") as? String
            action(tockenval)
            
            return result
            })
    }
    
    func getResult<TResult: Decodable>() -> Observable<TResult> {
        return self.getResult(ofType: TResult.self)
    }
    
    func getResult<TResult: Decodable>(ofType _: TResult.Type) -> Observable<TResult> {
        return Observable<TResult>.create({ (observer) -> Disposable in
            self.subscribe(onNext: { (urlResponse, data) in
                switch urlResponse.statusCode {
                case 200 ... 299:
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .customISO8601
                        let jsonObject = try decoder.decode(TResult.self, from: data)
                        observer.onNext(jsonObject)
                    }
                    catch {
                        print(error)
                        observer.onError(SttBaseError.jsonConvert("\(error)"))
                    }
                case 400:
                    let object = (try? JSONDecoder().decode(ServerError.self, from: data))
                            ?? ServerError(code: 400, description: (String(data: data, encoding: String.Encoding.utf8) ?? ""))
                    observer.onError(SttBaseError.apiError(SttApiError.badRequest(object)))
                case 500:
                    observer.onError(SttBaseError.apiError(SttApiError.internalServerError(String(data: data, encoding: String.Encoding.utf8) ?? "nil")))
                default:
                    observer.onError(SttBaseError.apiError(SttApiError.otherApiError(urlResponse.statusCode)))
                }
            }, onError: { (error) in
                if let er = error as? SttBaseError {
                    observer.onError(er)
                }
                else {
                    observer.onError(SttBaseError.connectionError(SttConnectionError.timeout))
                    //observer.onError(SttBaseError.unkown("\((error as NSError).localizedDescription)"))
                }
            }, onCompleted: observer.onCompleted)
        })
    }
    
    func getResult() -> Observable<Void> {
        return Observable<Void>.create({ (observer) -> Disposable in
            self.subscribe(onNext: { (urlResponse, data) in
                switch urlResponse.statusCode {
                case 200 ... 299:
                    observer.onNext(())
                    observer.onCompleted()
                case 400:
                    let object = (try? JSONDecoder().decode(ServerError.self, from: data))
                        ?? ServerError(code: 400, description: (String(data: data, encoding: String.Encoding.utf8) ?? ""))
                    observer.onError(SttBaseError.apiError(SttApiError.badRequest(object)))
                case 500:
                    observer.onError(SttBaseError.apiError(SttApiError.internalServerError(String(data: data, encoding: String.Encoding.utf8) ?? "nil")))
                default:
                    observer.onError(SttBaseError.apiError(SttApiError.otherApiError(urlResponse.statusCode)))
                }
            }, onError: { (error) in
                if let er = error as? SttBaseError {
                    observer.onError(er)
                }
                else {
                    observer.onError(SttBaseError.unkown("\(error)"))
                }
            }, onCompleted: nil, onDisposed: nil)
        })
    }
}
