//___FILEHEADER___

import Foundation

final class ___VARIABLE_ModuleName___Presenter: SttPresenter<___VARIABLE_ModuleName___ViewDelegate> {
    
    private let _router: ___VARIABLE_ModuleName___RouterType
    private let _interactor: ___VARIABLE_ModuleName___InteractorType
    
    init(view: SttViewable, notificationService: SttNotificationErrorServiceType, router: ___VARIABLE_ModuleName___RouterType,
         interactor: ___VARIABLE_ModuleName___InteractorType) {
        
        _router = router
		_interactor = interactor
        
        super.init(notificationError: notificationService)
        super.injectView(delegate: view)
    }
}
