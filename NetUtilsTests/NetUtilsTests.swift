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
        let filtered = interfaces.filter { ($0.family == .ipv4 && !$0.isLoopback) }
        dumpInterfaces(filtered)
        XCTAssertTrue(filtered.count >= 1)
    }

    func testCreateDummyInterface() {
        let i = Interface.createTestDummy("dummyInterface", family: .ipv4, address: "1.2.3.4", multicastSupported: false, broadcastAddress: "5.6.7.8")
        XCTAssertEqual(i.name, "dummyInterface")
        XCTAssertEqual(i.family, Interface.Family.ipv4)
        XCTAssertEqual(i.address, "1.2.3.4")
        XCTAssertFalse(i.supportsMulticast)
        XCTAssertEqual(i.broadcastAddress, "5.6.7.8")
    }
    
    func testInet4AddressAsByteArray() {
        let i = Interface.createTestDummy("lo0", family: .ipv4, address: "127.0.0.1", multicastSupported: false, broadcastAddress: nil)
        let bytes:[UInt8] = i.addressBytes!
        XCTAssertEqual(bytes.count, 4)
        XCTAssertEqual(bytes[0], 0x7F)
        XCTAssertEqual(bytes[1], 0)
        XCTAssertEqual(bytes[2], 0)
        XCTAssertEqual(bytes[3], 1)
    }
    
    func testInet6AddressAsByteArray() {
        let i = Interface.createTestDummy("lo0", family: .ipv6, address: "fe80::dead:beaf", multicastSupported: false, broadcastAddress: nil)
        let addressbytes:[UInt8]? = i.addressBytes
        XCTAssert(addressbytes != nil)
        if let bytes = addressbytes {
            XCTAssertEqual(bytes.count, 16)
            XCTAssertEqual(bytes[0], 0xFE)
            XCTAssertEqual(bytes[1], 0x80)
            XCTAssertEqual(bytes[2], 0x00)
            XCTAssertEqual(bytes[3], 0x00)
            XCTAssertEqual(bytes[4], 0x00)
            XCTAssertEqual(bytes[5], 0x00)
            XCTAssertEqual(bytes[6], 0x00)
            XCTAssertEqual(bytes[7], 0x00)
            XCTAssertEqual(bytes[8], 0x00)
            XCTAssertEqual(bytes[9], 0x00)
            XCTAssertEqual(bytes[10], 0x00)
            XCTAssertEqual(bytes[11], 0x00)
            XCTAssertEqual(bytes[12], 0xDE)
            XCTAssertEqual(bytes[13], 0xAD)
            XCTAssertEqual(bytes[14], 0xBE)
            XCTAssertEqual(bytes[15], 0xAF)
        }
    }

    func dumpInterfaces(interfaces:[Interface]) {
        for i in interfaces {
            let running = i.isRunning ? "running" : "not running"
            let up = i.isUp ? "up" : "down"
            let loopback = i.isLoopback ? ", loopback" : ""
            print("\(i.name) (\(running), \(up)\(loopback))")
            print("    Family: \(i.family.toString())")
            if let a = i.address {
                print("    Address: \(a)")
            }
            if let nm = i.netmask {
                print("    Netmask: \(nm)")
            }
            if let b = i.broadcastAddress {
                print("    broadcast: \(b)")
            }
            let mc = i.supportsMulticast ? "yes" : "no"
            print("    multicast: \(mc)")
        }
    }
}
