//
//  GetWeatherRequest.swift
//  NewWeatherApp
//
//  Created by Arun on 03/10/23.
//

import Foundation
struct GetWeatherRequest:Codable{
    var latitude:String?
    var longitude:String?
    var current_weather:String? = "true"
}
