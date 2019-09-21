//___FILEHEADER___

import Foundation
import STT

final class ___VARIABLE_ModuleName___TVCellPresenter: Presenter<___VARIABLE_ModuleName___TVCellViewDelegate> {
    
    unowned private(set) var parent: ___VARIABLE_ModuleName___TVCellDelegate
    
    init(parent: ___VARIABLE_ModuleName___TVCellDelegate) {
        
        self.parent = parent
        super.init()
    }
}
