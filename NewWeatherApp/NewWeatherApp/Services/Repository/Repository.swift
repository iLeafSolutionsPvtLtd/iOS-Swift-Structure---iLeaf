//
//  Repository.swift
//  NewWeatherApp
//
//  Created by Arun on 03/10/23.
//

import Foundation

protocol RepositoryType:HomeRepository{
    
}

public class Repository : RepositoryType {
    public let webservice: NetworkingClient
    
    init(webservice: NetworkingClient) {
        self.webservice = webservice
    }
}
