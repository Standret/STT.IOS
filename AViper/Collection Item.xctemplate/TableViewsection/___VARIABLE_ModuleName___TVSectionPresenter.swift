//___FILEHEADER___

import Foundation
import STT

final class ___VARIABLE_ModuleName___TVSectionPresenter: Presenter<___VARIABLE_ModuleName___TVSectionViewDelegate> {
    
    unowned private(set) var parent: ___VARIABLE_ModuleName___TVSectionDelegate
    
    init(parent: ___VARIABLE_ModuleName___TVSectionDelegate) {
        
        self.parent = parent
        super.init()
    }
}
