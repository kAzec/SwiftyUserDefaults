import Foundation
import UIKit
import XCTest

@testable import SwiftyUserDefaults

let Defaults = NSUserDefaults.standardUserDefaults()

class SwiftyUserDefaultsTests: XCTestCase {
    override func setUp() {
        // clear defaults before testing
        for (key, _) in Defaults.dictionaryRepresentation() {
            Defaults.removeObjectForKey(key)
        }
        super.tearDown()
    }

    func testNone() {
        let key = "none"
        XCTAssertNil(Defaults[key].string)
        XCTAssertNil(Defaults[key].int)
        XCTAssertNil(Defaults[key].double)
        XCTAssertNil(Defaults[key].bool)
        XCTAssertFalse(Defaults.havingKey(key))
        
        //Return default value if doesn't exist
        XCTAssertEqual(Defaults[key].stringValue, "")
        XCTAssertEqual(Defaults[key].intValue, 0)
        XCTAssertEqual(Defaults[key].doubleValue, 0)
        XCTAssertEqual(Defaults[key].boolValue, false)
        XCTAssertEqual(Defaults[key].arrayValue, [])
        XCTAssertEqual(Defaults[key].dictionaryValue, [:])
        XCTAssertEqual(Defaults[key].dataValue, NSData())
    }
    
    func testString() {
        // set and read
        let key = "string"
        let key2 = "string2"
        Defaults[key] = "foo"
        XCTAssertEqual(Defaults[key].string!, "foo")
        XCTAssertNil(Defaults[key].int)
        XCTAssertNil(Defaults[key].double)
        XCTAssertNil(Defaults[key].bool)
        
        // existance
        XCTAssertTrue(Defaults.havingKey(key))
        
        // removing
        Defaults.removeObjectForKey(key)
        XCTAssertFalse(Defaults.havingKey(key))
        Defaults[key2] = nil
        XCTAssertFalse(Defaults.havingKey(key2))
    }
    
    func testInt() {
        // set and read
        let key = "int"
        Defaults[key] = 100
        XCTAssertEqual(Defaults[key].string!, "100")
        XCTAssertEqual(Defaults[key].int!,     100)
        XCTAssertEqual(Defaults[key].double!,  100)
        XCTAssertTrue(Defaults[key].bool!)
    }
    
    func testDouble() {
        // set and read
        let key = "double"
        Defaults[key] = 3.14
        XCTAssertEqual(Defaults[key].string!, "3.14")
        XCTAssertEqual(Defaults[key].int!,     3)
        XCTAssertEqual(Defaults[key].double!,  3.14)
        XCTAssertTrue(Defaults[key].bool!)
        
        XCTAssertEqual(Defaults[key].stringValue, "3.14")
        XCTAssertEqual(Defaults[key].intValue, 3)
        XCTAssertEqual(Defaults[key].doubleValue, 3.14)
        XCTAssertEqual(Defaults[key].boolValue, true)
    }
    
    func testBool() {
        // set and read
        let key = "bool"
        Defaults[key] = true
        XCTAssertEqual(Defaults[key].string!, "1")
        XCTAssertEqual(Defaults[key].int!,     1)
        XCTAssertEqual(Defaults[key].double!,  1.0)
        XCTAssertTrue(Defaults[key].bool!)
        
        Defaults[key] = false
        XCTAssertEqual(Defaults[key].string!, "0")
        XCTAssertEqual(Defaults[key].int!,     0)
        XCTAssertEqual(Defaults[key].double!,  0.0)
        XCTAssertFalse(Defaults[key].bool!)
        
        // existance
        XCTAssertTrue(Defaults.havingKey(key))
    }
    
    func testData() {
        let key = "data"
        let data = "foo".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        Defaults[key] = data
        XCTAssertEqual(Defaults[key].data!, data)
        XCTAssertNil(Defaults[key].string)
        XCTAssertNil(Defaults[key].int)
    }
    
    func testDate() {
        let key = "date"
        let date = NSDate()
        Defaults[key] = date
        XCTAssertEqual(Defaults[key].date!, date)
    }
    
    func testArray() {
        let key = "array"
        let array = [1, 2, "foo", true]
        Defaults[key] = array
        XCTAssertEqual(Defaults[key].array!, array)
        XCTAssertEqual(Defaults[key].array![2] as? String, "foo")
    }
    
    func testDict() {
        let key = "dict"
        let dict = ["foo": 1, "bar": [1, 2, 3]]
        Defaults[key] = dict
        XCTAssertEqual(Defaults[key].dictionary!, dict)
    }
    
    // --
    
