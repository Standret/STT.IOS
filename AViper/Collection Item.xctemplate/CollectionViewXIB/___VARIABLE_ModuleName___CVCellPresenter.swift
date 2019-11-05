//___FILEHEADER___

import Foundation
import STT

final class ___VARIABLE_ModuleName___CVCellPresenter: Presenter<___VARIABLE_ModuleName___CVCellViewDelegate> {
    
    unowned private(set) var parent: ___VARIABLE_ModuleName___CVCellDelegate
    
    init(parent: ___VARIABLE_ModuleName___CVCellDelegate) {
        
        self.parent = parent
        super.init()
    }
}
