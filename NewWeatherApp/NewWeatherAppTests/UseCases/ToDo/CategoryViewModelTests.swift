//
//  CategoryViewModelTests.swift
//  NewWeatherAppTests
//
//  Created by Arun on 11/10/23.
//

import XCTest
import Combine
@testable import NewWeatherApp

final class CategoryViewModelTests: XCTestCase {
    var viewModel:CategoryViewModel!
    var coreDataStore:CoreDataStore!
    private var callBackCount = 0
    override func setUp() {
        coreDataStore = CoreDataStore(name: "NewWeatherApp", in: .inMemory)
        viewModel = CategoryViewModel(coreDataStore: coreDataStore)
    }
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testAddCategory() throws {
        viewModel.inputs.didPressAdd(categoryName: "Test")
        XCTAssertEqual(viewModel.sectionsRelay.value.count, 1)
        XCTAssertEqual(viewModel.sectionsRelay.value[0].name, "Test")
    }
    func testFetchCategories() throws{
        viewModel.inputs.didPressAdd(categoryName: "Test")
        viewModel.inputs.loadCategories()
        XCTAssertEqual(viewModel.sectionsRelay.value.count, 1)
        XCTAssertEqual(viewModel.sectionsRelay.value[0].name, "Test")
       
    }
    func testDeleteCategory() throws{
        viewModel.inputs.didPressAdd(categoryName: "Test")
        viewModel.deleteCategory(at: 0)
        viewModel.inputs.loadCategories()
        XCTAssertEqual(viewModel.sectionsRelay.value.count, 0)
    }
    func testCategoryDone() throws {
        viewModel.inputs.didPressAdd(categoryName: "Test")
        viewModel.didSelectItem(index: 0)
        viewModel.inputs.loadCategories()
        XCTAssertEqual(viewModel.sectionsRelay.value[0].done, true)
    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