    func testRemoveAll() {
        Defaults["a"] = "test"
        Defaults["b"] = "test2"
        let count = Defaults.dictionaryRepresentation().count
        XCTAssert(!Defaults.dictionaryRepresentation().isEmpty)
        Defaults.removeAll()
        XCTAssert(!Defaults.havingKey("a"))
        XCTAssert(!Defaults.havingKey("b"))
        // We'll still have the system keys present, but our two keys should be gone
        XCTAssert(Defaults.dictionaryRepresentation().count == count - 2)
    }
    
    func testAnySubscriptGetter() {
        // This should just return the Proxy value as Any
        // Tests if it doesn't fall into infinite loop
        let anyProxy: Any? = Defaults["test"]
        XCTAssert(anyProxy is NSUserDefaults.Proxy)
        // This also used to fall into infinite loop
        XCTAssert(Defaults["test"] != nil)
    }
    
    // --
    
    func testStaticString() {
        let key = UserDefaultsKey<String>("string")
        XCTAssert(Defaults[key] == "")
        Defaults[key] = "foo"
        Defaults[key] += "bar"
        XCTAssert(Defaults[key] == "foobar")
    }
    
    func testStaticIntOptional() {
        let key = UserDefaultsKey<Int?>("int")
        XCTAssert(Defaults[key] == nil)
        Defaults[key] = 10
        XCTAssert(Defaults[key] == 10)
    }
    
    func testStaticInt() {
        let key = UserDefaultsKey<Int>("int")
        XCTAssert(Defaults[key] == 0)
        Defaults[key] += 10
        XCTAssert(Defaults[key] == 10)
    }
    
    func testStaticDoubleOptional() {
        let key = UserDefaultsKey<Double?>("double")
        XCTAssert(Defaults[key] == nil)
        Defaults[key] = 10
        XCTAssert(Defaults[key] == 10.0)
    }
    
    func testStaticDouble() {
        let key = UserDefaultsKey<Double>("double")
        XCTAssert(Defaults[key] == 0)
        Defaults[key] = 2.14
        Defaults[key] += 1
        XCTAssert(Defaults[key] == 3.14)
    }
    
    func testStaticBoolOptional() {
        let key = UserDefaultsKey<Bool?>("bool")
        XCTAssert(Defaults[key] == nil)
        Defaults[key] = true
        XCTAssert(Defaults[key] == true)
        Defaults[key] = false
        XCTAssert(Defaults[key] == false)
    }
    
    func testStaticBool() {
        let key = UserDefaultsKey<Bool>("bool")
        XCTAssert(!Defaults.havingKey("bool"))
        XCTAssert(Defaults[key] == false)
        Defaults[key] = true
        XCTAssert(Defaults[key] == true)
        Defaults[key] = false
        XCTAssert(Defaults[key] == false)
    }
    
    func testStaticNSObject() {
        let key = UserDefaultsKey<NSObject?>("object")
        XCTAssert(Defaults[key] == nil)
        Defaults[key] = "foo"
        XCTAssert(Defaults[key] as? NSString == "foo")
        Defaults[key] = NSDate.distantPast()
        XCTAssert(Defaults[key] as? NSDate == NSDate.distantPast())
    }
    
    func testStaticDataOptional() {
        let key = UserDefaultsKey<NSData?>("data")
        XCTAssert(Defaults[key] == nil)
        let data = "foobar".dataUsingEncoding(NSUTF8StringEncoding)!
        Defaults[key] = data
        XCTAssert(Defaults[key] == data)
    }
    
    func testStaticData() {
        let key = UserDefaultsKey<NSData>("data")
        XCTAssert(Defaults[key] == NSData())
        let data = "foobar".dataUsingEncoding(NSUTF8StringEncoding)!
        Defaults[key] = data
        XCTAssert(Defaults[key] == data)
    }
    
    func testStaticDate() {
        let key = UserDefaultsKey<NSDate?>("date")
        XCTAssert(Defaults[key] == nil)
        Defaults[key] = NSDate.distantPast()
        XCTAssert(Defaults[key] == NSDate.distantPast())
        let now = NSDate()
        Defaults[key] = now
        XCTAssert(Defaults[key] == now)
    }
    
    func testStaticURL() {
        let key = UserDefaultsKey<NSURL?>("url")
        XCTAssert(Defaults[key] == nil)
        Defaults[key] = NSURL(string: "https://github.com")
        XCTAssert(Defaults[key]! == NSURL(string: "https://github.com"))
        
        Defaults["url"] = "~/Desktop"
        XCTAssert(Defaults[key]! == NSURL(fileURLWithPath: ("~/Desktop" as NSString).stringByExpandingTildeInPath))
    }
    
    func testStaticDictionaryOptional() {
        let key = UserDefaultsKey<[String: AnyObject]?>("dictionary")
        XCTAssert(Defaults[key] == nil)
        Defaults[key] = ["foo": "bar", "bar": 123, "baz": NSData()]
        XCTAssert(Defaults[key]! as NSDictionary == ["foo": "bar", "bar": 123, "baz": NSData()])
    }
    
