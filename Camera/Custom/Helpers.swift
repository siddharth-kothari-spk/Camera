//
//  Helpers.swift
//  Camera
//
//  Created by Siddharth Kothari on 15/06/23.
//

import Foundation
import UIKit

class Helpers {
    static func getCollectionView(view: UIView,delegateVC: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout) -> UICollectionView {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let itemWidth = (view.frame.width - 30) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = delegateVC
        collectionView.delegate = delegateVC
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        return collectionView
    }
    
    static func getButton(xCoordinate: CGFloat, yCoordinate: CGFloat, title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.frame = CGRect(x: xCoordinate, y: yCoordinate, width: 80, height: 50)
        button.layer.cornerRadius = 10
        button.layer.borderColor = CGColor.init(red: 0.0, green: 0.0, blue: 255.0/255, alpha: 1.0)
        button.layer.borderWidth = 2.0
        return button
    }
}
