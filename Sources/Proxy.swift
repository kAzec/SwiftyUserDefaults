//
//  Proxy.swift
//  Transient
//
//  Created by 锋炜 刘 on 16/7/8.
//
//

import Foundation

public extension NSUserDefaults {
    class Proxy {
        let defaults: NSUserDefaults
        let key: String
        
        init(_ defaults: NSUserDefaults, _ key: String) {
            self.defaults = defaults
            self.key = key
        }
        
        // MARK: - Getters
        public var object: AnyObject? {
            return defaults.objectForKey(key)
        }
        
        public var string: String? {
            return defaults.stringForKey(key)
        }
        
        public var stringValue: String {
            return string ?? ""
        }
        
        public var number: NSNumber? {
            return defaults.objectForKey(key) as? NSNumber
        }
        
        public var numberValue: NSNumber {
            return number ?? 0
        }
        
        public var int: Int? {
            return number?.integerValue
        }
        
        public var intValue: Int {
            return int ?? 0
        }
        
        public var double: Double? {
            return number?.doubleValue
        }
        
        public var doubleValue: Double {
            return double ?? 0
        }
        
        public var bool: Bool? {
            return number?.boolValue
        }
        
        public var boolValue: Bool {
            return bool ?? false
        }
        
        public var array: NSArray? {
            return defaults.arrayForKey(key)
        }
        
        public var arrayValue: NSArray {
            return array ?? NSArray()
        }
        
        public var dictionary: NSDictionary? {
            return defaults.dictionaryForKey(key)
        }
        
        public var dictionaryValue: NSDictionary {
            return dictionary ?? NSDictionary()
        }
        
        public var data: NSData? {
            return defaults.dataForKey(key)
        }
        
        public var dataValue: NSData {
            return data ?? NSData()
        }
        
        public var date: NSDate? {
            return object as? NSDate
        }
    }
}

public extension NSUserDefaults {
    /// Get proxy for `key`
    subscript(key: String) -> Proxy {
        return Proxy(self, key)
    }
}