//  Copyright (c) 2015 Stefan van den Oord. All rights reserved.

import UIKit
import XCTest
import NetUtils

class NetUtilsTests: XCTestCase {

    func testAllInterfaces() {
        let interfaces = Interface.allInterfaces()
        dumpInterfaces(interfaces)
        XCTAssertTrue(interfaces.count >= 2) /* at least loopback and ethernet */
    }

    func testNonLoopbackIPV4Interfaces() {
        let interfaces = Interface.allInterfaces()
        let filtered = interfaces.filter { ($0.getFamily() == .ipv4 && !$0.isLoopback()) }
        dumpInterfaces(filtered)
        XCTAssertTrue(filtered.count >= 1)
    }

    func dumpInterfaces(interfaces:[Interface]) {
        for i in interfaces {
            let running = i.isRunning() ? "running" : "not running"
            let up = i.isUp() ? "up" : "down"
            let loopback = i.isLoopback() ? ", loopback" : ""
            print("\(i.getName()) (\(running), \(up)\(loopback))")
            print("    Family: \(i.getFamily().toString())")
            if let a = i.getAddress() {
                print("    Address: \(a)")
            }
            if let nm = i.getNetmask() {
                print("    Netmask: \(nm)")
            }
            if let b = i.getBroadcastAddress() {
                print("    broadcast: \(b)")
            }
            let mc = i.supportsMulticast() ? "yes" : "no"
            print("    multicast: \(mc)")
        }
    }
}
