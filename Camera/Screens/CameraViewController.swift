//
//  CameraViewController.swift
//  Camera
//
//  Created by Siddharth Kothari on 13/06/23.
//

import UIKit
import AVFoundation

import UIKit
import CoreData

class CameraViewController: UIViewController, Storyboarded {
    weak var coordinator : MainCoordinator?
    private var cameraViewModel = CameraViewModel()
    private var imagePicker: UIImagePickerController!
    private var saveButton: UIButton!
    
class CameraViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupNavigationBar()
        setNavigationItemVisibility()
    }
        
    
        
        // Do any additional setup after loading the view.
    
    private func setupCamera() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        imagePicker.showsCameraControls = false
        
        let customOverlayView = UIStackView(frame: view.bounds)
        
        let closeButton = Helpers.getButton(xCoordinate: 10, yCoordinate: view.bounds.maxY - 100, title: "Close")
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        let previewButton = Helpers.getButton(xCoordinate: 100, yCoordinate: view.bounds.maxY - 100, title: "Preview")
        previewButton.addTarget(self, action: #selector(previewButtonTapped), for: .touchUpInside)
        
        let captureButton = Helpers.getButton(xCoordinate: 190, yCoordinate: view.bounds.maxY - 100, title: "Capture")
        captureButton.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
        
        saveButton = Helpers.getButton(xCoordinate: 280, yCoordinate: view.bounds.maxY - 100, title: "Save")
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        customOverlayView.addSubview(closeButton)
        customOverlayView.addSubview(previewButton)
        customOverlayView.addSubview(captureButton)
        customOverlayView.addSubview(saveButton)
        imagePicker.cameraOverlayView = customOverlayView
        
    }
    
    private func setupNavigationBar() {
        let saveImagesButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveImagesButtonTapped))
        let addMoreImages = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addMoreImages))
        navigationItem.rightBarButtonItems = [addMoreImages, saveImagesButton]
        
        let backButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(backToParent))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setNavigationItemVisibility() {
        navigationItem.rightBarButtonItem?.isHidden = !(cameraViewModel.capturedImages.count > 0)
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
