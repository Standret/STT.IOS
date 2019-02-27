//
//  SttUICollectionViewExtensions.swift
//  OVS
//
//  Created by StartupSoft on 2/26/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    /**
     Adjusting vertical layout grid to the certian quantity of columns.
     Developer should determine quantity of columns in one row and set the padding between them.
     
     Width of every element will be calculated in accordance with 'columnsQuantity' and 'itemsPadding' parameters.
     Padding between lines can be set with 'lineSpacing' parametr, by default is 1
     
     - REMARK:
     It's recommended to use this function after all bounds of the view were set, for example in ViewDidLayoutSubviews method.
     
     - Parameters:
     - columnsQuantity: number of columns in one row
     - heigh: height of cell
     - itemsPadding: padding between cells in one row
     - lineSpacing: padding between rows
     
     - Returns: Void
     */
    func adjustVerticalLayoutGrid(columnsQuantity: Int, height: CGFloat, itemsPadding: CGFloat = 0, lineSpacing: CGFloat = 1) {

        guard let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        if flowLayout.scrollDirection == .vertical {
            if columnsQuantity > 0 && itemsPadding >= 0 && height > 0 {
                
                let insetsSize: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
                
                let contentWidth = self.bounds.size.width - insetsSize
                let itemWidth: CGFloat = contentWidth / CGFloat(columnsQuantity) - itemsPadding
                
                let itemSize: CGSize = CGSize(width: itemWidth, height: height)
                flowLayout.itemSize = itemSize
                
                flowLayout.minimumLineSpacing = lineSpacing
                flowLayout.minimumInteritemSpacing = 0
            }
        }
    }
    
    func setItemSize(size: CGSize) {
        guard let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        flowLayout.itemSize = size
    }
}

