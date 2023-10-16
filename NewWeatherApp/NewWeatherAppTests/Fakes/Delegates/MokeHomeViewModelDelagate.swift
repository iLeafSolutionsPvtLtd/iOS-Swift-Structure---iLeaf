//
//  MokeHomeViewModelDelagate.swift
//  NewWeatherAppTests
//
//  Created by Arun on 10/10/23.
//

import Foundation
@testable import NewWeatherApp

class MokeHomeViewModelDelagate:HomeViewModelDelegate{

    var invokedShowLoader = false
    var invokedShowLoaderCount = 0

    func showLoader() {
        invokedShowLoader = true
        invokedShowLoaderCount += 1
    }

    var invokedHideLoader = false
    var invokedHideLoaderCount = 0

    func hideLoader() {
        invokedHideLoader = true
        invokedHideLoaderCount += 1
    }

    var invokedShowToDoList = false
    var invokedShowToDoListCount = 0

    func showToDoList() {
        invokedShowToDoList = true
        invokedShowToDoListCount += 1
    }

    var invokedShowAlert = false
    var invokedShowAlertCount = 0
    var invokedShowAlertParameters: (title: String?, message: String)?
    var invokedShowAlertParametersList = [(title: String?, message: String)]()

    func showAlert(title: String?, message: String) {
        invokedShowAlert = true
        invokedShowAlertCount += 1
        invokedShowAlertParameters = (title, message)
        invokedShowAlertParametersList.append((title, message))
    }

    var invokedShowResultCodeError = false
    var invokedShowResultCodeErrorCount = 0
    var invokedShowResultCodeErrorParameters: (code: Int, Void)?
    var invokedShowResultCodeErrorParametersList = [(code: Int, Void)]()

    func showResultCodeError(_ code: Int) {
        invokedShowResultCodeError = true
        invokedShowResultCodeErrorCount += 1
        invokedShowResultCodeErrorParameters = (code, ())
        invokedShowResultCodeErrorParametersList.append((code, ()))
    }
}
