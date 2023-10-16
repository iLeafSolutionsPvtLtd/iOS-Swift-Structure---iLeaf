#if !RELEASE
import Foundation

public protocol Fakeable {
    associatedtype FakeValue
    static var defaultFakeValue: FakeValue { get }
}

public extension Fakeable {
    static func fake(value: FakeValue = defaultFakeValue) -> FakeValue {
        value
    }
}

extension Double: Fakeable {
    public static var defaultFakeValue: Double {
        0.1
    }
}

extension Decimal: Fakeable {
    public static var defaultFakeValue: Decimal {
        0.1
    }
}

extension String: Fakeable {
    public static var defaultFakeValue: String {
        "test"
    }
}

extension Int: Fakeable {
    public static var defaultFakeValue: Int {
        0
    }
}

extension Int64: Fakeable {
    public static var defaultFakeValue: Int64 {
        0
    }
}

extension Data: Fakeable {
    public static var defaultFakeValue: Data {
        Data()
    }
}

extension Date: Fakeable {
    public static var defaultFakeValue: Date {
        Date.makeFake()
    }

    public static func makeFake(year: Int = 2018,
                                month: Int = 1,
                                day: Int = 1,
                                hour: Int = 9,
                                min: Int = 30,
                                sec: Int = 0) -> Date {
        let calendar = Calendar(identifier: .gregorian)

        var components = DateComponents(year: year, month: month, day: day, hour: hour, minute: min, second: sec)
        components.timeZone = TimeZone(identifier: "GMT")
        return calendar.date(from: components)!
    }
}

extension Bool: Fakeable {
    public static var defaultFakeValue: Bool {
        true
    }
}

extension Array: Fakeable where Element: Fakeable {
    public static var defaultFakeValue: [Element] {
        guard let element = Element.defaultFakeValue as? Element else {
            fatalError("can't construct element from fake")
        }
        return [element]
    }
}

extension Dictionary: Fakeable where Key: Fakeable, Value: Fakeable {
    public static var defaultFakeValue: [Key: Value] {
        guard let key = Key.defaultFakeValue as? Key,
              let value = Value.defaultFakeValue as? Value else {
            fatalError("can't construct key/value from fake")}
        return [key: value]
    }
}

public enum FakeError: Swift.Error, Fakeable {
    public static var defaultFakeValue: Error {
        NSError(domain: "test", code: -1, userInfo: nil)
    }
}
#endif
