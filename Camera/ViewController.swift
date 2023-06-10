//
//  ViewController.swift
//  Camera
//
//  Created by Siddharth Kothari on 10/06/23.
//

import UIKit

class ViewController: UIViewController, Storyboarded {
    weak var coordinator : MainCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Camera"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraTapped))
    }

    @objc func cameraTapped() {
        coordinator?.cameraTapped()
    }

}

