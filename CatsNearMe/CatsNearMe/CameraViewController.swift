//
//  CameraViewController.swift
//  CatsNearMe
//
//  Created by Ziwen Chen on 10/6/18.
//  Copyright © 2018 Ziwen Chen. All rights reserved.
//

import UIKit
import AVFoundation

var result : UIImage?

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var session : AVCaptureSession?
    
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var cameraView: UIView!
    
    @IBAction func captureButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "captureSegue", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = AVCaptureSession()
        session?.beginConfiguration()
        
        session?.sessionPreset = AVCaptureSession.Preset.photo
        
        let device : AVCaptureDevice = AVCaptureDevice.default(for: .video)!
        
        let input = try! AVCaptureDeviceInput(device: device)
        
        if (session?.canAddInput(input))! {
            session?.addInput(input)
        }
        
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : NSNumber(value: kCMPixelFormat_32BGRA)]
        output.alwaysDiscardsLateVideoFrames = true
        
        let queue = DispatchQueue(label: "buffer")
        output.setSampleBufferDelegate(self, queue: queue)
        
        if (session?.canAddOutput(output))! {
            session?.addOutput(output)
        }
        
        session?.commitConfiguration()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session!)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.frame = cameraView.layer.bounds
        
        cameraView.layer.addSublayer(previewLayer!)
        
        session?.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let pixelBuffer : CVPixelBuffer? = CMSampleBufferGetImageBuffer(sampleBuffer)
        
        let ciImage = CIImage(cvImageBuffer: pixelBuffer!)
        
        let ciContect = CIContext()
        let cgImage = ciContect.createCGImage(ciImage, from: ciImage.extent)
        
        let uiImage = UIImage(cgImage: cgImage!, scale: 1.0, orientation: .right)
        
        result = uiImage
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
