//
//  NetUtilsTests.swift
//  NetUtilsTests
//
//  Created by Stefan on 28/04/15.
//  Copyright (c) 2015 Stefan van den Oord. All rights reserved.
//

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
            var running = i.isRunning() ? "running" : "not running"
            var up = i.isUp() ? "up" : "down"
            var loopback = i.isLoopback() ? ", loopback" : ""
            println("\(i.getName()) (\(running), \(up)\(loopback))")
            println("    Family: \(i.getFamily().toString())")
            if let a = i.getAddress() {
                println("    Address: \(a)")
            }
            if let nm = i.getNetmask() {
                println("    Netmask: \(nm)")
            }
            if let b = i.getBroadcastAddress() {
                println("    broadcast: \(b)")
            }
            var mc = i.supportsMulticast() ? "yes" : "no"
            println("    multicast: \(mc)")
        }
    }
}
