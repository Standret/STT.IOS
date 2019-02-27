//
//  Camera.swift
//  YURT
//
//  Created by Standret on 22.05.18.
//  Copyright © 2018 com.yurt.YURT. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SttCamera: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let picker = UIImagePickerController()
    private let callBack: (UIImage) -> Void
    private weak var parent: UIViewController?
    
    init (parent: UIViewController, handler: @escaping (UIImage) -> Void) {
        self.callBack = handler
        self.parent = parent
        super.init()
        picker.delegate = self
    }
    
    private func takePhoto() {
        picker.sourceType = .camera
        parent?.present(picker, animated: true, completion: nil)
    }
    private func selectPhoto() {
        picker.sourceType = .photoLibrary
        parent?.present(picker, animated: true, completion: nil)
    }
    
    func showPopuForDecision() {
        if checkPermission() {
            let actionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionController.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (x) in
                self.takePhoto()
            }))
            actionController.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { (x) in
                self.selectPhoto()
            }))
            actionController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            for item in actionController.view.subviews.first!.subviews.first!.subviews {
                item.backgroundColor = UIColor.white
            }
            
            parent?.present(actionController, animated: true, completion: nil)
        }
        else {
            showPermissionDeniedPopup()
        }
    }
    
    private func checkPermission() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized, .notDetermined:
            return true
        case .denied, .restricted:
            return false
        }
    }
    
    private func showPermissionDeniedPopup() {
        let alertController = UIAlertController(title: "Change your settings and give Lemon access to your camera and photos.",
                                                message: "Open your app settings, click on \"privacy\" and than \"photos\"",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        alertController.addAction(openAction)
        
        parent?.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - implementation of UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if let _image = image?.fixOrientation() {
            callBack(_image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
