//
//  SttCollectionViewWithSectionSource.swift
//  YURT
//
//  Created by Standret on 30.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//


import Foundation
import UIKit
import RxSwift

class SttCollectionViewWithSectionSource<TCell: SttViewInjector, TSection: SttViewInjector>: NSObject, UICollectionViewDataSource {
    
    var _collectionView: UICollectionView
    
    private var countData: [Int]!
    
    private var _sectionIdentifier: [String]
    var sectionIdentifier: [String] { return _sectionIdentifier }
    
    private var _cellIdentifier: [String]
    var cellIdentifier: [String] { return _cellIdentifier }
    
    private var _collection: SttObservableCollection<(SttObservableCollection<TCell>, TSection)>!
    var collection: SttObservableCollection<(SttObservableCollection<TCell>, TSection)> { return _collection }
    
    private var disposable: DisposeBag!
    
    func updateSource(collection: SttObservableCollection<(SttObservableCollection<TCell>, TSection)>) {
        _collection = collection
        countData = collection.map({ $0.0.count })
        _collectionView.reloadData()
        
        disposable = DisposeBag()
        for index in 0..<collection.count {
            collection[index].0.observableObject.subscribe(onNext: { [weak self] (indexes, type) in
                self?._collectionView.performBatchUpdates({ [weak self] in
                    switch type {
                    case .reload:
                        self?.countData = self?.collection.map({ $0.0.count })
                        self?._collectionView.reloadSections(IndexSet(arrayLiteral: index))
                    case .delete:
                        self?._collectionView.deleteItems(at: indexes.map({ IndexPath(row: $0, section: index) }))
                        self?.countData = self?.collection.map({ $0.0.count })
                    case .insert:
                        self?._collectionView.insertItems(at: indexes.map({ IndexPath(row: $0, section: index) }))
                        self?.countData = self?.collection.map({ $0.0.count })
                    case .update:
                        self?._collectionView.reloadItems(at: indexes.map({ IndexPath(row: $0, section: index) }))
                    }
                })
            }).disposed(by: disposable)
        }
    }
    
    init (collectionView: UICollectionView, cellIdentifiers: [SttIdentifiers], sectionIdentifier: [String], collection: SttObservableCollection<(SttObservableCollection<TCell>, TSection)>) {
        _collectionView = collectionView
        _sectionIdentifier = sectionIdentifier
        _cellIdentifier = cellIdentifiers.map({ $0.identifers })
        
        for item in cellIdentifiers {
            if !item.isRegistered {
                collectionView.register(UINib(nibName: item.nibName ?? item.identifers, bundle: nil), forCellWithReuseIdentifier: item.identifers)
            }
        }
        
        for item in sectionIdentifier {
            collectionView.register(UINib(nibName: item, bundle: nil),
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: item)
        }
        
        super.init()
        
        collectionView.dataSource = self
        updateSource(collection: collection)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countData[section]
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return countData.count
    }
        
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: _sectionIdentifier.first!, for: indexPath) as! SttCollectionReusableView<TSection>
        view.presenter = _collection?[indexPath.section].1
        view.prepareBind()
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: _cellIdentifier.first!, for: indexPath) as! SttCollectionViewCell<TCell>
        cell.presenter = _collection![indexPath.section].0[indexPath.row]
        cell.prepareBind()
        return cell
    }
}
