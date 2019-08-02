//
//  MainViewController.swift
//  AppTableViewLearn
//
//  Created by Иван Изюмкин on 23/05/2019.
//  Copyright © 2019 Иван Изюмкин. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {
    
    var orders: Results<Order>!
    
    let realm = try! Realm()
    
    
//    let num = realm.objects(Number).first

    override func viewDidLoad() {
        super.viewDidLoad()
        
        decorateTabBar()
        
        orders = realm.objects(Order.self)
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
    }
    
    private func decorateTabBar() {
        
        tabBarController?.tabBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tabBarController?.tabBar.layer.shadowRadius = 2
        tabBarController?.tabBar.layer.shadowOpacity = 0.1
        tabBarController?.tabBar.shadowImage = UIImage()
        tabBarController?.tabBar.backgroundImage = UIImage()
        
    }

    // MARK: - TableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return orders.isEmpty ? 0 : orders.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        let order = orders[indexPath.row]

        cell.orderName.text = order.coverName
        cell.fullName.text = order.fullName
        cell.orderNumber.text = order.orderNumber
        cell.status.text = "Статус: \(order.status)"
        cell.orderPrice.text = order.orderPrice
        cell.orderDate.text = order.orderDate

        return cell

    }
    
    // MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let order = orders[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Удалить") { (_, _ ) in
            
            StorageMeneger.deleteObject(order)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        
        return [deleteAction]
        
    }
    
     // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let order = orders[indexPath.row]
            let newPlaceVC = segue.destination as! NewOrderTableViewController
            newPlaceVC.currentOrder = order
            
        }
        
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newOrderVC = segue.source as? NewOrderTableViewController else { return }
        
        newOrderVC.saveOrder()
        tableView.reloadData()
        
    }

}
