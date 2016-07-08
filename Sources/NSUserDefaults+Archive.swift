//
// SwiftyUserDefaults
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

// MARK: - Archive Custom Non-optional Types
public extension NSUserDefaults {
    // TODO: Ensure that T.RawValue is compatible
    func archive<T: RawRepresentable>(key: UserDefaultsKey<T>, _ value: T) {
        self[key.key] = value.rawValue
    }
    
    func unarchive<T: RawRepresentable>(key: UserDefaultsKey<T>) -> T? {
        return objectForKey(key.key).flatMap { T(rawValue: $0 as! T.RawValue) }
    }
    
    func archive<T: NSCoding>(key: UserDefaultsKey<T>, _ value: T?) {
        if let value = value {
            self[key.key] = NSKeyedArchiver.archivedDataWithRootObject(value)
        } else {
            removeObjectForKey(key.key)
        }
    }
    
    func unarchive<T: NSCoding>(key: UserDefaultsKey<T>) -> T? {
        return dataForKey(key.key).flatMap{ NSKeyedUnarchiver.unarchiveObjectWithData($0) } as? T
    }
    
    func archive<T: NSCoding>(key: UserDefaultsKey<[T]>, _ value: [T]?) {
        if let value = value {
            self[key.key] = NSKeyedArchiver.archivedDataWithRootObject(value)
        } else {
            removeObjectForKey(key.key)
        }
    }
    
    func unarchive<T: NSCoding>(key: UserDefaultsKey<[T]>) -> [T]? {
        return dataForKey(key.key).flatMap{ NSKeyedUnarchiver.unarchiveObjectWithData($0) } as? [T]
    }
}

// MARK: - Archive Custom Optional Types
public extension NSUserDefaults {
    // TODO: Ensure that T.RawValue is compatible
    func archive<T: RawRepresentable>(key: UserDefaultsKey<T?>, _ value: T?) {
        self[key.key] = value?.rawValue
    }
    
    func unarchive<T: RawRepresentable>(key: UserDefaultsKey<T?>) -> T? {
        return objectForKey(key.key).flatMap { T(rawValue: $0 as! T.RawValue) }
    }
    
    func archive<T: NSCoding>(key: UserDefaultsKey<T?>, _ value: T?) {
        if let value = value {
            self[key.key] = NSKeyedArchiver.archivedDataWithRootObject(value)
        } else {
            removeObjectForKey(key.key)
        }
    }
    
    func unarchive<T: NSObject>(key: UserDefaultsKey<T?>) -> T? {
        return dataForKey(key.key).flatMap{ NSKeyedUnarchiver.unarchiveObjectWithData($0) } as? T
    }
    
    func archive<T: NSCoding>(key: UserDefaultsKey<[T]?>, _ value: [T]?) {
        if let value = value {
            self[key.key] = NSKeyedArchiver.archivedDataWithRootObject(value)
        } else {
            removeObjectForKey(key.key)
        }
    }
    
    func unarchive<T: NSCoding>(key: UserDefaultsKey<[T]?>) -> [T]? {
        return dataForKey(key.key).flatMap{ NSKeyedUnarchiver.unarchiveObjectWithData($0) } as? [T]
    }
}