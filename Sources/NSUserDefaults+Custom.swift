//
// Transient
//
// Copyright (c) 2015-2016 Radosław Pietruszewski
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation

// MARK: - Custom NSCoding Compliant Types

public extension UserDefaults {
    
    func store<Value : NSCoding>(_ value: Value, forKey key: Key<Value>) {
        set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: key.name)
    }
    
    func retrieve<Value : NSCoding>(forKey key: Key<Value>) -> Value? {
        return data(forKey: key.name).flatMap(NSKeyedUnarchiver.unarchiveObject) as? Value
    }
    
    func store<Value : NSCoding>(_ value: Value?, forKey key: Key<Value?>) {
        if let value = value {
            set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: key.name)
        } else {
            removeObject(forKey: key.name)
        }
    }
    
    func retrieve<Value : NSCoding>(forKey key: Key<Value?>) -> Value? {
        return data(forKey: key.name).flatMap(NSKeyedUnarchiver.unarchiveObject(with:)) as? Value
    }
}

// MARK: - Custom RawRepresentable Compliant Types

public extension UserDefaults {
    
    func store<Value : RawRepresentable>(_ value: Value, forKey key: Key<Value>) {
        set(value.rawValue, forKey: key.name)
    }
    
    func retrieve<Value : RawRepresentable>(forKey key: Key<Value>) -> Value? {
        return (object(forKey: key.name) as? Value.RawValue).flatMap(Value.init)
    }
    
    func store<Value : RawRepresentable>(_ value: Value?, forKey key: Key<Value?>) {
        if let value = value {
            set(value.rawValue, forKey: key.name)
        } else {
            removeObject(forKey: key.name)
        }
    }
    
    func retrieve<Value : RawRepresentable>(forKey key: Key<Value?>) -> Value? {
        return (object(forKey: key.name) as? Value.RawValue).flatMap(Value.init)
    }
}
