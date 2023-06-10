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
      print("MainCoordinator start")
        let vc = ViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func cameraTapped() {
        print("camera tapped")
    }
}

