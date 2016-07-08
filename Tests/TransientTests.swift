import Foundation
import UIKit
import XCTest

@testable import Transient

let defaults = NSUserDefaults.standardUserDefaults()

class SwiftyUserDefaultsTests: XCTestCase {
    override func setUp() {
        // clear defaults before testing
        for (key, _) in defaults.dictionaryRepresentation() {
            defaults.removeObjectForKey(key)
        }
        super.tearDown()
    }

    func testNone() {
        let key = "none"
        XCTAssertNil(defaults[key].string)
        XCTAssertNil(defaults[key].int)
        XCTAssertNil(defaults[key].double)
        XCTAssertNil(defaults[key].bool)
        XCTAssertFalse(defaults.havingKey(key))
        
        //Return default value if doesn't exist
        XCTAssertEqual(defaults[key].stringValue, "")
        XCTAssertEqual(defaults[key].intValue, 0)
        XCTAssertEqual(defaults[key].doubleValue, 0)
        XCTAssertEqual(defaults[key].boolValue, false)
        XCTAssertEqual(defaults[key].arrayValue, [])
        XCTAssertEqual(defaults[key].dictionaryValue, [:])
        XCTAssertEqual(defaults[key].dataValue, NSData())
    }
    
    func testString() {
        // set and read
        let key = "string"
        let key2 = "string2"
        defaults[key] = "foo"
        XCTAssertEqual(defaults[key].string!, "foo")
        XCTAssertNil(defaults[key].int)
        XCTAssertNil(defaults[key].double)
        XCTAssertNil(defaults[key].bool)
        
        // existance
        XCTAssertTrue(defaults.havingKey(key))
        
        // removing
        defaults.removeObjectForKey(key)
        XCTAssertFalse(defaults.havingKey(key))
        defaults[key2] = nil
        XCTAssertFalse(defaults.havingKey(key2))
    }
    
    func testInt() {
        // set and read
        let key = "int"
        defaults[key] = 100
        XCTAssertEqual(defaults[key].string!, "100")
        XCTAssertEqual(defaults[key].int!,     100)
        XCTAssertEqual(defaults[key].double!,  100)
        XCTAssertTrue(defaults[key].bool!)
    }
    
    func testDouble() {
        // set and read
        let key = "double"
        defaults[key] = 3.14
        XCTAssertEqual(defaults[key].string!, "3.14")
        XCTAssertEqual(defaults[key].int!,     3)
        XCTAssertEqual(defaults[key].double!,  3.14)
        XCTAssertTrue(defaults[key].bool!)
        
        XCTAssertEqual(defaults[key].stringValue, "3.14")
        XCTAssertEqual(defaults[key].intValue, 3)
        XCTAssertEqual(defaults[key].doubleValue, 3.14)
        XCTAssertEqual(defaults[key].boolValue, true)
    }
    
    func testBool() {
        // set and read
        let key = "bool"
        defaults[key] = true
        XCTAssertEqual(defaults[key].string!, "1")
        XCTAssertEqual(defaults[key].int!,     1)
        XCTAssertEqual(defaults[key].double!,  1.0)
        XCTAssertTrue(defaults[key].bool!)
        
        defaults[key] = false
        XCTAssertEqual(defaults[key].string!, "0")
        XCTAssertEqual(defaults[key].int!,     0)
        XCTAssertEqual(defaults[key].double!,  0.0)
        XCTAssertFalse(defaults[key].bool!)
        
        // existance
        XCTAssertTrue(defaults.havingKey(key))
    }
    
    func testData() {
        let key = "data"
        let data = "foo".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        defaults[key] = data
        XCTAssertEqual(defaults[key].data!, data)
        XCTAssertNil(defaults[key].string)
        XCTAssertNil(defaults[key].int)
    }
    
    func testDate() {
        let key = "date"
        let date = NSDate()
        defaults[key] = date
        XCTAssertEqual(defaults[key].date!, date)
    }
    
    func testArray() {
        let key = "array"
        let array = [1, 2, "foo", true]
        defaults[key] = array
        XCTAssertEqual(defaults[key].array!, array)
        XCTAssertEqual(defaults[key].array![2] as? String, "foo")
    }
    
    func testDict() {
        let key = "dict"
        let dict = ["foo": 1, "bar": [1, 2, 3]]
        defaults[key] = dict
        XCTAssertEqual(defaults[key].dictionary!, dict)
    }
    
    // --
    
