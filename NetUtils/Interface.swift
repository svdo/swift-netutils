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
        
        var ifaddrsPtr = UnsafeMutablePointer<ifaddrs>(nil)
        if getifaddrs(&ifaddrsPtr) == 0 {
            
            var ifaddrPtr = ifaddrsPtr
            
            while ifaddrPtr != nil {
                let addr = ifaddrPtr.memory.ifa_addr.memory
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    interfaces.append(Interface(data: ifaddrPtr.memory))
                }
                ifaddrPtr = ifaddrPtr.memory.ifa_next
            }
            freeifaddrs(ifaddrsPtr)
        }

        return interfaces
    }
    
    /**
     *  Returns a new Interface instance that does not represent a real network interface, but can be used for (unit) testing.
     */
    public static func createTestDummy(name:String, family:Family, address:String, multicastSupported:Bool, broadcastAddress:String?) -> Interface
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
        self.init(name: String.fromCString(data.ifa_name)!,
            family: Interface.extractFamily(data),
            address: Interface.extractAddress(data.ifa_addr.memory),
            netmask: Interface.extractAddress(data.ifa_netmask.memory),
            running: ((flags & IFF_RUNNING) == IFF_RUNNING),
            up: ((flags & IFF_UP) == IFF_UP),
            loopback: ((flags & IFF_LOOPBACK) == IFF_LOOPBACK),
            multicastSupported: ((flags & IFF_MULTICAST) == IFF_MULTICAST),
            broadcastAddress: ((broadcastValid && data.ifa_dstaddr != nil) ? Interface.extractAddress(data.ifa_dstaddr.memory) : nil))
    }
    
    private static func extractFamily(data:ifaddrs) -> Family {
        var family : Family = .other
        let addr = data.ifa_addr.memory
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
    
    private static func extractAddress_ipv4(address:sockaddr) -> String? {
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
    
    private static func extractAddress_ipv6(address:sockaddr) -> String? {
        var addr = address
        var ip : [Int8] = [Int8](count: Int(INET6_ADDRSTRLEN), repeatedValue: Int8(0))
        return inetNtoP(&addr, ip: &ip)
    }
    
    private static func inetNtoP(addr:UnsafeMutablePointer<sockaddr>, ip:UnsafeMutablePointer<Int8>) -> String? {
        let addr6 = unsafeBitCast(addr, UnsafeMutablePointer<sockaddr_in6>.self)
        let conversion:UnsafePointer<CChar> = inet_ntop(AF_INET6, &addr6.memory.sin6_addr, ip, socklen_t(INET6_ADDRSTRLEN))
        let s = String.fromCString(conversion)
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
        var bytes = [UInt8](count:len, repeatedValue:0)
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
    private let running : Bool
    private let up : Bool
    private let loopback : Bool
    private let multicastSupported : Bool
    
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
