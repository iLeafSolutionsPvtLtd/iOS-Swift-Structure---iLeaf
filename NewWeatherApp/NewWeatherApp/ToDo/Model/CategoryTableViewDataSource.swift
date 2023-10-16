//
//  CategoryTableViewDataSource.swift
//  NewWeatherApp
//
//  Created by Arun on 06/10/23.
//

import Foundation
import UIKit

protocol CategoryDataSourceDelegate: AnyObject {
    func didSelectItem(index:Int)
    func deleteCategory(at index : Int)
}

protocol CategoryDataSourceType: AnyObject {
    var delegate: CategoryDataSourceDelegate? { get set }
}

final class CategoryDataSource : NSObject,UITableViewDataSource,UITableViewDelegate, CategoryCellDelegate{
  
    
    weak var tableView: UITableView?
   
    var rows = [Category]() {
        didSet {
            tableView?.reloadData()
        }
    }
 
    var delegate: CategoryDataSourceDelegate?

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) 
    -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) 
    -> UITableViewCell {
        let item = rows[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CategoryCell.nameOfClass,
                for: indexPath) as? CategoryCell else {
                return UITableViewCell()
            }
            cell.viewModel = CategoryCellViewModel(title: item.name ?? "",
            isCompleted: item.done)
            cell.viewModel.delegate = self
            return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            delegate?.didSelectItem(index: indexPath.row)
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "delete") { [weak self] (action, view, completionHandler) in
            self?.delegate?.deleteCategory(at: indexPath.row)
            completionHandler(true)
        }
        action.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [action])
    }
}
