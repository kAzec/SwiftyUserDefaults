//
//  Key.swift
//  Transient
//
//  Created by Fengwei Liu on 08/07/2016.
//  Copyright © 2016 kAzec. All rights reserved.
//

import Foundation

public extension UserDefaults {
    
    class Keys {  }
    
    final class Key<Value> : Keys {
        // TODO: Can we use protocols to ensure ValueType is a compatible type?
        public let name: String
        
        public init(_ name: String) {
            self.name = name
        }
    }

    /// Returns `true` if `key` exists
    func havingKey<Value>(_ key: Key<Value>) -> Bool {
        return object(forKey: key.name) != nil
    }
    
    /// Returns `true` if `key` exists
    func havingKey(_ key: String) -> Bool {
        return object(forKey: key) != nil
    }
    
    func removeObject<Value>(forKey key: Key<Value>) {
        removeObject(forKey: key.name)
    }
    
    /// Removes all keys and values from user defaults
    func removeAll() {
        for key in dictionaryRepresentation().keys {
            removeObject(forKey: key)
        }
    }
}
