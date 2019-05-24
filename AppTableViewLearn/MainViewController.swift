//
//  MainViewController.swift
//  AppTableViewLearn
//
//  Created by Иван Изюмкин on 23/05/2019.
//  Copyright © 2019 Иван Изюмкин. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    private let establishments = ["Бургерная Burger Heroes", "«Юность» в «ЭМА»", "Ресторан «Клёво»", "The Hummus", "Кафе «Любовь Пирогова»", "Кафе «Дагестанская лавка»", "Ресторан La Pasta", "Кафе Mary & Dogs", "Кафе «Кусаки»", "Ресторан «Северяне»", "Ресторан «Латинский квартал»"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 
        
        return establishments.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        cell.nameLabel.text = establishments[indexPath.row]
        cell.imageOfPlace.image = UIImage(named: establishments[indexPath.row])
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.height / 2
        cell.imageOfPlace.clipsToBounds = true

        return cell
        
    }

    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 85.0
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
