//___FILEHEADER___

import Foundation
import UIKit
import STT

final class ___VARIABLE_ModuleName___CVSource: CollectionViewSource<___VARIABLE_ModuleName___CVCellPresenter> {
    
	convenience init(
        collectionView: UICollectionView,
        collection: ObservableCollection<___VARIABLE_ModuleName___CVCellPresenter>
        ) {
        
        self.init(
            collectionView: collectionView,
            cellIdentifiers: [
                CellIdentifier(identifers: ___VARIABLE_ModuleName___CVCell.reusableIdentifier)
            ],
            collection: collection
        )
    }
}