    func testStaticDictionary() {
        let key = UserDefaultsKey<[String: AnyObject]>("dictionary")
        XCTAssert(Defaults[key] as NSDictionary == [:])
        Defaults[key] = ["foo": "bar", "bar": 123, "baz": NSData()]
        XCTAssert(Defaults[key] as NSDictionary == ["foo": "bar", "bar": 123, "baz": NSData()])
        Defaults[key]["lol"] = NSDate.distantFuture()
        XCTAssert(Defaults[key]["lol"] as! NSDate == NSDate.distantFuture())
        Defaults[key]["lol"] = nil
        Defaults[key]["baz"] = nil
        XCTAssert(Defaults[key] as NSDictionary == ["foo": "bar", "bar": 123])
    }
    
    // --
    
    func testStaticArrayOptional() {
        let key = UserDefaultsKey<[AnyObject]?>("nsarray")
        XCTAssert(Defaults[key] == nil)
        Defaults[key] = []
        XCTAssert(Defaults[key]! as NSArray == [])
        Defaults[key] = [1, "foo", NSData()]
        XCTAssert(Defaults[key]! as NSArray == [1, "foo", NSData()])
    }
    
    func testStaticArray() {
        let key = UserDefaultsKey<[AnyObject]>("nsarray")
        XCTAssert(Defaults[key] as NSArray == [])
        Defaults[key] = [1, "foo", NSData()]
        XCTAssert(Defaults[key] as NSArray == [1, "foo", NSData()])
    }
    
    func testMutatingStaticArray() {
        let key = UserDefaultsKey<[AnyObject]>("array")
        XCTAssert(Defaults[key] as NSArray == [])
        Defaults[key].append(1)
        Defaults[key].append("foo")
        Defaults[key].append(false)
        Defaults[key].append(NSData())
        XCTAssert(Defaults[key] as NSArray == [1, "foo", false, NSData()])
    }
    
    // --
    
    func testStaticStringArrayOptional() {
        let key = UserDefaultsKey<[String]?>("strings")
        XCTAssert(Defaults[key] == nil)
        Defaults[key] = ["foo", "bar"]
        Defaults[key]?.append("baz")
        XCTAssert(Defaults[key]! == ["foo", "bar", "baz"])
        
        // bad types
        Defaults["strings"] = [1, 2, false, "foo"]
        XCTAssert(Defaults[key] == nil)
    }
    
    func testStaticStringArray() {
        let key = UserDefaultsKey<[String]>("strings")
        XCTAssert(Defaults[key] == [])
        Defaults[key] = ["foo", "bar"]
        Defaults[key].append("baz")
        XCTAssert(Defaults[key] == ["foo", "bar", "baz"])
        
        // bad types
        Defaults["strings"] = [1, 2, false, "foo"]
        XCTAssert(Defaults[key] == [])
    }
    
    func testStaticIntArrayOptional() {
        let key = UserDefaultsKey<[Int]?>("ints")
        XCTAssert(Defaults[key] == nil)
        Defaults[key] = [1, 2, 3]
        XCTAssert(Defaults[key]! == [1, 2, 3])
    }
    
    func testStaticIntArray() {
        let key = UserDefaultsKey<[Int]>("ints")
        XCTAssert(Defaults[key] == [])
        Defaults[key] = [3, 2, 1]
        Defaults[key].sortInPlace()
        XCTAssert(Defaults[key] == [1, 2, 3])
    }
    
    func testStaticDoubleArrayOptional() {
        let key = UserDefaultsKey<[Double]?>("doubles")
        XCTAssert(Defaults[key] == nil)
        Defaults[key] = [1.1, 2.2, 3.3]
        XCTAssert(Defaults[key]! == [1.1, 2.2, 3.3])
    }
    
    func testStaticDoubleArray() {
        let key = UserDefaultsKey<[Double]>("doubles")
        XCTAssert(Defaults[key] == [])
        Defaults[key] = [1.1, 2.2, 3.3]
        XCTAssert(Defaults[key] == [1.1, 2.2, 3.3])
    }
    
    func testStaticBoolArrayOptional() {
        let key = UserDefaultsKey<[Bool]?>("bools")
        XCTAssert(Defaults[key] == nil)
        Defaults[key] = [true, false, true]
        XCTAssert(Defaults[key]! == [true, false, true])
    }
    
    func testStaticBoolArray() {
        let key = UserDefaultsKey<[Bool]>("bools")
        XCTAssert(Defaults[key] == [])
        Defaults[key] = [true, false, true]
        XCTAssert(Defaults[key] == [true, false, true])
    }
    
