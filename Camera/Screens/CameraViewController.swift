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
    
    private var collectionView: UICollectionView!
    
    weak var delegate: LoadImages?
    weak var noPreviewView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNoPreviewView()
        setupCamera()
        setupNavigationBar()
        setNavigationItemVisibility()
    }
        
    private func setupCollectionView() {
        collectionView = Helpers.getCollectionView(view: view, delegateVC: self)
        view.addSubview(collectionView)
    }
    
    private func setupNoPreviewView() {
        let noView = UIView(frame: .zero)
        noView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel(frame: CGRect(x: 50, y: 100, width: 300, height: 150))
        label.text = "No images to preview."
        label.textAlignment = .center
        label.backgroundColor = .blue
        label.textColor = .white
        label.numberOfLines = 0
        
        noView.addSubview(label)
        self.view.addSubview(noView)
        NSLayoutConstraint.activate([
        self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: noView.topAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: noView.bottomAnchor),
            self.view.leadingAnchor.constraint(equalTo: noView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: noView.trailingAnchor),
        ])
        self.noPreviewView = noView
    }
    
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
        
        createAlbum()
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
    
    @objc func saveImagesButtonTapped() {
        if cameraViewModel.capturedImages.count > 0 {
            cameraViewModel.saveImagesToAlbum()
            coordinator?.navigationController.popViewController(animated: true)
            delegate?.loadImages()
        }
    }
    
    @objc private func addMoreImages() {
        presentImagePicker()
        setSaveButtonTitle()
    }
    
    @objc private func captureButtonTapped() {
        imagePicker.takePicture()
    }
    
    @objc private func closeButtonTapped() {
        imagePicker.dismiss(animated: true, completion: nil)
        cameraViewModel.deleteAlbum()
        coordinator?.navigationController.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        saveImagesButtonTapped()
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @objc private func previewButtonTapped() {
        imagePicker.dismiss(animated: true, completion: nil)
        if cameraViewModel.capturedImages.count > 0 {
            collectionView.reloadData()
            collectionView.isHidden = false
            noPreviewView.isHidden = true
        }
        else {
            collectionView.isHidden = true
            noPreviewView.isHidden = false
        }
    }
    
    @objc private func backToParent() {
        if cameraViewModel.capturedImages.count > 0 {
            let alertController = UIAlertController(title: "You have unsaved images.", message: "Press Save to save images", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: {[weak self] _ in
                self?.coordinator?.navigationController.popViewController(animated: true)}))
            alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
                self?.saveImagesButtonTapped()
                self?.coordinator?.navigationController.popViewController(animated: true)
            }))
            present(alertController, animated: true, completion: nil)
        }
        else {
            coordinator?.navigationController.popViewController(animated: true)
        }
    }
    
    private func createAlbum() {
        let alertController = UIAlertController(title: "Create Album", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Album Name"
        }
 
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { [weak self] _ in
            self?.coordinator?.navigationController.popViewController(animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Create", style: .default) { [weak self] _ in
            if let albumName = alertController.textFields?.first?.text?.trimmingCharacters(in: .whitespaces) {
                var name = albumName
                if albumName.count == 0 {
                    name = "Camera_" + "\(Date().timeIntervalSince1970)"
                }
                self?.cameraViewModel.createAlbum(name: name)
                self?.presentImagePicker()
            }
        })
        present(alertController, animated: true, completion: nil)
    }
    
    private func presentImagePicker() {
        present(imagePicker, animated: true, completion: nil)
    }
        
    private func setSaveButtonTitle() {
        saveButton.setTitle("Save(\(cameraViewModel.capturedImages.count))", for: .normal)
    }
}

extension CameraViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            cameraViewModel.capturedImages.append(image)
        }
        setSaveButtonTitle()
        setNavigationItemVisibility()
        picker.dismiss(animated: false, completion: nil)
        present(imagePicker, animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


extension CameraViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cameraViewModel.capturedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = cameraViewModel.capturedImages[indexPath.item]
        cell.imageView.image = photo
        return cell
    }
}
