//
//  NewPlaceTableViewController.swift
//  AppTableViewLearn
//
//  Created by Иван Изюмкин on 24/05/2019.
//  Copyright © 2019 Иван Изюмкин. All rights reserved.
//

import UIKit

class NewPlaceTableViewController: UITableViewController {
    
    var newPlace: Place?
    var imageIsChenged = false
    
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
    
    func saveNewPlaces() {
        
        var image: UIImage
        
        if imageIsChenged {
            
            image = placeImage.image!
            
        } else {
            
            image = #imageLiteral(resourceName: "imagePlaceholder")
            
        }
        
        newPlace = Place(name: placeName.text!, location: placeLocation.text, type: placeType.text, image: image, refactorImage: nil)
        
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
