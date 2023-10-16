//
//  GradientExtension.swift
//  NewWeatherApp
//
//  Created by Arun on 28/09/23.
//

import Foundation
import UIKit

extension CAGradientLayer {
    static func gradientLayer(in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = colors()
        layer.frame = frame
        return layer
    }
    
    private static func colors() -> [CGColor] {
        let beginColor: CGColor = UIColor(named: "gradientBeginColor")!.cgColor
        let endColor: CGColor = UIColor(named: "gradientEndColor")!.cgColor
        
        return [beginColor, endColor]
    }
}
