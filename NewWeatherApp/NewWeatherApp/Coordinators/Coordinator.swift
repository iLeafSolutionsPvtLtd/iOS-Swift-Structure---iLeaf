//
//  ApplicationCoordinator.swift
//  NewWeatherApp
//
//  Created by Arun on 29/09/23.
//

import Foundation
import UIKit

public protocol Coordinator:AnyObject{
    
}
enum PresentationStyle {
    case modal(navControllerType: NavControllerType, animated: Bool)
    case show(animated: Bool)
    case cleanShow(animated: Bool)
}

extension PresentationStyle {
    enum NavControllerType {
        case none
        case navBarHidden
        case navBarVisible
    }
}
extension Coordinator{
    func present(_ viewController: UIViewController,
                 style: PresentationStyle,
                 on context: UIViewController) {

        switch style {
        case let .modal(_, isAnimated):
            DispatchQueue.main.async {
                context.present(viewController, animated: isAnimated)
            }

        case let .show(isAnimated):
            if let navigationController = context as? UINavigationController {
                if navigationController.viewControllers.isEmpty {
                    DispatchQueue.main.async {
                        navigationController.setViewControllers([viewController],
                                                                animated: isAnimated)
                    }
                } else {
                    DispatchQueue.main.async {
                        navigationController.pushViewController(viewController,
                                                                animated: isAnimated)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    context.show(viewController, sender: self)
                }
            }
        case let .cleanShow(isAnimated):
            if let navigationController = context as? UINavigationController {
                DispatchQueue.main.async {
                    navigationController.setViewControllers([viewController],
                                                            animated: isAnimated)
                }
            } else {
                DispatchQueue.main.async {
                    context.show(viewController, sender: self)
                }
            }
        }
    }
}
