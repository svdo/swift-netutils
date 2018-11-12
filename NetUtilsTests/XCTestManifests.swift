import XCTest

extension NetUtilsTests {
    static let __allTests = [
        ("testAllInterfaces", testAllInterfaces),
        ("testCreateDummyInterface", testCreateDummyInterface),
        ("testInet4AddressAsByteArray", testInet4AddressAsByteArray),
        ("testInet6AddressAsByteArray", testInet6AddressAsByteArray),
        ("testNonLoopbackIPV4Interfaces", testNonLoopbackIPV4Interfaces),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(NetUtilsTests.__allTests),
    ]
}
#endif
