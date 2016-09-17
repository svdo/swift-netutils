//  Copyright (c) 2015 Stefan van den Oord. All rights reserved.

import Foundation
import ifaddrs

public class Interface : CustomStringConvertible, CustomDebugStringConvertible {

    public enum Family : Int {
        case ipv4, ipv6, other
        public func toString() -> String {
            switch (self) {
                case .ipv4: return "IPv4"
                case .ipv6: return "IPv6"
                default: return "other"
            }
        }
    }
    
    public static func allInterfaces() -> [Interface] {
        var interfaces : [Interface] = []
        
        var ifaddrsPtr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddrsPtr) == 0 {
            
            var ifaddrPtr = ifaddrsPtr
            
            while ifaddrPtr != nil {
                let addr = ifaddrPtr!.pointee.ifa_addr.pointee
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    interfaces.append(Interface(data: ifaddrPtr!.pointee))
                }
                ifaddrPtr = ifaddrPtr!.pointee.ifa_next
            }
            freeifaddrs(ifaddrsPtr)
        }

        return interfaces
    }
    
    /**
     *  Returns a new Interface instance that does not represent a real network interface, but can be used for (unit) testing.
     */
    public static func createTestDummy(_ name:String, family:Family, address:String, multicastSupported:Bool, broadcastAddress:String?) -> Interface
    {
        return Interface(name: name, family: family, address: address, netmask: nil, running: true, up: true, loopback: false, multicastSupported: multicastSupported, broadcastAddress: broadcastAddress)
    }
    
    public init(name:String, family:Family, address:String?, netmask:String?, running:Bool, up:Bool, loopback:Bool, multicastSupported:Bool, broadcastAddress:String?) {
        self.name = name
        self.family = family
        self.address = address
        self.netmask = netmask
        self.running = running
        self.up = up
        self.loopback = loopback
        self.multicastSupported = multicastSupported
        self.broadcastAddress = broadcastAddress
    }

    convenience init(data:ifaddrs) {
        let flags = Int32(data.ifa_flags)
        let broadcastValid : Bool = ((flags & IFF_BROADCAST) == IFF_BROADCAST)
        self.init(name: String(cString: data.ifa_name),
            family: Interface.extractFamily(data),
            address: Interface.extractAddress(data.ifa_addr.pointee),
            netmask: Interface.extractAddress(data.ifa_netmask.pointee),
            running: ((flags & IFF_RUNNING) == IFF_RUNNING),
            up: ((flags & IFF_UP) == IFF_UP),
            loopback: ((flags & IFF_LOOPBACK) == IFF_LOOPBACK),
            multicastSupported: ((flags & IFF_MULTICAST) == IFF_MULTICAST),
            broadcastAddress: ((broadcastValid && data.ifa_dstaddr != nil) ? Interface.extractAddress(data.ifa_dstaddr.pointee) : nil))
    }
    
    fileprivate static func extractFamily(_ data:ifaddrs) -> Family {
        var family : Family = .other
        let addr = data.ifa_addr.pointee
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

    fileprivate static func extractAddress(_ address:sockaddr) -> String? {
        if (address.sa_family == sa_family_t(AF_INET)) {
            return extractAddress_ipv4(address)
        }
        else if (address.sa_family == sa_family_t(AF_INET6)) {
            return extractAddress_ipv6(address)
        }
        else {
            return nil
        }
    }
    
    fileprivate static func extractAddress_ipv4(_ address:sockaddr) -> String? {
        var addr = address
        var address : String? = nil
        var hostname = [CChar](repeating: 0, count: Int(2049))
        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname,
                socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST) == 0) {
            address = String(cString: hostname)
        }
        else {
//            var error = String.fromCString(gai_strerror(errno))!
//            println("ERROR: \(error)")
        }
        return address
    }
    
    fileprivate static func extractAddress_ipv6(_ address:sockaddr) -> String? {
        var addr = address
        var ip : [Int8] = [Int8](repeating: Int8(0), count: Int(INET6_ADDRSTRLEN))
        return inetNtoP(&addr, ip: &ip)
    }
    
    fileprivate static func inetNtoP(_ addr:UnsafeMutablePointer<sockaddr>, ip:UnsafeMutablePointer<Int8>) -> String? {
        let addr6 = unsafeBitCast(addr, to: UnsafeMutablePointer<sockaddr_in6>.self)
        let conversion:UnsafePointer<CChar> = inet_ntop(AF_INET6, &addr6.pointee.sin6_addr, ip, socklen_t(INET6_ADDRSTRLEN))
        let s = String(cString: conversion)
        return s
    }
    
    public var addressBytes: [UInt8]? {
        guard let addr = address else { return nil }
        
        let af:Int32
        let len:Int
        switch family {
        case .ipv4:
            af = AF_INET
            len = 4
        case .ipv6:
            af = AF_INET6
            len = 16
        default:
            return nil
        }
        var bytes = [UInt8](repeating: 0, count: len)
        let result = inet_pton(af, addr, &bytes)
        return ( result == 1 ) ? bytes : nil
    }
    public var isRunning: Bool { return running }
    public var isUp: Bool { return up }
    public var isLoopback: Bool { return loopback }
    public var supportsMulticast: Bool { return multicastSupported }

    public let name : String
    public let family : Family
    public let address : String?
    public let netmask : String?
    public let broadcastAddress : String?
    fileprivate let running : Bool
    fileprivate let up : Bool
    fileprivate let loopback : Bool
    fileprivate let multicastSupported : Bool
    
    public var description: String { return name }
    public var debugDescription: String {
        var s = "Interface name:\(name) family:\(family)"
        if let ip = address {
            s += " ip:\(ip)"
        }
        s += isUp ? " (up)" : " (down)"
        s += isRunning ? " (running)" : "(not running)"
        return s
    }
}
