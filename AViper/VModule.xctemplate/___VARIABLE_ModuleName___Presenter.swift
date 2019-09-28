//___FILEHEADER___

import Foundation
import NGSRouter
import STT

final class ___VARIABLE_ModuleName___Presenter: Presenter<___VARIABLE_ModuleName___ViewDelegate> {
    
    private let _router: NGSRouterType
    private let _interactor: ___VARIABLE_ModuleName___InteractorType
    
    init(view: Viewable,
         router: NGSRouterType,
         interactor: ___VARIABLE_ModuleName___InteractorType
        ) {
        
        _router = router
		_interactor = interactor
        
        super.init()
        super.injectView(delegate: view)
    }
}
