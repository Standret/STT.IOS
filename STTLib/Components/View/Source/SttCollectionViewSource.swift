//
//  SttCollectionViewSource.swift
//  SttDictionary
//
//  Created by Standret on 19.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class SttCollectionViewSource<T: SttViewInjector>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var _collectionView: UICollectionView
    
    private var countData = 0
    
    private var _cellIdentifier: [String]
    var cellIdentifier: [String] { return _cellIdentifier }
    
    private var _collection: SttObservableCollection<T>!
    var collection: SttObservableCollection<T> { return _collection }
    
    private var disposables: Disposable?
    
    private var endScrollCallBack: (() -> Void)?
    
    var callBackEndPixel: Int = 150
    
    init(collectionView: UICollectionView, cellIdentifiers: [SttIdentifiers], collection: SttObservableCollection<T>) {
        _collectionView = collectionView
        _cellIdentifier = cellIdentifiers.map({ $0.identifers })
        super.init()
        
        for item in cellIdentifiers {
            if !item.isRegistered {
                collectionView.register(UINib(nibName: item.nibName ?? item.identifers, bundle: nil), forCellWithReuseIdentifier: item.identifers)
            }
        }
        
        _collectionView.dataSource = self
        updateSource(collection: collection)
        _collectionView.delegate = self
    }
    
    func updateSource(collection: SttObservableCollection<T>) {
        _collection = collection
        countData = collection.count
        _collectionView.reloadData()
        disposables?.dispose()
        disposables = _collection.observableObject.subscribe(onNext: { [weak self] (indexes, type) in
            if type == .reload {
                self?.countData = collection.count
                self?._collectionView.reloadData()
            }
            self?._collectionView.performBatchUpdates({ [weak self] in
                switch type {
                case .delete:
                    self?._collectionView.deleteItems(at: indexes.map({ IndexPath(row: $0, section: 0) }))
                    self?.countData = collection.count
                case .insert:
                    self?._collectionView.insertItems(at: indexes.map({ IndexPath(row: $0, section: 0) }))
                    self?.countData = collection.count
                case .update:
                    self?._collectionView.reloadItems(at: indexes.map({ IndexPath(row: $0, section: 0) }))
                default: break
                }
            })
        })
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countData
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = _collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewReusableCell(at: indexPath),
                                                       for: indexPath) as! SttCollectionViewCell<T>
        cell.presenter = _collection[indexPath.row]
        cell.prepareBind()
        return cell
    }
    
    func collectionViewReusableCell(at indexPath: IndexPath) -> String {
        return _cellIdentifier.first!
    }
    
    func addEndScrollHandler<T: UIViewController>(delegate: T, callback: @escaping (T) -> Void) {
        endScrollCallBack = { [weak delegate] in
            if let _delegate = delegate {
                callback(_delegate)
            }
        }
    }
    
    // MARK: - implementation UICollectionViewDelegate
    private var inPosition: Bool = false
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let x = scrollView.contentOffset.y
        let width = scrollView.contentSize.height - scrollView.bounds.height - CGFloat(callBackEndPixel)
        
        if (scrollView.contentSize.height > scrollView.bounds.height) {
            if (x > width) {
                if (!inPosition) {
                    endScrollCallBack?()
                }
                inPosition = true
            }
            else {
                inPosition = false
            }
        }
    }
    
}
