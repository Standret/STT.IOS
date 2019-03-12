//
//  SttRefreshControl.swift
//  OVS
//
//  Created by Peter Standret on 3/11/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SttRefreshControl: UIRefreshControl {
    
    private var lazyExecute: (() -> Void)!

    func useCommand(_ command: SttCommandType, parameter: Any?) -> Disposable {
        
        lazyExecute = {
            command.execute(parametr: parameter)
        }
        
        self.addTarget(self, action: #selector(onValueChanged(_:)), for: .valueChanged)
        
        return command.useWork(start: nil) { [weak self] in
            self?.endRefreshing()
        }
    }
    
    
    @objc
    private func onValueChanged(_ sender: UIRefreshControl) {
        lazyExecute()
    }
}
