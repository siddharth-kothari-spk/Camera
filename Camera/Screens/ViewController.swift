//
//  ViewController.swift
//  Camera
//
//  Created by Siddharth Kothari on 10/06/23.
//

import UIKit
import CoreData

class ViewController: UIViewController, Storyboarded {
    weak var coordinator : MainCoordinator?
    private var cameraViewModel = CameraViewModel()
    weak var albumTableView: UITableView!
    
    override func loadView() {
        super.loadView()

        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
        self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            self.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
        ])
        self.albumTableView = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Album List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraTapped))
        
        albumTableView.dataSource = self
        albumTableView.delegate = self
        albumTableView.register(UITableViewCell.self, forCellReuseIdentifier: "AlbumCell")
        loadAlbums()
    }

    @objc func cameraTapped() {
        coordinator?.cameraTapped()
    }
    
    private func loadAlbums() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Album>(entityName: "Album")
        do {
            cameraViewModel.albums = try managedContext.fetch(fetchRequest)
            albumTableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cameraViewModel.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
        let album = cameraViewModel.albums[indexPath.row]
        cell.textLabel?.text = album.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = cameraViewModel.albums[indexPath.row]
        coordinator?.showAlbumDetailVCFor(album)
    }
}
