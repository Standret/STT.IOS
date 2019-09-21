//___FILEHEADER___

import Foundation
import UIKit
import STT

final class ___VARIABLE_ModuleName___TVSource: TableViewSource<___VARIABLE_ModuleName___TVCellPresenter> {
    
	convenience init(
        tableView: UITableView,
        collection: ObservableCollection<___VARIABLE_ModuleName___TVCellPresenter>
        ) {
        
        self.init(
            tableView: tableView,
            cellIdentifiers: [
                CellIdentifier(identifers: ___VARIABLE_ModuleName___TVCell.reusableIdentifier)
            ],
            collection: collection
        )
    }
}
