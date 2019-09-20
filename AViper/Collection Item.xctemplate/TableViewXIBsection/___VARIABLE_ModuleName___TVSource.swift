//___FILEHEADER___

import Foundation
import UIKit
import STT

final class ___VARIABLE_ModuleName___TVSource: TableViewSourceWithSection<___VARIABLE_ModuleName___TVCellPresenter, ___VARIABLE_ModuleName___TVSectionPresenter> {
    
	convenience init(
        tableView: UITableView,
        collection: ObservableCollection<SectionData<___VARIABLE_ModuleName___TVCellPresenter, ___VARIABLE_ModuleName___TVSectionPresenter>>
        ) {
        
        self.init(
            tableView: tableView,
            cellIdentifiers: [
                CellIdentifier(identifers: ___VARIABLE_ModuleName___TVCell.reusableIdentifier)
            ],
            collection: collection
        )
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return <#value#>
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return <#value#>
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = ___VARIABLE_ModuleName___TVSection()
        view.presenter = sectionPresenter(at: section)
        return view
    }
}
