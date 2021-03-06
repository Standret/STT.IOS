//
//  SttTableViewSource.swift
//  SttDictionary
//
//  Created by Standret on 19.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//


import Foundation
import UIKit
import RxSwift

class SttTableViewSource<T: SttViewInjector>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var _tableView: UITableView
    
    private var endScrollCallBack: (() -> Void)?
    
    var callBackEndPixel: Int = 150
    
    private var _cellIdentifiers = [String]()
    var cellIdentifiers: [String] { return _cellIdentifiers }
    
    var useAnimation: Bool = false
    var maxAnimationCount = 1
    
    private var _collection: SttObservableCollection<T>!
    var collection: SttObservableCollection<T> { return _collection }
    
    private var disposables: Disposable?
    
    init(tableView: UITableView, cellIdentifiers: [SttIdentifiers], collection: SttObservableCollection<T>) {
        
        for item in cellIdentifiers {
            if !item.isRegistered {
                tableView.register(UINib(nibName: item.nibName ?? item.identifers, bundle: nil), forCellReuseIdentifier: item.identifers)
            }
        }
        
        _tableView = tableView
        _cellIdentifiers.append(contentsOf: cellIdentifiers.map({ $0.identifers }))
        
        super.init()
        tableView.dataSource = self
        updateSource(collection: collection)
        tableView.delegate = self
    }
    
    func updateSource(collection: SttObservableCollection<T>) {
        _collection = collection
        _tableView.reloadData()
        disposables?.dispose()
        disposables = _collection.observableObject.subscribe(onNext: { [weak self] (indexes, type) in
            if self?.maxAnimationCount ?? 0 < indexes.count {
                self?._tableView.reloadData()
            }
            else {
                switch type {
                case .reload:
                    self?._tableView.reloadData()
                case .delete:
                    self?._tableView.deleteRows(at: indexes.map({ IndexPath(row: $0, section: 0) }),
                                                with: self!.useAnimation ? .left : .none)
                case .insert:
                    self?._tableView.insertRows(at: indexes.map({ IndexPath(row: $0, section: 0) }),
                                                with: self!.useAnimation ? .middle : .none)
                case .update:
                    self?._tableView.reloadRows(at: indexes.map({ IndexPath(row: $0, section: 0) }),
                                                with: self!.useAnimation ? .fade : .none)
                }
            }
        })
    }
    
    func addEndScrollHandler<T: UIViewController>(delegate: T, callback: @escaping (T) -> Void) {
        endScrollCallBack = { [weak delegate] in
            if let _delegate = delegate {
                callback(_delegate)
            }
        }
    }
    
    // MARK: -- todo: write init for [cellIdentifiers]
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _collection == nil ? 0 : _collection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier(for: indexPath))! as! SttTableViewCell<T>
        cell.presenter = _collection[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView(tableView, didSelectRowAt: indexPath, with: collection[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, with presenter: T) { }
    
    /// Method which return cell identifier to create reusable cell
    func cellIdentifier(for indexPath: IndexPath) -> String {
        return cellIdentifiers.first!
    }
    
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
