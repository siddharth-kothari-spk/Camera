//
//  CameraViewModel.swift
//  Camera
//
//  Created by Siddharth Kothari on 13/06/23.
//

import UIKit
import AVFoundation
import CoreData

import UIKit
import CoreData

class CameraViewModel: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var capturedImages: [UIImage] = []
    var albums: [Album] = []
    var currentAlbum: Album?
    
    func createAlbum(name: String) {
        let album = Album(context: context)
        album.name = name
        album.timeStamp = Date()
        
        currentAlbum = album
        albums.append(album)
        
        saveContext()
    }
    
    func deleteAlbum() {
        guard let currentAlbum = currentAlbum else { return }
        context.delete(currentAlbum)
        saveContext()
    }
    
    func saveImagesToAlbum() {
        guard let currentAlbum = currentAlbum else { return }
        
        for image in capturedImages {
            let photo = Photo(context: context)
            photo.image = image.jpegData(compressionQuality: 1.0)
            currentAlbum.addToPhotos(photo)
        }
        saveContext()
        capturedImages.removeAll()
    }
    
    func loadAlbums() {
        let fetchRequest: NSFetchRequest<Album> = Album.fetchRequest()
        do {
            albums = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching albums: \(error)")
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
