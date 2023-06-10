//
//  Coordinator.swift
//  Camera
//
//  Created by Siddharth Kothari on 10/06/23.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators : [Coordinator] {get set}
    var navigationController : UINavigationController {get set}
    
    func start()
}

