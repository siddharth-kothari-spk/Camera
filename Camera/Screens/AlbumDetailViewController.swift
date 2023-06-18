//
//  AlbumDetailViewController.swift
//  Camera
//
//  Created by Siddharth Kothari on 13/06/23.
//

import UIKit
import CoreData

class AlbumDetailViewController: UIViewController, Storyboarded {
    weak var coordinator : MainCoordinator?
    private var collectionView: UICollectionView!
    private var album: Album
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Album Detail"
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView = Helpers.getCollectionView(view: view, delegateVC: self)
        view.addSubview(collectionView)
    }
}

extension AlbumDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album.photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photos = album.photos?.allObjects as? [Photo]
        let photo = photos?[indexPath.item]
        cell.imageView.image = UIImage(data: (photo?.image)!)
        return cell
    }
}

