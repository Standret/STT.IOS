//___FILEHEADER___

import Foundation
import UIKit
import STT

final class ___VARIABLE_ModuleName___TableViewSource: TableViewSource<___VARIABLE_ModuleName___TableViewCellPresenter> {
    
	convenience init(
        tableView: UITableView,
        collection: ObservableCollection<___VARIABLE_ModuleName___TableViewCellPresenter>
        ) {
        
        self.init(
            tableView: tableView,
            cellIdentifiers: [
                CellIdentifier(identifers: ___VARIABLE_ModuleName___TableViewCell.reusableIdentifier)
            ],
            collection: collection
        )
    }
}
