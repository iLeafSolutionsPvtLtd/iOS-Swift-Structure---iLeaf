import Foundation

public struct WebserviceError {
    public enum ErrorType {
        case  unknown, somethingWentWrong, general(message: String)
    }

    private let somethingWentWrongCode = "1"

    public let type: ErrorType

    public init(code: String?, errorMessage: String?) {
        if code == somethingWentWrongCode {
            type = .somethingWentWrong
        } else if let errorMessage {
            type = .general(message: errorMessage)
        } else {
            type = .unknown
        }
    }

    public static func unknown() -> Self {
        Self(code: "unknown", errorMessage: nil)
    }
}

//public struct ResultCodeError {
//    let type: ResultCode
//    let logoutRequired: Bool
//
//    public init(code: Int) {
//        self.type = ResultCode(rawValue: code) ?? .unknown
//        switch type {
//        case .suidDoesNotExist, .zidDoesNotExist:
//            logoutRequired = true
//
//        default:
//            logoutRequired = false
//        }
//    }
//
//    public var messageKey: String {
//        type.errorMessage
//    }
//
// 
//    public var cancelButtonKey: String? {
//        return nil
//    }
//}
