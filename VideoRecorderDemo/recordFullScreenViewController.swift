//
//  recordFullScreenViewController.swift
//  VideoRecorderDemo
//
//  Created by trevor jordet on 2/16/16.
//  Copyright © 2016 jord3t. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices


class recordFullScreenViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    override func viewWillAppear(animated: Bool)
    {
       startCameraFromViewController(self, withDelegate: self)
    }

    func startCameraFromViewController(viewController: UIViewController, withDelegate delegate: protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>) -> Bool
    {
        if UIImagePickerController.isSourceTypeAvailable(.Camera)
        {
            let cameraController = UIImagePickerController()
            cameraController.sourceType = .Camera
            cameraController.mediaTypes = [kUTTypeMovie as String]
            cameraController.allowsEditing = false
            cameraController.delegate = delegate
            presentViewController(cameraController, animated: true, completion: nil)
            return true
        } else {
            return false
        }
    }
    
}
