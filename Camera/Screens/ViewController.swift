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
    weak var noAlbumView: UIView!
    
    override func loadView() {
        super.loadView()
        setupTableView()
        setupNoAlbumView()
    }
    
    private func setupTableView() {
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
    
    private func setupNoAlbumView() {
        let noView = UIView(frame: .zero)
        noView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel(frame: CGRect(x: 50, y: 100, width: 300, height: 150))
        label.text = "No Albums available. Please click on camera icon to initiate album creation"
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
        self.noAlbumView = noView
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
        coordinator?.cameraTapped(self)
    }
    
    private func loadAlbums() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Album>(entityName: "Album")
        do {
            cameraViewModel.albums = try managedContext.fetch(fetchRequest)
            if cameraViewModel.albums.count > 0 {
                albumTableView.reloadData()
                albumTableView.isHidden = false
                noAlbumView.isHidden = true
            }
            else {
                albumTableView.isHidden = true
                noAlbumView.isHidden = false
            }
            
        } catch let error as NSError {
            print("Could not fetch the entity Album. \(error), \(error.userInfo)")
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
