//
//  NewOrderTableViewController.swift
//  AppTableViewLearn
//
//  Created by Иван Изюмкин on 24/05/2019.
//  Copyright © 2019 Иван Изюмкин. All rights reserved.
//

import UIKit

class NewOrderTableViewController: UITableViewController {
    
    var currentOrder: Order?
    var imageIsChenged = false
    
    // MARK: - Outlets
    
    // Товары
    @IBOutlet weak var coverName: UITextField!
    @IBOutlet weak var coverCircle: UITextField!
    @IBOutlet weak var coverRectangle: UITextField!
    
    // Данные для доставки
    @IBOutlet weak var connection: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var deliveryMethod: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var postcode: UITextField!
    
    // Дополнительные данные
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var imageData: UIImageView!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderNumber: UILabel!
    let timeStatus = "В процессе"
    @IBOutlet weak var orderPrice: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        coverName.addTarget(self, action: #selector(textFieldChenged), for: .editingChanged)
        setupEditScrean()
        
        
    }
    
    // Закрывает окно
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true)
        
        
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Вызываем AlertController по нажатию на imageData с возможностью выбора способа загрузки фото
        if imageData.isHighlighted {

            // Создаем AlertController
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
    
    // MARK: - Save
    
    func saveOrder() {
        
        var image: UIImage
        
        if imageIsChenged {

            image = imageData.image!

        } else {
 
            image = #imageLiteral(resourceName: "imagePlaceholder")

        }
        
        let imageData = image.pngData()
        let newOrder = Order(coverName: coverName.text!, coverCircle: coverCircle.text!, coverRectangle: coverRectangle.text!, connection: connection.text!, fullName: fullName.text!, deliveryMethod: deliveryMethod.text!, address: address.text!, postcode: postcode.text!, comment: comment.text!, imageData: imageData, orderDate: orderDate.text!, orderNumber: orderNumber.text!, status: timeStatus, orderPrice: orderPrice.text!)
        
        if currentOrder != nil {
            
            try! realm.write {
                
                currentOrder?.coverName = newOrder.coverName
                currentOrder?.coverCircle = newOrder.coverCircle
                currentOrder?.coverRectangle = newOrder.coverRectangle
                
                currentOrder?.connection = newOrder.connection
                currentOrder?.fullName = newOrder.fullName
                currentOrder?.deliveryMethod = newOrder.deliveryMethod
                currentOrder?.address = newOrder.address
                currentOrder?.postcode = newOrder.postcode
                
                currentOrder?.comment = newOrder.comment
                currentOrder?.imageData = newOrder.imageData
                currentOrder?.status = newOrder.status
                currentOrder?.orderPrice = newOrder.orderPrice
                
            }
            
        } else {
            
            StorageMeneger.saveObject(newOrder)
        
        }
        
        
    }
    
    // MARK: - EditScrean
    
    private func setupEditScrean() {
        
        if currentOrder != nil {
            
            setupNavigationBar()
            
            imageIsChenged = true
            
            guard let data = currentOrder?.imageData, let image = UIImage(data: data) else { return }
            
            imageData.image = image
            imageData.contentMode = .scaleAspectFill
            coverName.text  = currentOrder?.coverName
            coverCircle.text  = currentOrder?.coverCircle
            coverRectangle.text  = currentOrder?.coverRectangle
            
            connection.text  = currentOrder?.connection
            fullName.text  = currentOrder?.fullName
            deliveryMethod.text  = currentOrder?.deliveryMethod
            address.text  = currentOrder?.address
            postcode.text  = currentOrder?.postcode
            
            comment.text  = currentOrder?.comment
            orderDate.text = currentOrder?.orderDate
            orderNumber.text = currentOrder?.orderNumber
            //Добавь статус!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            orderPrice.text = currentOrder?.orderPrice
            
            
        }
        
    }
    
    private func setupNavigationBar() {
        
        navigationItem.leftBarButtonItem = nil
        title = currentOrder?.fullName
        saveButton.isEnabled = true
        
    }

}

extension NewOrderTableViewController: UITextFieldDelegate {
    
    //Скрываем клавиатуру по нажатию на Done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    @objc private func textFieldChenged() {
        
        if coverName.text?.isEmpty == false {
            
            saveButton.isEnabled = true
            
        } else {
            
            saveButton.isEnabled = false
            
        }
        
    }
    
}

extension NewOrderTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
        imageData.image = info[.editedImage] as? UIImage
        imageData.contentMode = .scaleAspectFill
        
        imageIsChenged = true
        
        imageData.clipsToBounds = true
        dismiss(animated: true)
        
    }
    
}
