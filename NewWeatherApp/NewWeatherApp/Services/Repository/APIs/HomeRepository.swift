//
//  HomeRepository.swift
//  NewWeatherApp
//
//  Created by Arun on 03/10/23.
//

import Foundation
protocol HomeRepository{
    func getWeatherDetails(request:GetWeatherRequest) async throws -> WeatherDataResponse
}

extension Repository : HomeRepository {
    func getWeatherDetails(request:GetWeatherRequest) async throws -> WeatherDataResponse{
        try await webservice.get(URLConstants.getWeather,params: ["latitude":"\(request.latitude!)","longitude":"\(request.longitude!)","current_weather":"true"])
    }
}

#if !RELEASE

public class HomeRepositoryFake : HomeRepository {
    
    var weatherDataResponse = WeatherDataResponse.fake()
    var returnException = false
    var returnNetworkException = false
    
    func getWeatherDetails(request: GetWeatherRequest) async throws -> WeatherDataResponse {
        try await Task.sleep(nanoseconds: UInt64.random(in: 1 ... 5) * 1000000)
        if returnException {
            throw RuntimeError(.fake())
        }
        if returnNetworkException {
            throw NetworkingError(errorCode: 500)
        }

        return weatherDataResponse
    }
    
    
}

#endif
