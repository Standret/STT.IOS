//___FILEHEADER___

import Foundation
import UIKit

final class ___VARIABLE_ModuleName___TableViewSource: SttTableViewSource<___VARIABLE_ModuleName___TableViewCellPresenter> {
    
	convenience init(tableView: UITableView, collection: SttObservableCollection<___VARIABLE_ModuleName___TableViewCellPresenter>) {
        
        self.init(tableView: tableView,
                  cellIdentifiers: [SttIdentifiers(identifers: ___VARIABLE_ModuleName___TableViewCell.reusableIdentifier)],
                  collection: collection)
    }
}
