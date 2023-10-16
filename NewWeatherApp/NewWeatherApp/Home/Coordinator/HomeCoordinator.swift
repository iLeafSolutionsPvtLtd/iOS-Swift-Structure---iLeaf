//
//  HomeCoordinator.swift
//  NewWeatherApp
//
//  Created by Arun on 03/10/23.
//

import Foundation
import UIKit

protocol HomeCoordinatorDelegate:AnyObject,BaseCoordinatorDelegateProrocol{
    func showLoader()
    func hideLoader()
    func showToDoList()
    func goBack()
}
protocol HomeCoordinatorType: Coordinator{

    func start(on context: UINavigationController,
               style: PresentationStyle,
               repository: HomeRepository)
    var delegate: HomeCoordinatorDelegate? { get set }
}
final class HomeCoordinator : HomeCoordinatorType {
    var delegate: HomeCoordinatorDelegate?
    var context: UINavigationController!
    var viewModel: HomeViewModel!
    
    func start(on context: UINavigationController, style: PresentationStyle, repository: HomeRepository) {
        self.context = context
        let viewController: HomeVC = HomeVC.controllerFromStoryboard(.main)
        viewModel = HomeViewModel(repository: repository, locationManager: LocationManager())
        viewModel.delegate = self
        viewController.viewModel = viewModel
        
        present(viewController, style: style, on: context)
    }
}
extension HomeCoordinator : HomeViewModelDelegate {
    func showAlert(title: String?, message: String) {
        delegate?.showAlert(title: title, message: message)
    }
    
    func showResultCodeError(_ code: Int) {
        delegate?.showResultCodeError(code)
    }
    
    func showLoader() {
        delegate?.showLoader()
    }
    
    func hideLoader() {
        delegate?.hideLoader()
    }
    func showToDoList() {
        delegate?.showToDoList()
    }
    func goBack() {
        delegate?.goBack()
    }
}
