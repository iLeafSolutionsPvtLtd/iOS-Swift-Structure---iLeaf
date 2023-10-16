//
//  HomeViewModel.swift
//  NewWeatherApp
//
//  Created by Arun on 28/09/23.
//

import Foundation
import CoreLocation
import Combine
protocol HomeViewModelDelegate: AnyObject, BaseViewModelDelegateProrocol {
    func showLoader()
    func hideLoader()
    func showToDoList()
}

protocol HomeViewModelOutputType {
    // var temperature : AnyPublisher<String,Never> { get }
    var weatherString :  AnyPublisher<String,Never> { get }
    var thermometerString :  AnyPublisher<String,Never> { get }
    var timeString :  AnyPublisher<String,Never> { get }
    var place :  AnyPublisher<String,Never> { get }
    // var windSpeed :  AnyPublisher<Double,Never> { get }
    //  var windDirection :  AnyPublisher<Double,Never> { get }
    var currentWeather : AnyPublisher<WeatherDataResponse?,Never> { get }
}

protocol HomeViewModelInputType {
    func fetchLocation()
    func didPressToDo()
    func getWeatherReport(lat: String, long: String)
}
protocol HomeViewModelType {
    var outputs: HomeViewModelOutputType { get }
    var inputs: HomeViewModelInputType { get }
}

final class HomeViewModel:HomeViewModelType,HomeViewModelInputType,HomeViewModelOutputType {
   
    var outputs: HomeViewModelOutputType { self }
    
    var inputs: HomeViewModelInputType { self }
    
    var currentWeather: AnyPublisher<WeatherDataResponse?, Never>{
        currentWeatherRelay.eraseToAnyPublisher()
    }
    
    var weatherString: AnyPublisher<String, Never>{
        weatherRelay.eraseToAnyPublisher()
    }
    
    var thermometerString: AnyPublisher<String, Never>{
        thermoRelay.eraseToAnyPublisher()
    }
    //
    var timeString: AnyPublisher<String, Never>{
        timeRelay.eraseToAnyPublisher()
    }
    
    var place: AnyPublisher<String, Never>{
        placeRelay.eraseToAnyPublisher()
    }
   
    private var currentWeatherRelay = CurrentValueSubject<WeatherDataResponse?, Never>(nil)
    private var placeRelay = CurrentValueSubject<String,Never>("__")
    private var timeRelay = CurrentValueSubject<String,Never>("")
    private var weatherRelay = CurrentValueSubject<String,Never>(SymbolConstants.cloudFill)
    private var tempRelay = CurrentValueSubject<String,Never>("")
    private var thermoRelay = CurrentValueSubject<String,Never>("")
    
    private var latString = ""
    private var longString = ""
    //MARK: - Images Strings
 
    private var time = "00:00"
    var bindViewModelToController : (() -> ()) = {}
    var errorToController : ((String) -> ()) = {_ in }
    
    
    var repository: HomeRepository
    var delegate: HomeViewModelDelegate?
    var locationManger:LocationManager!
    init(repository:HomeRepository,locationManager:LocationManager){
        self.repository = repository
        self.locationManger = locationManager
    }
    
    internal func fetchLocation(){
        
        locationManger.getLocation { [weak self] location, error in
            
            if let error = error {
                self?.errorToController(error.localizedDescription)
                return
            }
            
            guard let location = location else {
                self?.errorToController("Unable to fetch location")
                return
            }
            self?.locationManger.getCurrentReverseGeoCodedLocation {
                
                [weak self] location, placemark, error in
                
                if let error {
                    self?.errorToController(error.localizedDescription)
                    return
                }
                
                guard let placemark else {
                    return
                }
                
                self?.placeRelay.send("\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)")
                
            }
            let latString = "\(location.coordinate.latitude)"
            let longString = "\(location.coordinate.longitude)"
            self?.getWeatherReport(lat: latString, long: longString)
        }
    }
    func didPressToDo() {
        self.delegate?.showToDoList()
    }
    
    func getWeatherReport(lat:String,long:String){
        DispatchQueue.main.async {
            self.delegate?.showLoader()
        }
        Task{
            do{
                let weatherDetails =  try await self.repository
                    .getWeatherDetails(request: 
         GetWeatherRequest(latitude: lat,longitude: long,current_weather: "true"))
                debugPrint(weatherDetails)
                await handleWeatherReport(weatherDetails)
            }
            catch{
                DispatchQueue.main.async {
                    self.delegate?.showLoader()
                    self.delegate?.showAlert(title: "Error", message: AppConstants.Messages.commonError)
                }
                
            }
        }
    }
    
    @MainActor
    func handleWeatherReport( _ weatherDetails : WeatherDataResponse){
        
        currentWeatherRelay.send(weatherDetails)
        let thermometerString = setTemperature(temp:
                                                weatherDetails.currentWeather?.temperature ?? 0).0
        let weatherString =  setTemperature(temp:
                                                weatherDetails.currentWeather?.temperature ?? 0).1
        thermoRelay.send("\(thermometerString)")
        weatherRelay.send(weatherString)
        let timeString = setTimeString(temp:weatherDetails.currentWeather?.time ?? "" )
        tempRelay.send(timeString)
        DispatchQueue.main.async {
            self.delegate?.hideLoader()
        }
    }
    
    private func setTemperature(temp:Double) -> (String,String) {
        var thermometerString = ""
        var weatherString = ""
        if temp < 0.0 {
            thermometerString = SymbolConstants.thermoSnow
            weatherString = SymbolConstants.snowFlake
        } else if temp < 10.0 {
            thermometerString = SymbolConstants.thermoLow
            weatherString = SymbolConstants.cloudFill
        } else if temp < 25.0 {
            thermometerString = SymbolConstants.thermoMedium
        } else {
            thermometerString = SymbolConstants.thermoHigh
            weatherString = SymbolConstants.sunMax
        }
        return (thermometerString,weatherString)
    }
    private func setTimeString(temp : String) -> String{
        
        let time = String(
            temp.replacingOccurrences(of: "-", with: ".")
                .replacingOccurrences(of: "T", with: " ").dropFirst(5)
        )
        guard let realTime = Int(time.prefix(8).suffix(2)) else {
            return ""
        }
        var timeString = ""
        if realTime < 6 {
            timeString = SymbolConstants.moonFill
        } else if realTime < 11 {
            timeString = SymbolConstants.sunHorizon
        } else if realTime > 18 && realTime < 22 {
            timeString = SymbolConstants.sunDust
        } else if realTime >= 22 {
            timeString = SymbolConstants.moonFill
        }
        return timeString
    }
    
}
