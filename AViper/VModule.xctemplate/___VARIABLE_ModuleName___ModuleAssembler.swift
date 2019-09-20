//___FILEHEADER___

import Swinject
import SwinjectStoryboard
import STT

final class ___VARIABLE_ModuleName___ModuleAssembler: Assembly {
    
	//Module assembly
    func assemble(container: Container) {
        container.register(___VARIABLE_ModuleName___RouterType.self) { (r, vc: ___VARIABLE_ModuleName___ViewController) in ___VARIABLE_ModuleName___Router(transitionHandler: vc) }
        
		container.register(___VARIABLE_ModuleName___InteractorType.self,
                           factory: { (r) in ___VARIABLE_ModuleName___Interactor() })

        container.register(___VARIABLE_ModuleName___Presenter.self) { (r, vc: ___VARIABLE_ModuleName___ViewController) in
            ___VARIABLE_ModuleName___Presenter(view: vc, notificationService: r.resolve(SttNotificationErrorServiceType.self)!,
                                   router: r.resolve(___VARIABLE_ModuleName___RouterType.self, argument: vc)!, interactor: r.resolve(___VARIABLE_ModuleName___InteractorType.self)!)
        }
        container.storyboardInitCompleted(___VARIABLE_ModuleName___ViewController.self) { r, viewController in
            viewController.presenter = r.resolve(___VARIABLE_ModuleName___Presenter.self, argument: viewController)!
        }
    }
}
