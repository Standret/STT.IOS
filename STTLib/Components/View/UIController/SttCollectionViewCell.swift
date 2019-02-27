//
//  SttCollectionCell.swift
//  SttDictionary
//
//  Created by Standret on 19.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import UIKit

class SttCollectionViewCell<T: SttViewInjector>: UICollectionViewCell, SttViewable {
    
    var presenter: T!
    
    func prepareBind() {
        presenter.injectView(delegate: self)
    }
}
