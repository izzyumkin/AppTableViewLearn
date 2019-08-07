//
//  NewOrderTableViewController.swift
//  AppTableViewLearn
//
//  Created by Иван Изюмкин on 24/05/2019.
//  Copyright © 2019 Иван Изюмкин. All rights reserved.
//

import UIKit
import RealmSwift

class NewOrderTableViewController: UITableViewController {
    
    var currentOrder: Order?
    
    let realm = try! Realm()
    
    var imageIsChenged = false
    
    let pickerView = UIPickerView()
    let toolBar = UIToolbar()
    
    private let titles = ["Выбери тип обложки:",
                          "глянец, черная, серебро",
                          "глянец, черная, серебро, 2в1",
                          "ребристая, черная, серебро",
                          "ребристая, черная, серебро, 2в1"]
    private let costPrice1 = 390
    private let costPrice2 = 510
    private let costPrice3 = 370
    private let costPrice4 = 500
    
    private let carBrands = ["Выберите марку авто:",
                             "Nissan",
                             "Audi",
                             "Lada",
                             "Toyota",
                             "Hyundai",
                             "Kia",
                             "Renault",
                             "Volkswagen",
                             "Ford",
                             "Mitsubishi",
                             "Mercedes-Benz",
                             "Skoda",
                             "BMW"]
    
    private let deliveryMethods = ["Выберите способ доставки:",
                                   "Почтой России(Бандеролдь)",
                                   "Почтой России(Посылка)",
                                   "CDEK",
                                   "Самовывоз"]
    
    private let orderStatus = ["В процессе оформления",
                               "На изготовлении",
                               "Изготовлен, ожидает оплату",
                               "Оплачен, ожидает отправку",
                               "Отправлен, клиент ждет трек",
                               "Выполнен",
                               "Отменен"]
    
    var selectedPriorityCover: String?
    var selectedPriorityCarBrends: String?
    var selectedPriorityDeliveryMethods: String?
    var selectedPriorityOrderStatus: String? = "В процессе оформления"
    var selectedCostPrice: Int?
    var statusColor = "Green"
    
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
    @IBOutlet weak var statusButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDate()
        createPickerView()
        dissmisPickerView()
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        coverName.addTarget(self, action: #selector(textFieldChenged), for: .editingDidEnd)
        setupEditScrean()
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
    }
    
    // Закрывает экран
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true)
        
    }
    
    @IBAction func setStatus(_ sender: UIButton) {

//        let dummy = UITextField(frame: CGRect.zero)
//        view.addSubview(dummy)
//
//        dummy.inputView = pickerView
//        dummy.inputAccessoryView = toolBar
//        dummy.becomeFirstResponder()
        
        var actions: [(String, UIAlertAction.Style)] = []
        actions.append(("В процессе оформления", UIAlertAction.Style.default))
        actions.append(("На изготовлении", UIAlertAction.Style.default))
        actions.append(("Изготовлен, ожидает оплату", UIAlertAction.Style.default))
        actions.append(("Оплачен, ожидает отправку", UIAlertAction.Style.default))
        actions.append(("Отправлен, клиент ждет трек", UIAlertAction.Style.default))
        actions.append(("Выполнен", UIAlertAction.Style.default))
        actions.append(("Отменен", UIAlertAction.Style.default))
        actions.append(("Отмена", UIAlertAction.Style.cancel))
        
        //self = ViewController
        Alerts.showActionSheet(viewController: self, title: "Выберите статус заказа:", message: nil, actions: actions) { (index) in
            
            if index != 7 {
                self.selectedPriorityOrderStatus = self.orderStatus[index]
            }
            
            self.statusButton.setTitle(self.selectedPriorityOrderStatus, for: .normal)

            switch index {

            case 1:
                self.statusColor = "Red"
            case 2:
                self.statusColor = "Yellow"
            case 3:
                self.statusColor = "Red"
                self.setsState()
            case 4:
                self.statusColor = "Yellow"
                self.setsState()
            case 5:
                self.statusColor = "Blue"
                self.setsState()
            case 6:
                self.statusColor = "Orange"
                self.minusState()
            case 7:
                self.statusButton.setTitle(self.statusButton.titleLabel?.text, for: .normal)
            default:
                break
            }
            
        }
        
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Вызываем AlertController по нажатию на imageData с возможностью выбора способа загрузки фото
        if imageData.isHighlighted {

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
        
        var image: UIImage?
        
        if imageIsChenged {

            image = imageData.image!

        } else {
 
            image = #imageLiteral(resourceName: "picture (1)")

        }
        
        let num = realm.objects(Number.self).first?.totalNumberOrders
        let number = num! + 1
        
        let status = statusButton.titleLabel?.text

        let imageData = image?.pngData()
        let newOrder = Order(coverName: coverName.text!, coverCircle: coverCircle.text!, coverRectangle: coverRectangle.text!, connection: connection.text!, fullName: fullName.text!, deliveryMethod: deliveryMethod.text!, address: address.text!, postcode: postcode.text!, comment: comment.text!, imageData: imageData, orderDate: orderDate.text!, orderNumber: orderNumber.text!, status: selectedPriorityOrderStatus!, orderPrice: orderPrice.text!, statusColor: statusColor)
        
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
                currentOrder?.status = status!
                currentOrder?.orderPrice = newOrder.orderPrice
                currentOrder?.statusColor = newOrder.statusColor
                
            }
            
        } else {
            
            StorageMeneger.saveObject(newOrder)
            
            try! realm.write {
                
                realm.objects(Number.self).first?.totalNumberOrders = number
                
            }
        
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
            statusButton.setTitle(currentOrder?.status, for: .normal)
            orderPrice.text = currentOrder?.orderPrice
            
        }
        
    }
    
    private func setupNavigationBar() {
        
        navigationItem.leftBarButtonItem = nil
        
        if currentOrder?.fullName != "" {
            
            title = currentOrder?.fullName
            
        } else {
            
            title = "Заказ \(currentOrder?.orderNumber ?? "")"
            
        }
        
        saveButton.isEnabled = true
        
    }
    
    // MARK: - PickerView
    private func createPickerView() {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        coverName.inputView = pickerView
        coverCircle.inputView = pickerView
        deliveryMethod.inputView = pickerView
        
    }
    
    private func dissmisPickerView() {
        
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(dissmisKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        coverName.inputAccessoryView = toolBar
        coverCircle.inputAccessoryView = toolBar
        deliveryMethod.inputAccessoryView = toolBar
        postcode.inputAccessoryView = toolBar
        
    }
    
    @objc private func dissmisKeyboard() {
        
        view.endEditing(true)
        
    }
    
    // MARK: - SetDate, Number
    private func setDate() {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM, yyyy (HH:mm)"
        let result = formatter.string(from: date)
        orderDate.text = result
        
        let num = realm.objects(Number.self).first?.totalNumberOrders
        let number = num! + 1
        
        orderNumber.text = "№\(number)"
        
    }

}

