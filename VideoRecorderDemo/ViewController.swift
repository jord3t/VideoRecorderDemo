//
//  ViewController.swift
//  VideoRecorderDemo
//
//  Created by trevor jordet on 2/16/16.
//  Copyright © 2016 jord3t. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var VideoView: UIView!
    @IBOutlet weak var capturedImage: UIImageView!
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoCaptureOutput: AVCaptureVideoDataOutput!
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureSession: AVCaptureSession?
    var image: UIImage?
    
    @IBAction func captureScreen()
    {
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo)
        {
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil)
                {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    print(UIDevice.currentDevice().orientation.rawValue)
                    
                    switch(UIDevice.currentDevice().orientation.rawValue)
                    {
                    case 2:
                        self.image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Left)
                    case 4:
                        self.image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Down)
                    case 3:
                        self.image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Up)
                    case 1:
                        self.image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    default:
                        print("default")
                    }
                    
                    self.capturedImage.image = self.image
                }
            })
        }

    }
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetHigh
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setVideoLayout", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error)
        }
        
        if captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
        }
        
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        captureSession!.addOutput(stillImageOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
        VideoView.layer.addSublayer(previewLayer!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectAvideoFromLibrary()
    {
         startMediaBrowserFromViewController(self, usingDelegate: self)
    }
    
    @IBAction func recordInSubView()
    {
        captureSession?.startRunning()
        setVideoLayout()
        
        print("VideoView \(VideoView.frame.origin)")
        print("previewLayer \(previewLayer!.frame.origin)")
    }
    
    func setVideoLayout()
    {
        previewLayer!.frame.size.height = VideoView.frame.size.height
        previewLayer!.frame.size.width = VideoView.frame.size.width
        print(UIDevice.currentDevice().orientation.rawValue)
        switch(UIDevice.currentDevice().orientation.rawValue)
        {
            case 2:
                previewLayer!.connection.videoOrientation = AVCaptureVideoOrientation.PortraitUpsideDown
            case 4:
                previewLayer!.connection.videoOrientation = AVCaptureVideoOrientation.LandscapeLeft
            case 3:
                previewLayer!.connection.videoOrientation = AVCaptureVideoOrientation.LandscapeRight
            case 1:
                previewLayer!.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
            default:
                print("default")
        }
        
    }
    
    @IBAction func recordVideo()
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
    
    
    func startMediaBrowserFromViewController(viewController: UIViewController, usingDelegate delegate: protocol<UINavigationControllerDelegate, UIImagePickerControllerDelegate>) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) == false {
            return false
        }
        
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = .SavedPhotosAlbum
        mediaUI.mediaTypes = [kUTTypeMovie as String]
        mediaUI.allowsEditing = true
        mediaUI.delegate = delegate
        
        presentViewController(mediaUI, animated: true, completion: nil)
        return true
    }
}