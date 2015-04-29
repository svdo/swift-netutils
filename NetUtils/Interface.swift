//
//  Interface.swift
//  NetUtils
//
//  Created by Stefan on 28/04/15.
//  Copyright (c) 2015 Stefan van den Oord. All rights reserved.
//

import Foundation
import ifaddrs

public class Interface {

    public enum Family : Int {
        case ipv4, ipv6, other
        public func toString() -> String {
            switch (self) {
                case .ipv4: return "IPV4"
                case .ipv6: return "IPV6"
                default: return "other"
            }
        }
    }
    
    public static func allInterfaces() -> [Interface] {
        var interfaces : [Interface] = []
        
        var ifaddrsPtr = UnsafeMutablePointer<ifaddrs>()
        if getifaddrs(&ifaddrsPtr) == 0 {
            for (var ifaddrPtr = ifaddrsPtr; ifaddrPtr != nil; ifaddrPtr = ifaddrPtr.memory.ifa_next) {
                var addr = ifaddrPtr.memory.ifa_addr.memory
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    interfaces.append(Interface(data: ifaddrPtr.memory))
                }
            }
            freeifaddrs(ifaddrsPtr)
        }

        return interfaces
    }
    
    public init(data:ifaddrs) {
        self.name = String.fromCString(data.ifa_name)!
        family = Interface.extractFamily(data)
        address = Interface.extractAddress(data.ifa_addr.memory)
        netmask = Interface.extractAddress(data.ifa_netmask.memory)
        let flags = Int32(data.ifa_flags)
        running = ((flags & IFF_RUNNING) == IFF_RUNNING)
        up = ((flags & IFF_UP) == IFF_UP)
        loopback = ((flags & IFF_LOOPBACK) == IFF_LOOPBACK)
        multicastSupported = ((flags & IFF_MULTICAST) == IFF_MULTICAST)
        let broadcastValid : Bool = ((flags & IFF_BROADCAST) == IFF_BROADCAST)
        if broadcastValid && data.ifa_dstaddr != nil {
            broadcastAddress = Interface.extractAddress(data.ifa_dstaddr.memory)
        }
        else {
            broadcastAddress = nil
        }
    }

    private static func extractFamily(data:ifaddrs) -> Family {
        var family : Family = .other
        var addr = data.ifa_addr.memory
        if addr.sa_family == UInt8(AF_INET) {
            family = .ipv4
        }
        else if addr.sa_family == UInt8(AF_INET6) {
            family = .ipv6
        }
        else {
            family = .other
        }
        return family
    }

    private static func extractAddress(address:sockaddr) -> String? {
        var addr = address
        var address : String? = nil
        var hostname = [CChar](count: Int(2049), repeatedValue: 0)
        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname,
                socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST) == 0) {
            address = String.fromCString(hostname)
        }
        else {
//            var error = String.fromCString(gai_strerror(errno))!
//            println("ERROR: \(error)")
        }
        return address
    }

    public func getName() -> String { return name }
    public func getFamily() -> Family { return family }
    public func getAddress() -> String? { return address }
    public func getNetmask() -> String? { return netmask }
    public func getBroadcastAddress() -> String? { return broadcastAddress }
    public func isRunning() -> Bool { return running }
    public func isUp() -> Bool { return up }
    public func isLoopback() -> Bool { return loopback }
    public func supportsMulticast() -> Bool { return multicastSupported }

    private let name : String
    private let family : Family
    private let address : String?
    private let netmask : String?
    private let broadcastAddress : String?
    private let running : Bool
    private let up : Bool
    private let loopback : Bool
    private let multicastSupported : Bool
}
