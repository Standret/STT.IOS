//___FILEHEADER___

import Foundation
import UIKit
import STT

final class ___VARIABLE_ModuleName___CollectionViewSource: SttCollectionViewSource<___VARIABLE_ModuleName___CollectionViewCellPresenter> {
    
	convenience init(collectionView: UICollectionView, collection: SttObservableCollection<___VARIABLE_ModuleName___CollectionViewCellPresenter>) {
        
        self.init(collectionView: collectionView,
                  cellIdentifiers: [SttIdentifiers(identifers: ___VARIABLE_ModuleName___CollectionViewCell.reusableIdentifier)],
                  collection: collection)
    }
}
