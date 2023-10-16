//
//  TodoCordinator.swift
//  NewWeatherApp
//
//  Created by Arun on 05/10/23.
//

import Foundation
import UIKit

protocol ToDoCoordinatorDelegate:AnyObject,BaseCoordinatorDelegateProrocol{
    func showLoader()
    func hideLoader()
    func showToDoList()
    func goBack()
}
protocol ToDoCoordinatorType: Coordinator{

    func start(on context: UINavigationController,
               style: PresentationStyle)
    var delegate: ToDoCoordinatorDelegate? { get set }
}
final class TodCoordinator : ToDoCoordinatorType {
    var delegate: ToDoCoordinatorDelegate?
    var context: UINavigationController!
    var viewModel: CategoryViewModel!
    
    func start(on context: UINavigationController, style: PresentationStyle) {
        self.context = context
        let viewController: CategoryVC = CategoryVC.controllerFromStoryboard(.toDo)
        viewModel = CategoryViewModel(coreDataStore: 
        CoreDataStore(name: "NewWeatherApp", in: .persistent))
        viewModel.delegate = self
        viewController.viewModel = viewModel
        present(viewController, style: style, on: context)
    }
}
extension TodCoordinator:CategoryViewModelDelegate{
    func showLoader() {
        
    }
    
    func hideLoader() {
        
    }
    
    func showAlert(title: String?, message: String) {
        delegate?.showAlert(title: title, message: message)
    }
    
    func showResultCodeError(_ code: Int) {
        
    }
    
    
}
