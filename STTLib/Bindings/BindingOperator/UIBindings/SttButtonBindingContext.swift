//
//  SttButtonBindingSet.swift
//  OVS
//
//  Created by Peter Standret on 2/8/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

// TODO: write this comment
/**
 A binding for button events (touchUpInside by default)
 and redirect this events to command
 */
class SttButtonBindingSet: SttBindingContextType {

    unowned private let button: UIButton

    private var handler = SttHandlerButton()
    private var command: SttCommandType!
    private var parametr: Any?
    
    private var disposeBag = DisposeBag()
    
    init (button: UIButton) {
        
        self.button = button
    }
    
    @discardableResult
    func to(_ command: SttCommandType) -> SttButtonBindingSet {
        self.command = command
        
        return self
    }
    
    @discardableResult
    func withCommandParametr(_ parametr: Any) -> SttButtonBindingSet {
        self.parametr = parametr
        
        return self
    }
    
    func apply() {
        button.isEnabled = command.canExecute(parametr: parametr)
        command.observableCanNext
            .subscribe(onNext: { [unowned self] in self.button.isEnabled = $0 })
            .disposed(by: disposeBag)
        handler.addTarget(type: .touchUpInside, delegate: self, handler: { (d,_) in d.command.execute(parametr: d.parametr) }, button: button)
    }
}

/**
 
 Custom operators
 Second way to write bindings
 
 For more information look at our documentation on github
 
 UPS :\ Something missing
 If you see this message just write me. Prter Standret
 
 */

@discardableResult
func ->> (left: SttButtonBindingSet, right: SttCommandType) -> SttButtonBindingSet{
    return left.to(right)
}

@discardableResult
func -< (left: SttButtonBindingSet, right: Any) -> SttButtonBindingSet {
    return left.withCommandParametr(right)
}
