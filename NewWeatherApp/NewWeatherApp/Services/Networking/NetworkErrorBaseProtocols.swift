import Foundation

protocol BaseViewModelDelegateProrocol: AnyObject {
    func showAlert(title: String?, message: String)
    func showResultCodeError(_ code: Int)
}

protocol BaseCoordinatorDelegateProrocol: AnyObject {
    func showAlert(title: String?, message: String)
    func showResultCodeError(_ code: Int)
}
