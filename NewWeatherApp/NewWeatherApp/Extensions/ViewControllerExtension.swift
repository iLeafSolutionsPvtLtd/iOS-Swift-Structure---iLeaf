//
//  ViewController+Extension.swift
//  NewWeatherApp
//
//  Created by Arun on 28/09/23.
//

import UIKit
import Foundation

extension UIViewController {
    private class func instantiateControllerInStoryboard<T: UIViewController>(_ storyboard: UIStoryboard, identifier: String) -> T {
        guard let controller = storyboard.instantiateViewController(withIdentifier: identifier) as? T else { return T() }
        return controller
    }
    class func controllerFromStoryboard(_ storyboard: AppStoryboard) -> Self {
        return controllerInStoryboard(UIStoryboard(name: storyboard.rawValue, bundle: nil), identifier: nameOfClass)
    }
    class func controllerInStoryboard(_ storyboard: UIStoryboard, identifier: String) -> Self {
        return instantiateControllerInStoryboard(storyboard, identifier: identifier)
    }
    class func controllerInStoryboard(_ storyboard: UIStoryboard) -> Self {
        return controllerInStoryboard(storyboard, identifier: nameOfClass)
    }
}

