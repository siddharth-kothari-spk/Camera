//
//  MainCoordinator.swift
//  Camera
//
//  Created by Siddharth Kothari on 10/06/23.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = ViewController.instantiate()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func cameraTapped(_ delegateVC: LoadImages) {
        let cameraViewController = CameraViewController.instantiate()
        cameraViewController.coordinator = self
        cameraViewController.delegate = delegateVC
        navigationController.pushViewController(cameraViewController, animated: true)
    }
    
    func showAlbumDetailVCFor(_ album: Album) {
        let albumDetailViewController = AlbumDetailViewController(album: album)
        albumDetailViewController.coordinator = self
        navigationController.pushViewController(albumDetailViewController, animated: true)
    }
}

