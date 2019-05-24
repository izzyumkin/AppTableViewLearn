//
//  NewPlaceTableViewController.swift
//  AppTableViewLearn
//
//  Created by Иван Изюмкин on 24/05/2019.
//  Copyright © 2019 Иван Изюмкин. All rights reserved.
//

import UIKit

class NewPlaceTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let acrionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                
                self.chooseImagePicker(sourse: .camera)
                
            }
            
            let photoLibery = UIAlertAction(title: "Photo", style: .default) { _ in
                
                self.chooseImagePicker(sourse: .photoLibrary)
                
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            acrionSheet.addAction(camera)
            acrionSheet.addAction(photoLibery)
            acrionSheet.addAction(cancel)
            
            present(acrionSheet, animated: true)
            
        } else {
            
            view.endEditing(true)
            
        }
        
    }

}

extension NewPlaceTableViewController: UITextFieldDelegate {
    
    //Скрываем клавиатуру по нажатию на Done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
}

extension NewPlaceTableViewController {
    
    func chooseImagePicker(sourse: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourse) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            present(imagePicker, animated: true)
            
        }
        
    }
    
}
