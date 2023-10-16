//
//  NsObjectExtension.swift
//  NewWeatherApp
//
//  Created by Arun on 05/10/23.
//

import Foundation
extension NSObject {
    class var nameOfClass: String {
    return NSStringFromClass(self).components(separatedBy: ".").last!
  }
}
