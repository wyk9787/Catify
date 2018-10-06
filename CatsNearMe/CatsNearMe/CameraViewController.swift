//
//  CameraViewController.swift
//  CatsNearMe
//
//  Created by Ziwen Chen on 10/6/18.
//  Copyright © 2018 Ziwen Chen. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

var result : UIImage?
var lon : Double = 0
var lat : Double = 0
let colors = ["Black","White","Grey","Orange","Blue","Yellow","Mixed"]

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var selectedColor = "black"
    
    var locationManager = CLLocationManager()
    
    var session : AVCaptureSession?
    
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var colorPicker: UIPickerView!
    
    
    @IBAction func captureButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "captureSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorPicker.delegate = self
        colorPicker.dataSource = self
        
        self.locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue : CLLocationCoordinate2D = (manager.location?.coordinate)!
        lon = locValue.longitude
        lat = locValue.latitude
    }
    
    // MARK: - Picker View Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedColor = colors[row]
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "captureSegue") {
            let DestVC = segue.destination as! candidateViewController
            Cat.findsimilar(lon: lon, lat: lat, color: selectedColor, image: result!) { (cats) in
                DestVC.candidates = cats
                DestVC.candidateTableView.reloadData()
            }
        }
    }
    

}
