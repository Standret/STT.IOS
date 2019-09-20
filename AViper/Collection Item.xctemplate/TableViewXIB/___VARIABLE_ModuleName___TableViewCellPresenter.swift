//___FILEHEADER___

import Foundation
import STT

final class ___VARIABLE_ModuleName___TableViewCellPresenter: Presenter<___VARIABLE_ModuleName___TableViewCellViewDelegate> {
    
    unowned private(set) var parent: ___VARIABLE_ModuleName___TableViewCellDelegate
    
    init(parent: ___VARIABLE_ModuleName___TableViewCellDelegate) {
        
        self.parent = parent
        super.init()
    }
}
