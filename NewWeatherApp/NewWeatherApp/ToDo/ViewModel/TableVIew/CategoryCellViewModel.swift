//
//  CategoryCellViewModel.swift
//  NewWeatherApp
//
//  Created by Arun on 06/10/23.
//

import Foundation
import Combine

protocol CategoryCellDelegate{
    
}
protocol CategoryCellInputType{
 
}

protocol CategoryCellOutputType{
    var title: AnyPublisher<String, Never> { get }
    var isCompleted: AnyPublisher<Bool , Never> { get }
}

protocol CategoryCellViewModelType{
    var outputs: CategoryCellOutputType {get}
    var input: CategoryCellInputType {get}
    var delegate: CategoryCellDelegate? {get set}
}

final class CategoryCellViewModel:CategoryCellViewModelType,CategoryCellOutputType,CategoryCellInputType{
    
    var outputs: CategoryCellOutputType { self }
    
    var input: CategoryCellInputType { self }
    
    var delegate: CategoryCellDelegate?
    
    var isCompleted: AnyPublisher<Bool, Never>
    
    var title: AnyPublisher<String, Never>
    
    init(title:String,isCompleted:Bool){
        self.title = Just(title).eraseToAnyPublisher()
        self.isCompleted = Just(isCompleted).eraseToAnyPublisher()
    }
}
