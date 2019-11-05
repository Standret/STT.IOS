//___FILEHEADER___

import Swinject
import NGSRouter
import STT

final class ___VARIABLE_ModuleName___ModuleAssembler: Assembly {
    
	//Module assembly
    func assemble(container: Container) {
        
		container.register(___VARIABLE_ModuleName___InteractorType.self) { (r) in
            ___VARIABLE_ModuleName___Interactor()
        }

        container.register(___VARIABLE_ModuleName___Presenter.self) { (r, vc: ___VARIABLE_ModuleName___ViewController) in
            ___VARIABLE_ModuleName___Presenter(
                view: vc,
                router: NGSRouter(transitionHandler: vc),
                interactor: r.resolve(___VARIABLE_ModuleName___InteractorType.self)!
            )
        }
        
        NGSRouterAssember.shared.register(
            storyboard: Storyboard.<#storyboard#>,
            navigatable: ___VARIABLE_ModuleName___Presenter.self,
            conigurator: { (viewController: ___VARIABLE_ModuleName___ViewController) in
                viewController.presenter = container.resolve(
                    ___VARIABLE_ModuleName___Presenter.self,
                    argument: viewController
                    )!
        })
    }
}