    func testRemoveAll() {
        defaults["a"] = "test"
        defaults["b"] = "test2"
        let count = defaults.dictionaryRepresentation().count
        XCTAssert(!defaults.dictionaryRepresentation().isEmpty)
        defaults.removeAll()
        XCTAssert(!defaults.havingKey("a"))
        XCTAssert(!defaults.havingKey("b"))
        // We'll still have the system keys present, but our two keys should be gone
        XCTAssert(defaults.dictionaryRepresentation().count == count - 2)
    }
    
    func testAnySubscriptGetter() {
        // This should just return the Proxy value as Any
        // Tests if it doesn't fall into infinite loop
        let anyProxy: Any? = defaults["test"]
        XCTAssert(anyProxy is NSUserDefaults.Proxy)
        // This also used to fall into infinite loop
        XCTAssert(defaults["test"] != nil)
    }
    
    // --
    
    func testStaticString() {
        let key = UserDefaultsKey<String>("string")
        XCTAssert(defaults[key] == "")
        defaults[key] = "foo"
        defaults[key] += "bar"
        XCTAssert(defaults[key] == "foobar")
    }
    
    func testStaticIntOptional() {
        let key = UserDefaultsKey<Int?>("int")
        XCTAssert(defaults[key] == nil)
        defaults[key] = 10
        XCTAssert(defaults[key] == 10)
    }
    
    func testStaticInt() {
        let key = UserDefaultsKey<Int>("int")
        XCTAssert(defaults[key] == 0)
        defaults[key] += 10
        XCTAssert(defaults[key] == 10)
    }
    
    func testStaticDoubleOptional() {
        let key = UserDefaultsKey<Double?>("double")
        XCTAssert(defaults[key] == nil)
        defaults[key] = 10
        XCTAssert(defaults[key] == 10.0)
    }
    
    func testStaticDouble() {
        let key = UserDefaultsKey<Double>("double")
        XCTAssert(defaults[key] == 0)
        defaults[key] = 2.14
        defaults[key] += 1
        XCTAssert(defaults[key] == 3.14)
    }
    
    func testStaticBoolOptional() {
        let key = UserDefaultsKey<Bool?>("bool")
        XCTAssert(defaults[key] == nil)
        defaults[key] = true
        XCTAssert(defaults[key] == true)
        defaults[key] = false
        XCTAssert(defaults[key] == false)
    }
    
    func testStaticBool() {
        let key = UserDefaultsKey<Bool>("bool")
        XCTAssert(!defaults.havingKey("bool"))
        XCTAssert(defaults[key] == false)
        defaults[key] = true
        XCTAssert(defaults[key] == true)
        defaults[key] = false
        XCTAssert(defaults[key] == false)
    }
    
    func testStaticNSObject() {
        let key = UserDefaultsKey<NSObject?>("object")
        XCTAssert(defaults[key] == nil)
        defaults[key] = "foo"
        XCTAssert(defaults[key] as? NSString == "foo")
        defaults[key] = NSDate.distantPast()
        XCTAssert(defaults[key] as? NSDate == NSDate.distantPast())
    }
    
    func testStaticDataOptional() {
        let key = UserDefaultsKey<NSData?>("data")
        XCTAssert(defaults[key] == nil)
        let data = "foobar".dataUsingEncoding(NSUTF8StringEncoding)!
        defaults[key] = data
        XCTAssert(defaults[key] == data)
    }
    
    func testStaticData() {
        let key = UserDefaultsKey<NSData>("data")
        XCTAssert(defaults[key] == NSData())
        let data = "foobar".dataUsingEncoding(NSUTF8StringEncoding)!
        defaults[key] = data
        XCTAssert(defaults[key] == data)
    }
    
    func testStaticDate() {
        let key = UserDefaultsKey<NSDate?>("date")
        XCTAssert(defaults[key] == nil)
        defaults[key] = NSDate.distantPast()
        XCTAssert(defaults[key] == NSDate.distantPast())
        let now = NSDate()
        defaults[key] = now
        XCTAssert(defaults[key] == now)
    }
    
    func testStaticURL() {
        let key = UserDefaultsKey<NSURL?>("url")
        XCTAssert(defaults[key] == nil)
        defaults[key] = NSURL(string: "https://github.com")
        XCTAssert(defaults[key]! == NSURL(string: "https://github.com"))
        
        defaults["url"] = "~/Desktop"
        XCTAssert(defaults[key]! == NSURL(fileURLWithPath: ("~/Desktop" as NSString).stringByExpandingTildeInPath))
    }
    
    func testStaticDictionaryOptional() {
        let key = UserDefaultsKey<[String: AnyObject]?>("dictionary")
        XCTAssert(defaults[key] == nil)
        defaults[key] = ["foo": "bar", "bar": 123, "baz": NSData()]
        XCTAssert(defaults[key]! as NSDictionary == ["foo": "bar", "bar": 123, "baz": NSData()])
    }
    
