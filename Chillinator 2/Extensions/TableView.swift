//
//  TableView.swift
//  Chillinator 2
//
//  Created by Narek Stepanyan on 03.07.2020.
//  Copyright © 2020 NRKK.DEV. All rights reserved.
//

import UIKit


public extension UITableView {
    
    /// Получить ячейку для tableView с конкретным классом
    func cell<T: UITableViewCell>(forClass cellClass: T.Type, reuseIdentifier: String = "") -> T {
        let className = String(describing: cellClass)
        let reuseIdentifier = className + reuseIdentifier
        var isRegistered = false
        
        while true {
            /// Если есть доступная ячейка для переиспользования - вернуть её
            if let cell = self.dequeueReusableCell(withIdentifier: reuseIdentifier) as? T {
                cell.selectionStyle = .none
                return cell
            }
            
            /// Зарегистрировать новую ячейку в tableView
            if isRegistered { return T() }
            let bundle = Bundle(for: cellClass)
            if bundle.path(forResource: className, ofType: "nib") != nil {
                register(UINib(nibName: className, bundle: bundle), forCellReuseIdentifier: reuseIdentifier)
            } else {
                register(cellClass, forCellReuseIdentifier: reuseIdentifier)
            }
            isRegistered = true
        }
    }
}
