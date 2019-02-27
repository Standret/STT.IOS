//
//  SttCommandExtensions.swift
//  SttDictionary
//
//  Created by Standret on 26.05.18.
//  Copyright © 2018 Standret. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

extension SttCommand {
    @discardableResult
    func useIndicator(button: UIButton, style: UIActivityIndicatorView.Style = .gray) -> Disposable {
        let indicator = button.setIndicator()
        indicator.color = UIColor.white
        indicator.style = style
        
        let title = button.titleLabel?.text
        var image, disImage: UIImage?
        
        return self.useWork(start: {
            image = button.image(for: .normal)
            disImage = button.image(for: .disabled)
            button.setImage(nil, for: .normal)
            button.setImage(nil, for: .disabled)
            button.setTitle("", for: .disabled)
            button.isEnabled = false
            indicator.startAnimating()
        }) {
            button.setImage(image, for: .normal)
            button.setImage(disImage, for: .disabled)
            button.setTitle(title, for: .disabled)
            button.setNeedsDisplay()
            button.isEnabled = true
            indicator.stopAnimating()
        }
    }
    
    @discardableResult
    func useIndicator(view:  UIView, style: UIActivityIndicatorView.Style = .gray) -> Disposable {
        
        let indicator = view.setIndicator()
        indicator.color = UIColor.white
        indicator.style = style
        
        return self.useWork(start: {
            indicator.startAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }) {
            indicator.stopAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    @discardableResult
    func useRefresh(refreshControl: UIRefreshControl) -> Disposable {
        return self.useWork(start: nil) {
            refreshControl.endRefreshing()
        }
    }
}

extension SttComandWithParametr {
    
    @discardableResult
    func useIndicator(button: UIButton, style: UIActivityIndicatorView.Style = .gray) -> Disposable {
        let indicator = button.setIndicator()
        indicator.color = UIColor.white
        indicator.style = style
        
        let title = button.titleLabel?.text
        var image, disImage: UIImage?
        
        return self.useWork(start: {
            image = button.image(for: .normal)
            disImage = button.image(for: .disabled)
            button.setImage(nil, for: .normal)
            button.setImage(nil, for: .disabled)
            button.setTitle("", for: .disabled)
            button.isEnabled = false
            indicator.startAnimating()
        }) {
            button.setImage(image, for: .normal)
            button.setImage(disImage, for: .disabled)
            button.setTitle(title, for: .disabled)
            button.setNeedsDisplay()
            button.isEnabled = true
            indicator.stopAnimating()
        }
    }
    
    @discardableResult
    func useIndicator(view:  UIView, style: UIActivityIndicatorView.Style = .gray) -> Disposable {
        
        let indicator = view.setIndicator()
        indicator.color = UIColor.white
        indicator.style = style
      
        return self.useWork(start: {
            indicator.startAnimating()
        }) {
            indicator.stopAnimating()
        }
    }
    
    @discardableResult
    func useRefresh(refreshControl: UIRefreshControl) -> Disposable {
        return self.useWork(start: nil) {
            refreshControl.endRefreshing()
        }
    }
}
