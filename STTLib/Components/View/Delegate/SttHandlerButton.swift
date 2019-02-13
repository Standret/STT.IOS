//
//  SttHandlerButton.swift
//  OVS
//
//  Created by Peter Standret on 2/8/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation
import UIKit

struct SttDelegatedCall<Input> {
    
    private(set) var callback: ((Input) -> Void)
    
    init<T : AnyObject>(to object: T, with callback: @escaping (T, Input) -> Void) {
        self.callback = { [weak object] input in
            guard let object = object else {
                return
            }
            callback(object, input)
        }
    }
}

enum SttActionButton {
    case touchUpInside
    case touchUpOutside
}

final class SttHandlerButton {
    
    private var handlers = [SttActionButton: [SttDelegatedCall<UIButton>]]()
    private var isInited = false
    
    func addTarget<T: AnyObject>(type: SttActionButton, delegate: T, handler: @escaping (T, UIButton) -> Void, button: UIButton) {
        
        handlers[type] = handlers[type] ?? [SttDelegatedCall<UIButton>]()
        handlers[type]?.append(SttDelegatedCall<UIButton>(to: delegate, with: handler))
        
        if !isInited {
            isInited = true
            
            button.addTarget(self, action: #selector(onTouchUpInside(_:)), for: .touchUpInside)
            button.addTarget(self, action: #selector(onTouchUpOutside(_:)), for: .touchUpOutside)
        }
    }
    
    @objc func onTouchUpInside(_ sender: UIButton) {
        handlers[.touchUpInside]?.forEach({ $0.callback(sender) })
    }
    
    @objc func onTouchUpOutside(_ sender: UIButton) {
        handlers[.touchUpOutside]?.forEach({ $0.callback(sender) })
    }
    
    deinit {
        print("SttHandlerButton deinit")
    }
}