// MARK: - Скрываем клавиатуру по нажатию на Done
extension NewOrderTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    @objc private func textFieldChenged() {
        
        if coverName.text != "" {
            
            saveButton.isEnabled = true
            
        } else {
            
            saveButton.isEnabled = false
            
        }
        
    }
    
}

// MARK: - UIImagePickerController
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

// MARK: - UIPickerView
extension NewOrderTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if coverName.isEditing {
            
            return titles.count
            
        } else if coverCircle.isEditing {
            
            return carBrands.count
            
        } else {
            
           return deliveryMethods.count
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if coverName.isEditing {
            
            return titles[row]
            
        } else if coverCircle.isEditing {
            
            return carBrands[row]
            
        } else {
            
            return deliveryMethods[row]
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if coverName.isEditing {
            
            switch row {
                
            case 0:
                coverName.text = ""
                orderPrice.text = "0₽"
            case 1:
                selectedPriorityCover = titles[row]
                coverName.text = "Обложка для автодокументов \(selectedPriorityCover!)"
                orderPrice.text = "1190₽"
                selectedCostPrice = costPrice1
            case 2:
                selectedPriorityCover = titles[row]
                coverName.text = "Обложка для автодокументов \(selectedPriorityCover!)"
                orderPrice.text = "1490₽"
                selectedCostPrice = costPrice2
            case 3:
                selectedPriorityCover = titles[row]
                coverName.text = "Обложка для автодокументов \(selectedPriorityCover!)"
                orderPrice.text = "1490₽"
                selectedCostPrice = costPrice3
            case 4:
                selectedPriorityCover = titles[row]
                coverName.text = "Обложка для автодокументов \(selectedPriorityCover!)"
                orderPrice.text = "1690₽"
                selectedCostPrice = costPrice4
            default:
                break
                
            }
            
        } else if coverCircle.isEditing {
            
            selectedPriorityCarBrends = carBrands[row]
            coverCircle.text = selectedPriorityCarBrends
            
        } else if deliveryMethod.isEditing {
            
            selectedPriorityDeliveryMethods = deliveryMethods[row]
            deliveryMethod.text = selectedPriorityDeliveryMethods
            
        } else {
            
            return
            
        }
        
    }
    
    private func setsState() {
        
        if selectedCostPrice != nil {
            
            let price = orderPrice.text
            let priceInt = Int(price!.dropLast())
            
            let state = realm.objects(State.self).first
            let progress = ((priceInt! - selectedCostPrice!) * 20) / 100
            
            try! realm.write {
                state?.revenue += priceInt!
                state?.costPrice += selectedCostPrice!
                state?.progress += progress
                state?.costs += selectedCostPrice! + progress
                state?.profit += priceInt! - selectedCostPrice! - progress
            }
            
            NotificationCenter.default.post(name: .reload, object: nil)
            
        }
        
    }
    
    private func minusState() {
        
        if selectedCostPrice != nil {
            
            let price = orderPrice.text
            let priceInt = Int(price!.dropLast())
            
            let state = realm.objects(State.self).first
            let progress = ((priceInt! - selectedCostPrice!) * 20) / 100
            
            try! realm.write {
                state?.revenue -= priceInt!
                state?.costPrice -= selectedCostPrice!
                state?.progress -= progress
                state?.costs -= selectedCostPrice! + progress
                state?.profit -= priceInt! - selectedCostPrice! - progress
            }
            
            NotificationCenter.default.post(name: .reload, object: nil)
            
        }
        
    }
    
}
