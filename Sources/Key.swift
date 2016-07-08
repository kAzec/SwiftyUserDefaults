//
//  Key.swift
//  SwiftyUserDefaults
//
//  Created by 锋炜 刘 on 16/7/8.
//
//

import Foundation

public extension NSUserDefaults {
    class Keys {
        
    }
}

// TODO: Use generic nested class(in NSUserDefatuls) when it becomes available.
public class UserDefaultsKey<T>: NSUserDefaults.Keys {
    // TODO: Can we use protocols to ensure ValueType is a compatible type?
    public let key: String
    
    public init(_ key: String) {
        self.key = key
    }
}

public extension NSUserDefaults {
    /// Returns `true` if `key` exists
    func havingKey<T>(key: UserDefaultsKey<T>) -> Bool {
        return objectForKey(key.key) != nil
    }
    
    /// Removes value for `key`
    func removeObject<T>(forKey key: UserDefaultsKey<T>) {
        removeObjectForKey(key.key)
    }
}