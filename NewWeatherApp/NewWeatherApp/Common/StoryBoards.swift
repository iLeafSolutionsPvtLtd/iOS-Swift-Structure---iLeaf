//
//  StoryBoards.swift
//  NewWeatherApp
//
//  Created by Arun on 05/10/23.
//

import Foundation
import UIKit

enum AppStoryboard: String {
    case main          = "Main"
    case toDo          = "ToDo"
    case launch        = "Launch"
}
protocol StoryboardViewController {
    static func instantiate(from storyboard: AppStoryboard) -> Self
}
extension StoryboardViewController where Self: UIViewController {
    static func instantiate(from storyboard: AppStoryboard) -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