    func testStaticDictionary() {
        let key = UserDefaultsKey<[String: AnyObject]>("dictionary")
        XCTAssert(defaults[key] as NSDictionary == [:])
        defaults[key] = ["foo": "bar", "bar": 123, "baz": NSData()]
        XCTAssert(defaults[key] as NSDictionary == ["foo": "bar", "bar": 123, "baz": NSData()])
        defaults[key]["lol"] = NSDate.distantFuture()
        XCTAssert(defaults[key]["lol"] as! NSDate == NSDate.distantFuture())
        defaults[key]["lol"] = nil
        defaults[key]["baz"] = nil
        XCTAssert(defaults[key] as NSDictionary == ["foo": "bar", "bar": 123])
    }
    
    // --
    
    func testStaticArrayOptional() {
        let key = UserDefaultsKey<[AnyObject]?>("nsarray")
        XCTAssert(defaults[key] == nil)
        defaults[key] = []
        XCTAssert(defaults[key]! as NSArray == [])
        defaults[key] = [1, "foo", NSData()]
        XCTAssert(defaults[key]! as NSArray == [1, "foo", NSData()])
    }
    
    func testStaticArray() {
        let key = UserDefaultsKey<[AnyObject]>("nsarray")
        XCTAssert(defaults[key] as NSArray == [])
        defaults[key] = [1, "foo", NSData()]
        XCTAssert(defaults[key] as NSArray == [1, "foo", NSData()])
    }
    
    func testMutatingStaticArray() {
        let key = UserDefaultsKey<[AnyObject]>("array")
        XCTAssert(defaults[key] as NSArray == [])
        defaults[key].append(1)
        defaults[key].append("foo")
        defaults[key].append(false)
        defaults[key].append(NSData())
        XCTAssert(defaults[key] as NSArray == [1, "foo", false, NSData()])
    }
    
    // --
    
    func testStaticStringArrayOptional() {
        let key = UserDefaultsKey<[String]?>("strings")
        XCTAssert(defaults[key] == nil)
        defaults[key] = ["foo", "bar"]
        defaults[key]?.append("baz")
        XCTAssert(defaults[key]! == ["foo", "bar", "baz"])
        
        // bad types
        defaults["strings"] = [1, 2, false, "foo"]
        XCTAssert(defaults[key] == nil)
    }
    
    func testStaticStringArray() {
        let key = UserDefaultsKey<[String]>("strings")
        XCTAssert(defaults[key] == [])
        defaults[key] = ["foo", "bar"]
        defaults[key].append("baz")
        XCTAssert(defaults[key] == ["foo", "bar", "baz"])
        
        // bad types
        defaults["strings"] = [1, 2, false, "foo"]
        XCTAssert(defaults[key] == [])
    }
    
    func testStaticIntArrayOptional() {
        let key = UserDefaultsKey<[Int]?>("ints")
        XCTAssert(defaults[key] == nil)
        defaults[key] = [1, 2, 3]
        XCTAssert(defaults[key]! == [1, 2, 3])
    }
    
    func testStaticIntArray() {
        let key = UserDefaultsKey<[Int]>("ints")
        XCTAssert(defaults[key] == [])
        defaults[key] = [3, 2, 1]
        defaults[key].sortInPlace()
        XCTAssert(defaults[key] == [1, 2, 3])
    }
    
    func testStaticDoubleArrayOptional() {
        let key = UserDefaultsKey<[Double]?>("doubles")
        XCTAssert(defaults[key] == nil)
        defaults[key] = [1.1, 2.2, 3.3]
        XCTAssert(defaults[key]! == [1.1, 2.2, 3.3])
    }
    
    func testStaticDoubleArray() {
        let key = UserDefaultsKey<[Double]>("doubles")
        XCTAssert(defaults[key] == [])
        defaults[key] = [1.1, 2.2, 3.3]
        XCTAssert(defaults[key] == [1.1, 2.2, 3.3])
    }
    
    func testStaticBoolArrayOptional() {
        let key = UserDefaultsKey<[Bool]?>("bools")
        XCTAssert(defaults[key] == nil)
        defaults[key] = [true, false, true]
        XCTAssert(defaults[key]! == [true, false, true])
    }
    
    func testStaticBoolArray() {
        let key = UserDefaultsKey<[Bool]>("bools")
        XCTAssert(defaults[key] == [])
        defaults[key] = [true, false, true]
        XCTAssert(defaults[key] == [true, false, true])
    }
    
