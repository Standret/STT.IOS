//
//  SttViewControllerExtensionControlable.swift
//  SttDictionary.IOS.NextGen
//
//  Created by Piter Standret on 1/12/19.
//  Copyright © 2019 Piter Standret. All rights reserved.
//

import Foundation
import UIKit

extension SttViewController: SttViewControlable {
    
    func sendError(error: SttBaseErrorType) {
        let serror = error.getMessage()
        if useErrorLabel {
            viewError.showMessage(text: serror.0, detailMessage: serror.1)
        }
        else {
            self.createAlerDialog(title: serror.0, message: serror.1)
        }
        
        if useVibrationOnError {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
    func sendError(title: String, description: String) {
        if useErrorLabel {
            viewError.showMessage(text: title, detailMessage: description)
        }
        else {
            self.createAlerDialog(title: title, message: description)
        }
        if useVibrationOnError {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
    func sendMessage(title: String, message: String?) {
        if useErrorLabel {
            viewError.showMessage(text: title, detailMessage: message, isError: false)
        }
        else {
            self.createAlerDialog(title: title, message: message ?? "")
        }
    }
}
