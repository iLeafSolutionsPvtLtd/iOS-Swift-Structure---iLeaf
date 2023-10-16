//
//  HomeViewModelTests.swift
//  NewWeatherAppTests
//
//  Created by Arun on 10/10/23.
//

import XCTest
import Combine

@testable import NewWeatherApp
import CoreLocation

final class HomeViewModelTests: XCTestCase {
    private var viewModel : HomeViewModel!
    private var repository : HomeRepositoryFake!
    private var mockDelegate : MokeHomeViewModelDelagate!
    private var cancellables: Set<AnyCancellable>!
    private var fakeLocation: String = "No where"
    private var fakeLat:String = "37.334886"
    private var fakeLong:String = "-122.008988"
    private var callBackCount = 0
    private let weatherImages = [SymbolConstants.snowFlake,SymbolConstants.cloudFill, 
                            SymbolConstants.sunMax]
    private let thermoMeterImages = [SymbolConstants.thermoSnow,SymbolConstants.thermoLow, SymbolConstants.thermoMedium,SymbolConstants.thermoHigh]
    
    override func setUp() {
        mockDelegate = MokeHomeViewModelDelagate()
        repository = HomeRepositoryFake()
        viewModel = HomeViewModel(repository: repository, locationManager: LocationManager())
        viewModel.delegate = mockDelegate
        cancellables = Set<AnyCancellable>()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.repository = nil
        self.mockDelegate = nil
    }

    func testLocation() throws {
        viewModel.inputs.fetchLocation()
        viewModel.locationManger.locationManager(CLLocationManager(), 
        didUpdateLocations: [CLLocation(latitude: 37.334886, longitude: -122.008988)])
        let expectedPlace = "Cupertino, CA, United States"
        let placeExpectation = expectation(description: "place string")
        viewModel.outputs.place.sink{ place in
            if(self.callBackCount != 0){
                XCTAssertEqual(place, expectedPlace)
                placeExpectation.fulfill()

            }
            self.callBackCount+=1
        }.store(in: &cancellables)
        wait(for: [placeExpectation])
    }

   
    func testWeatherData() throws {
        let weatherExpectation = expectation(description: "weather string")
        weatherExpectation.expectedFulfillmentCount = 2
        let thermoExpectation =  expectation(description: "thermometer string")
        let timeExpectation =  expectation(description: "time string")

        viewModel.getWeatherReport(lat: fakeLat, long: fakeLong)
        viewModel.weatherString.sink{
            weather in
            XCTAssertTrue(self.weatherImages.contains(weather))
            weatherExpectation.fulfill()
        }.store(in: &cancellables)
        
        wait(for: [weatherExpectation])
        
        viewModel.thermometerString.sink{
            thermo in
            XCTAssertTrue(self.thermoMeterImages.contains(thermo))
            thermoExpectation.fulfill()
        }.store(in: &cancellables)
        
        wait(for: [thermoExpectation])
        
        viewModel.timeString.sink{
            time in
            XCTAssertNotNil(time)
            timeExpectation.fulfill()
        }.store(in: &cancellables)
        
        wait(for: [timeExpectation])
    }
    func testInovkedToDo() throws{
        viewModel.inputs.didPressToDo()
        XCTAssertEqual(mockDelegate.invokedShowToDoList, true)
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