    func testStaticDataArrayOptional() {
        let key = UserDefaultsKey<[NSData]?>("datas")
        XCTAssert(defaults[key] == nil)
        let data = "foobar".dataUsingEncoding(NSUTF8StringEncoding)!
        defaults[key] = [data, NSData()]
        XCTAssert(defaults[key]! == [data, NSData()])
    }
    
    func testStaticDataArray() {
        let key = UserDefaultsKey<[NSData]>("datas")
        XCTAssert(defaults[key] == [])
        defaults[key] = [NSData()]
        XCTAssert(defaults[key] == [NSData()])
    }
    
    func testStaticDateArrayOptional() {
        let key = UserDefaultsKey<[NSDate]?>("dates")
        XCTAssert(defaults[key] == nil)
        defaults[key] = [NSDate.distantFuture()]
        XCTAssert(defaults[key]! == [NSDate.distantFuture()])
    }
    
    func testStaticDateArray() {
        let key = UserDefaultsKey<[NSDate]>("dates")
        XCTAssert(defaults[key] == [])
        defaults[key] = [NSDate.distantFuture()]
        XCTAssert(defaults[key] == [NSDate.distantFuture()])
    }
    
    func testShortcutsAndExistence() {
        XCTAssert(defaults[.strings] == [])
        XCTAssert(!defaults.havingKey(.strings))
        
        defaults[.strings] = []
        
        XCTAssert(defaults[.strings] == [])
        XCTAssert(defaults.havingKey(.strings))
        
        defaults.removeObjectForKey(.strings)
        
        XCTAssert(defaults[.strings] == [])
        XCTAssert(!defaults.havingKey(.strings))
    }
    
    func testShortcutsAndExistence2() {
        XCTAssert(defaults[.optStrings] == nil)
        XCTAssert(!defaults.havingKey(.optStrings))
        
        defaults[.optStrings] = []
        
        XCTAssert(defaults[.optStrings]! == [])
        XCTAssert(defaults.havingKey(.optStrings))
        
        defaults[.optStrings] = nil
        
        XCTAssert(defaults[.optStrings] == nil)
        XCTAssert(!defaults.havingKey(.optStrings))
    }
    
    // --
    
    func testArchiving() {
        let key = UserDefaultsKey<NSColor?>("color")
        XCTAssert(defaults[key] == nil)
        defaults[key] = .whiteColor()
        XCTAssert(defaults[key]! == NSColor.whiteColor())
        defaults[key] = nil
        XCTAssert(defaults[key] == nil)
    }
    
    func testArchiving2() {
        let key = UserDefaultsKey<NSColor>("color")
        XCTAssert(!defaults.havingKey(key))
        XCTAssert(defaults[key] == NSColor.whiteColor())
        defaults[key] = .blackColor()
        XCTAssert(defaults[key] == NSColor.blackColor())
    }
    
    func testArchiving3() {
        let key = UserDefaultsKey<[NSColor]>("colors")
        XCTAssert(defaults[key] == [])
        defaults[key] = [.blackColor()]
        defaults[key].append(.whiteColor())
        defaults[key].append(.redColor())
        XCTAssert(defaults[key] == [.blackColor(), .whiteColor(), .redColor()])
    }
    
    // --
    
    func testEnumArchiving() {
        let key = UserDefaultsKey<TestEnum?>("enum")
        XCTAssert(defaults[key] == nil)
        defaults[key] = .A
        XCTAssert(defaults[key]! == .A)
        defaults[key] = .C
        XCTAssert(defaults[key]! == .C)
        defaults[key] = nil
        XCTAssert(defaults[key] == nil)
    }
    
    func testEnumArchiving2() {
        let key = UserDefaultsKey<TestEnum>("enum")
        XCTAssert(!defaults.havingKey(key))
        XCTAssert(defaults[key] == .A)
        defaults[key] = .C
        XCTAssert(defaults[key] == .C)
        defaults.removeObjectForKey(key)
        XCTAssert(!defaults.havingKey(key))
        XCTAssert(defaults[key] == .A)
    }
    
    func testEnumArchiving3() {
        let key = UserDefaultsKey<TestEnum2?>("enum")
        XCTAssert(defaults[key] == nil)
        defaults[key] = .Ten
        XCTAssert(defaults[key]! == .Ten)
        defaults[key] = .Thirty
        XCTAssert(defaults[key]! == .Thirty)
        defaults[key] = nil
        XCTAssert(defaults[key] == nil)
    }
}

extension NSUserDefaults.Keys {
    static let strings = UserDefaultsKey<[String]>("strings")
    static let optStrings = UserDefaultsKey<[String]?>("strings")
}
