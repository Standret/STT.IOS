//
//  SttHttpServiceType.swift
//  ReportR
//
//  Created by Piter Standret on 1/2/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation
import RxSwift

protocol SttHttpServiceType {
    
    func get(controller: ApiConroller, data: [String: Any], headers: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)>
    func post(controller: ApiConroller, data: [String: Any], headers: [String:String], insertToken: Bool) -> Observable<(HTTPURLResponse, Data)>
    func post(controller: ApiConroller, object: Encodable?, headers: [String:String], insertToken: Bool, isFormUrlEncoding: Bool) -> Observable<(HTTPURLResponse, Data)>
    func upload(controller: ApiConroller, data: Data, parameter: [String:String], progresHandler: ((Float) -> Void)?) -> Observable<(HTTPURLResponse, Data)>
}
