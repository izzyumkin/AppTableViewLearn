//
//  NewPlaceTableViewController.swift
//  AppTableViewLearn
//
//  Created by Иван Изюмкин on 24/05/2019.
//  Copyright © 2019 Иван Изюмкин. All rights reserved.
//

import UIKit

class NewPlaceTableViewController: UITableViewController {
    
    var currentPlace: Place?
    var imageIsChenged = false
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChenged), for: .editingChanged)
        setupEditScrean()
        
        
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true)
        
        
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let cameraImage = #imageLiteral(resourceName: "camera")
            let photoImage = #imageLiteral(resourceName: "photo")
            
            let acrionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                
                self.chooseImagePicker(sourse: .camera)
                
            }
            
            camera.setValue(cameraImage, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photoLibery = UIAlertAction(title: "Photo", style: .default) { _ in
                
                self.chooseImagePicker(sourse: .photoLibrary)
                
            }
            
            photoLibery.setValue(photoImage, forKey: "image")
            photoLibery.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            acrionSheet.addAction(camera)
            acrionSheet.addAction(photoLibery)
            acrionSheet.addAction(cancel)
            
            present(acrionSheet, animated: true)
            
        } else {
            
            view.endEditing(true)
            
        }
        
    }
    
    func savePlace() {
        
        var image: UIImage
        
        if imageIsChenged {

            image = placeImage.image!

        } else {
 
            image = #imageLiteral(resourceName: "imagePlaceholder")

        }
        
        let imageData = image.pngData()
        let newPlace = Place(name: placeName.text!, location: placeLocation.text, type: placeType.text, imageData: imageData)
        
        if currentPlace != nil {
            
            try! realm.write {
                
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.name = newPlace.name
                currentPlace?.type = newPlace.type
                currentPlace?.location = newPlace.location
                
            }
            
        } else {
            
            StorageMeneger.saveObject(newPlace)
        
        }
        
        
    }
    
    private func setupEditScrean() {
        
        if currentPlace != nil {
            
            setupNavigationBar()
            
            imageIsChenged = true
            
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else { return }
            
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            placeType.text = currentPlace?.type
            
        }
        
    }
    
    private func setupNavigationBar() {
        
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
        
    }

}

extension NewPlaceTableViewController: UITextFieldDelegate {
    
    //Скрываем клавиатуру по нажатию на Done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    @objc private func textFieldChenged() {
        
        if placeName.text?.isEmpty == false {
            
            saveButton.isEnabled = true
            
        } else {
            
            saveButton.isEnabled = false
            
        }
        
    }
    
}

extension NewPlaceTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(sourse: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourse) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            present(imagePicker, animated: true)
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        
        imageIsChenged = true
        
        placeImage.clipsToBounds = true
        dismiss(animated: true)
        
    }
    
}
