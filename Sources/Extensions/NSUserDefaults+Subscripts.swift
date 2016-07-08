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

// TODO: Use generic subscripts when they become available.

// MARK: - Subscripts using traditional string keys.
extension NSUserDefaults {
    /// Set value for `key`
    subscript(key: String) -> Any? {
        get {
            let proxy: Proxy = self[key]
            return proxy
        }
        
        set {
            switch newValue {
            case let v as Int: setInteger(v, forKey: key)
            case let v as Double: setDouble(v, forKey: key)
            case let v as Bool: setBool(v, forKey: key)
            case let v as NSURL: setURL(v, forKey: key)
            case let v as NSObject: setObject(v, forKey: key)
            case nil: removeObjectForKey(key)
            default: assertionFailure("Invalid value type")
            }
        }
    }
}

// MARK: - Subscripts for specific non-optional types.
public extension NSUserDefaults {
    private func numberForKey(key: String) -> NSNumber? {
        return objectForKey(key) as? NSNumber
    }
    
    subscript(key: UserDefaultsKey<String>) -> String {
        get { return stringForKey(key.key) ?? "" }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<Int>) -> Int {
        get { return integerForKey(key.key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<Float>) -> Float {
        get { return floatForKey(key.key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<Double>) -> Double {
        get { return doubleForKey(key.key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<Bool>) -> Bool {
        get { return boolForKey(key.key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<NSData>) -> NSData {
        get { return dataForKey(key.key) ?? NSData() }
        set { self[key.key] = newValue }
    }
}

// MARK: Subscripts for specific optional types.
public extension NSUserDefaults {
    subscript(key: UserDefaultsKey<String?>) -> String? {
        get { return stringForKey(key.key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<Int?>) -> Int? {
        get { return numberForKey(key.key)?.integerValue }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<Float?>) -> Float? {
        get { return numberForKey(key.key)?.floatValue }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<Double?>) -> Double? {
        get { return numberForKey(key.key)?.doubleValue }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<Bool?>) -> Bool? {
        get { return numberForKey(key.key)?.boolValue }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<NSObject?>) -> NSObject? {
        get { return objectForKey(key.key) as? NSObject }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<NSData?>) -> NSData? {
        get { return dataForKey(key.key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<NSDate?>) -> NSDate? {
        get { return objectForKey(key.key) as? NSDate }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<NSURL?>) -> NSURL? {
        get { return URLForKey(key.key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<NSUUID?>) -> NSUUID? {
        get { return objectForKey(key.key) as? NSUUID }
        set { self[key.key] = newValue }
    }
}

// MARK: - Subscripts for non-optional collection types.
// We need the <T: AnyObject> and <T: _ObjectiveCBridgeable> variants to
// suppress compiler warnings about NSArray not being convertible to [T]
// AnyObject is for NSData and NSDate, _ObjectiveCBridgeable is for value
// types bridge-able to Foundation types (String, Int, ...)
extension NSUserDefaults {
    func arrayForKey<T: _ObjectiveCBridgeable>(key: UserDefaultsKey<[T]>) -> [T] {
        return arrayForKey(key.key) as NSArray? as? [T] ?? []
    }
    
    func arrayForKey<T: NSCoding>(key: UserDefaultsKey<[T]>) -> [T] {
        return arrayForKey(key.key) as? [T] ?? []
    }
}

public extension NSUserDefaults {
    subscript(key: UserDefaultsKey<[String]>) -> [String] {
        get { return arrayForKey(key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<[Int]>) -> [Int] {
        get { return arrayForKey(key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<[Double]>) -> [Double] {
        get { return arrayForKey(key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<[Bool]>) -> [Bool] {
        get { return arrayForKey(key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<[NSData]>) -> [NSData] {
        get { return arrayForKey(key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<[NSDate]>) -> [NSDate] {
        get { return arrayForKey(key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<[AnyObject]>) -> [AnyObject] {
        get { return arrayForKey(key.key) ?? [] }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<[String: AnyObject]>) -> [String: AnyObject] {
        get { return dictionaryForKey(key.key) ?? [:] }
        set { self[key.key] = newValue }
    }
}

// MARK: Subscripts for optional collection types.
extension NSUserDefaults {
    func arrayForKey<T: _ObjectiveCBridgeable>(key: UserDefaultsKey<[T]?>) -> [T]? {
        return arrayForKey(key.key) as NSArray? as? [T]
    }
    
    func arrayForKey<T: AnyObject>(key: UserDefaultsKey<[T]?>) -> [T]? {
        return arrayForKey(key.key) as? [T]
    }
}

public extension NSUserDefaults {
    subscript(key: UserDefaultsKey<[String]?>) -> [String]? {
        get { return arrayForKey(key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<[Int]?>) -> [Int]? {
        get { return arrayForKey(key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<[Double]?>) -> [Double]? {
        get { return arrayForKey(key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<[Bool]?>) -> [Bool]? {
        get { return arrayForKey(key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<[NSData]?>) -> [NSData]? {
        get { return arrayForKey(key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<[NSDate]?>) -> [NSDate]? {
        get { return arrayForKey(key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<[AnyObject]?>) -> [AnyObject]? {
        get { return arrayForKey(key.key) }
        set { self[key.key] = newValue }
    }
    
    subscript(key: UserDefaultsKey<[String: AnyObject]?>) -> [String: AnyObject]? {
        get { return dictionaryForKey(key.key) }
        set { self[key.key] = newValue }
    }
}