    func testStaticDataArrayOptional() {
        let key = UserDefaultsKey<[NSData]?>("datas")
        XCTAssert(Defaults[key] == nil)
        let data = "foobar".dataUsingEncoding(NSUTF8StringEncoding)!
        Defaults[key] = [data, NSData()]
        XCTAssert(Defaults[key]! == [data, NSData()])
    }
    
    func testStaticDataArray() {
        let key = UserDefaultsKey<[NSData]>("datas")
        XCTAssert(Defaults[key] == [])
        Defaults[key] = [NSData()]
        XCTAssert(Defaults[key] == [NSData()])
    }
    
    func testStaticDateArrayOptional() {
        let key = UserDefaultsKey<[NSDate]?>("dates")
        XCTAssert(Defaults[key] == nil)
        Defaults[key] = [NSDate.distantFuture()]
        XCTAssert(Defaults[key]! == [NSDate.distantFuture()])
    }
    
    func testStaticDateArray() {
        let key = UserDefaultsKey<[NSDate]>("dates")
        XCTAssert(Defaults[key] == [])
        Defaults[key] = [NSDate.distantFuture()]
        XCTAssert(Defaults[key] == [NSDate.distantFuture()])
    }
    
    func testShortcutsAndExistence() {
        XCTAssert(Defaults[.strings] == [])
        XCTAssert(!Defaults.havingKey(.strings))
        
        Defaults[.strings] = []
        
        XCTAssert(Defaults[.strings] == [])
        XCTAssert(Defaults.havingKey(.strings))
        
        Defaults.removeObject(forKey: .strings)
        
        XCTAssert(Defaults[.strings] == [])
        XCTAssert(!Defaults.havingKey(.strings))
    }
    
    func testShortcutsAndExistence2() {
        XCTAssert(Defaults[.optStrings] == nil)
        XCTAssert(!Defaults.havingKey(.optStrings))
        
        Defaults[.optStrings] = []
        
        XCTAssert(Defaults[.optStrings]! == [])
        XCTAssert(Defaults.havingKey(.optStrings))
        
        Defaults[.optStrings] = nil
        
        XCTAssert(Defaults[.optStrings] == nil)
        XCTAssert(!Defaults.havingKey(.optStrings))
    }
    
    // --
    
    func testArchiving() {
        let key = UserDefaultsKey<NSColor?>("color")
        XCTAssert(Defaults[key] == nil)
        Defaults[key] = .whiteColor()
        XCTAssert(Defaults[key]! == NSColor.whiteColor())
        Defaults[key] = nil
        XCTAssert(Defaults[key] == nil)
    }
    
    func testArchiving2() {
        let key = UserDefaultsKey<NSColor>("color")
        XCTAssert(!Defaults.havingKey(key))
        XCTAssert(Defaults[key] == NSColor.whiteColor())
        Defaults[key] = .blackColor()
        XCTAssert(Defaults[key] == NSColor.blackColor())
    }
    
    func testArchiving3() {
        let key = UserDefaultsKey<[NSColor]>("colors")
        XCTAssert(Defaults[key] == [])
        Defaults[key] = [.blackColor()]
        Defaults[key].append(.whiteColor())
        Defaults[key].append(.redColor())
        XCTAssert(Defaults[key] == [.blackColor(), .whiteColor(), .redColor()])
    }
    
    // --
    
    func testEnumArchiving() {
        let key = UserDefaultsKey<TestEnum?>("enum")
        XCTAssert(Defaults[key] == nil)
        Defaults[key] = .A
        XCTAssert(Defaults[key]! == .A)
        Defaults[key] = .C
        XCTAssert(Defaults[key]! == .C)
        Defaults[key] = nil
        XCTAssert(Defaults[key] == nil)
    }
    
    func testEnumArchiving2() {
        let key = UserDefaultsKey<TestEnum>("enum")
        XCTAssert(!Defaults.havingKey(key))
        XCTAssert(Defaults[key] == .A)
        Defaults[key] = .C
        XCTAssert(Defaults[key] == .C)
        Defaults.removeObject(forKey: key)
        XCTAssert(!Defaults.havingKey(key))
        XCTAssert(Defaults[key] == .A)
    }
    
    func testEnumArchiving3() {
        let key = UserDefaultsKey<TestEnum2?>("enum")
        XCTAssert(Defaults[key] == nil)
        Defaults[key] = .Ten
        XCTAssert(Defaults[key]! == .Ten)
        Defaults[key] = .Thirty
        XCTAssert(Defaults[key]! == .Thirty)
        Defaults[key] = nil
        XCTAssert(Defaults[key] == nil)
    }
}

extension NSUserDefaults.Keys {
    static let strings = UserDefaultsKey<[String]>("strings")
    static let optStrings = UserDefaultsKey<[String]?>("strings")
}
