//
//  SttViewable.swift
//  SttDictionary
//
//  Created by Piter Standret on 6/22/18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

protocol SttViewable: class { }
typealias SttViewControlable = SttViewableListener

protocol SttViewableListener: SttViewable {
    func sendMessage(title: String, message: String?)
    func sendError(error: SttBaseErrorType)
}

protocol SttViewInjector {
    func injectView(delegate: SttViewable)
    func prepare(parametr: Any?)
}
