//
//  AppConstants.swift
//  NewWeatherApp
//
//  Created by Arun on 03/10/23.
//

import Foundation
struct AppConstants {

    struct Messages{
        
        static let commonError : String = "Something went wrong!"
        static let dataFetchError : String = "Data fetching failed!"
        static let dataSaveError : String = "Could not save data!"
    }
}
struct URLConstants{
    static let getWeather : String = "/forecast"
    static let BASEURL : String = "https://api.open-meteo.com/v1"
}
