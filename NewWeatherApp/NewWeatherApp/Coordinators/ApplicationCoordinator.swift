//
//  ApplicationCoordinator.swift
//  NewWeatherApp
//
//  Created by Arun on 29/09/23.
//

import Foundation
import UIKit

protocol AppFlowCoordinatorDelegate:AnyObject{
    
}

protocol AppFlowCoordinatorType:Coordinator{
    func start(on context: UINavigationController)
}

class AppFlowCoordinator:NSObject,AppFlowCoordinatorType{
    
    var context: UINavigationController!
    var repository: RepositoryType
    
    
    init(repository: RepositoryType,context:UINavigationController) {
        self.repository = repository
        self.context = context
    }
    
    func start(on context: UINavigationController) {
        let homeCoordinator = HomeCoordinator()
        homeCoordinator.delegate = self
        homeCoordinator.start(on: context, style: .show(animated: false), repository: repository)
    }
    
}
extension AppFlowCoordinator:HomeCoordinatorDelegate{
    func showLoader() {
        PDIndicator.show()
    }
    
    func hideLoader() {
        PDIndicator.dismiss()
    }
    
  
    func goBack() {
        
    }
    
    func showAlert(title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        context.present(alert, animated: true, completion: nil)
    }
    
    func showResultCodeError(_ code: Int) {
        
    }
    
  
}
extension AppFlowCoordinator:ToDoCoordinatorDelegate{
    
    func showToDoList() {
      let coordinator = TodCoordinator()
      coordinator.delegate = self
      coordinator.start(on: self.context, style: .show(animated: false))
  }
  
  
}
