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

class SttButtonBindingSet: SttBindingContextType {

    unowned private let button: UIButton

    private var handler = SttHandlerButton()
    private var command: SttCommandType!
    private var parametr: Any?
    
    private var disposeBag = DisposeBag()
    
    init (button: UIButton) {
        
        self.button = button
    }
    
    deinit {
        print("SttButtonBindingSet deinit")
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

@discardableResult
func ->> (left: SttButtonBindingSet, right: SttCommandType) -> SttButtonBindingSet{
    return left.to(right)
}

@discardableResult
func -< (left: SttButtonBindingSet, right: Any) -> SttButtonBindingSet {
    return left.withCommandParametr(right)
}
