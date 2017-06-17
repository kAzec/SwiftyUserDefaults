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

// MARK: - Subscripts for specific non-optional types.

public extension UserDefaults {
    
    subscript(key: Key<String>) -> String {
        get { return string(forKey: key.name) ?? "" }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<Int>) -> Int {
        get { return integer(forKey: key.name) }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<Float>) -> Float {
        get { return float(forKey: key.name) }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<Double>) -> Double {
        get { return double(forKey: key.name) }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<Bool>) -> Bool {
        get { return bool(forKey: key.name) }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<Data>) -> Data {
        get { return data(forKey: key.name) ?? Data() }
        set { set(newValue, forKey: key.name) }
    }
}

// MARK: Subscripts for specific optional types.

public extension UserDefaults {
    
    private func number(forKey key: String) -> NSNumber? {
        return object(forKey: key) as? NSNumber
    }
    
    subscript(key: Key<Int?>) -> Int? {
        get { return number(forKey: key.name)?.intValue }
        set { set(newValue as NSNumber?, forKey: key.name) }
    }
    
    subscript(key: Key<Float?>) -> Float? {
        get { return number(forKey: key.name)?.floatValue }
        set { set(newValue as NSNumber?, forKey: key.name) }
    }
    
    subscript(key: Key<Double?>) -> Double? {
        get { return number(forKey: key.name)?.doubleValue }
        set { set(newValue as NSNumber?, forKey: key.name) }
    }
    
    subscript(key: Key<Bool?>) -> Bool? {
        get { return number(forKey: key.name)?.boolValue }
        set { set(newValue as NSNumber?, forKey: key.name) }
    }

    subscript(key: Key<String?>) -> String? {
        get { return string(forKey: key.name) }
        set { set(newValue as NSString?, forKey: key.name) }
    }
    
    subscript(key: Key<URL?>) -> URL? {
        get { return url(forKey: key.name) }
        set { set(newValue, forKey: key.name) }
    }

    subscript(key: Key<Data?>) -> Data? {
        get { return data(forKey: key.name) }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<Date?>) -> Date? {
        get { return object(forKey: key.name) as? Date }
        set { set(newValue, forKey: key.name) }
    }
}

// MARK: - Subscripts for non-optional collection types.

public extension UserDefaults {
    
    private func array<Value : _ObjectiveCBridgeable>(forKey key: Key<[Value]>) -> [Value] {
        return array(forKey: key.name) as NSArray? as? [Value] ?? []
    }
    
    subscript(key: Key<[String]>) -> [String] {
        get { return stringArray(forKey: key.name) ?? [] }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<[Int]>) -> [Int] {
        get { return array(forKey: key) }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<[Double]>) -> [Double] {
        get { return array(forKey: key) }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<[Bool]>) -> [Bool] {
        get { return array(forKey: key) }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<[Data]>) -> [Data] {
        get { return array(forKey: key) }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<[Date]>) -> [Date] {
        get { return array(forKey: key) }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<[Any]>) -> [Any] {
        get { return array(forKey: key.name) ?? [] }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<[String : Any]>) -> [String : Any] {
        get { return dictionary(forKey: key.name) ?? [:] }
        set { set(newValue, forKey: key.name) }
    }
}

// MARK: Subscripts for optional collection types.

public extension UserDefaults {
    
    private func array<Value : _ObjectiveCBridgeable>(forKey key: Key<[Value]?>) -> [Value]? {
        return array(forKey: key.name) as NSArray? as? [Value]
    }
    
    subscript(key: Key<[String]?>) -> [String]? {
        get { return array(forKey: key) }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<[Int]?>) -> [Int]? {
        get { return array(forKey: key) }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<[Double]?>) -> [Double]? {
        get { return array(forKey: key) }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<[Bool]?>) -> [Bool]? {
        get { return array(forKey: key) }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<[Data]?>) -> [Data]? {
        get { return array(forKey: key) }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<[Date]?>) -> [Date]? {
        get { return array(forKey: key) }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<[Any]?>) -> [Any]? {
        get { return array(forKey: key.name) }
        set { set(newValue, forKey: key.name) }
    }
    
    subscript(key: Key<[String : Any]?>) -> [String : Any]? {
        get { return dictionary(forKey: key.name) }
        set { set(newValue, forKey: key.name) }
    }
}
