//___FILEHEADER___

import Foundation
import UIKit
import STT

final class ___VARIABLE_ModuleName___TVSection: UIView, ___VARIABLE_ModuleName___TVSectionViewDelegate {
    
    var presenter: ___VARIABLE_ModuleName___TVSectionPresenter! {
        didSet {
            prepareBind()
        }
    }
    
	override func awakeFromNib() {
        super.awakeFromNib()
        
    }

	func prepareBind() {
        
    }

    // MARK: - implementation of ___VARIABLE_ModuleName___TVSectionViewDelegate
}
