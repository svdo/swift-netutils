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
        for i in interfaces {
            println(i.getName())
            println("    Family: \(i.getFamily().toString())")
            if let a = i.getAddress() {
                println("    Address: \(a)")
            }
            if let nm = i.getNetmask() {
                println("    Netmask: \(nm)")
            }
        }
    }

}
