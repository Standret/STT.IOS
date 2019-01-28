//
//  SttNetworking.swift
//  ReportR
//
//  Created by Piter Standret on 1/2/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation
import Alamofire

class SttNetworking {
    static let sharedInstance = SttNetworking()
    public var sessionManager: Alamofire.SessionManager // most of your web service clients will call through sessionManager
    public var backgroundSessionManager: Alamofire.SessionManager // your web services you intend to keep running when the system backgrounds your app will use this
    private init() {
        self.sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        self.backgroundSessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: "com.lava.app.backgroundtransfer"))
    }
}
