//
//  UITableView+Ext.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 03.03.2025.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String.init(describing: self)
    }
}


extension UITableView {
    func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }

    func dequeueCell<Cell: UITableViewCell>(_ indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as? Cell
        else { fatalError("Fatal error for cell at \(indexPath)") }

        return cell
    }
}
