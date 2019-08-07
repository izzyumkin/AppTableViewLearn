//
//  AlertActionSheet.swift
//  AppTableViewLearn
//
//  Created by Иван Изюмкин on 06/08/2019.
//  Copyright © 2019 Иван Изюмкин. All rights reserved.
//

import UIKit

class Alerts {
    
    
    static func showActionSheet(viewController: UIViewController, title: String, message: String?, actions: [(String, UIAlertAction.Style)], completion: @escaping (_ index: Int) -> Void) {
        
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for (index, (title, style)) in actions.enumerated() {
            
            let alertAction = UIAlertAction(title: title, style: style) { (_) in
                completion(index)
                
            }
            
            alertViewController.addAction(alertAction)
        }
        
        viewController.present(alertViewController, animated: true, completion: nil)
        
    }
    
}
