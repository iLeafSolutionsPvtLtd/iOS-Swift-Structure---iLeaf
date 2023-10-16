//
//  ToDoViewModel.swift
//  NewWeatherApp
//
//  Created by Arun on 05/10/23.
//

import Foundation
import Combine
import UIKit
import CoreData

protocol CategoryViewModelDelegate:AnyObject,BaseViewModelDelegateProrocol{
    
}
protocol CategoryViewModelOutputType {
    var tableDataSource: AnyPublisher<CategoryDataSource, Never> { get }
}
protocol CategoryViewModelInputType{
    func didPressAdd(categoryName:String)
    func loadCategories()
    
}
protocol CategoryViewModelType{
    var outuputs: CategoryViewModelOutputType { get }
    var inputs: CategoryViewModelInputType { get }
}

final class CategoryViewModel:CategoryViewModelType,CategoryViewModelInputType,CategoryViewModelOutputType,CategoryDataSourceDelegate {
 
    var tableDataSource: AnyPublisher<CategoryDataSource, Never>
    var outuputs: CategoryViewModelOutputType { self }
    var inputs: CategoryViewModelInputType { self }
    var delegate : CategoryViewModelDelegate!
    private var titleSubscription: AnyCancellable?
        private var summarySubscription: AnyCancellable?
    var categories = [Category]()
    let coreDataStore: CoreDataStoring!
    var cancellables: [AnyCancellable] = []
    let sectionsRelay = CurrentValueSubject<[Category], Never>([])
    //MARK: - Data manipulation methods
    
    
    init(coreDataStore:CoreDataStoring){
        self.coreDataStore = coreDataStore
        let dataSource = CategoryDataSource()

        sectionsRelay
            .receive(on: DispatchQueue.main)
            .assign(to: \.rows, on: dataSource)
            .store(in: &cancellables)
        tableDataSource = Just(dataSource).eraseToAnyPublisher()
        
        dataSource.delegate = self
    }
    
    func loadCategories(){
        coreDataStore
            .publicher(fetch: Category.fetchRequest())
            .sink { completion in
                if case .failure(_) = completion {
                    self.delegate.showAlert(title: "Error", message: AppConstants.Messages.dataFetchError)
                }
            } receiveValue: { categories in
                self.categories = categories
                self.sectionsRelay.send(categories)
            }
            .store(in: &cancellables)
    }
    func didPressAdd(categoryName:String) {
        let action: Action = {
            let newCategory: Category = self.coreDataStore.createEntity()
            newCategory.name = categoryName
            newCategory.done = false
            newCategory.index = Int16(self.categories.count)
            self.categories.append(newCategory)
        }
        
        coreDataStore
            .publicher(save: action)
            .sink { completion in
                if case .failure(_) = completion {
                    self.delegate.showAlert(title: "Error", message: AppConstants.Messages.dataSaveError)
                }
            } receiveValue: { success in
                if success {
                   // self.categories.append(newCategory)
                    print("add success")
                    self.sectionsRelay.send(self.categories)
                }
            }
            .store(in: &cancellables)
    }
    
    func didSelectItem(index: Int) {
        categories[index].done.toggle()
        self.sectionsRelay.send(self.categories)
        saveCategories()
    }

    func saveCategories(){
        do {
         //   try context.save()
           try coreDataStore.viewContext.save()
        } catch {
            self.delegate.showAlert(title: "Error", message: AppConstants.Messages.dataSaveError)
        }
    }
  
    func deleteCategory(at index: Int){
        coreDataStore.viewContext.delete(categories[index])
        categories.remove(at: index)
        self.sectionsRelay.send(self.categories)
        saveCategories()
    }
  
    
}
