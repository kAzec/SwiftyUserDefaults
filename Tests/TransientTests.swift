import Foundation
import XCTest

@testable import Transient

let defaults = UserDefaults.standard

class TransientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // clear defaults before testing
        for (key, _) in defaults.dictionaryRepresentation() {
            defaults.removeObject(forKey: key)
        }
    }
    
    // --
    
    func testStaticStringOptional() {
        let key = UserDefaults.Key<String?>("string")
        XCTAssert(defaults[key] == nil)
        defaults[key] = "foo"
    }
    
    func testStaticString() {
        let key = UserDefaults.Key<String>("string")
        XCTAssert(defaults[key] == "")
        defaults[key] = "foo"
        defaults[key] += "bar"
        XCTAssert(defaults[key] == "foobar")
    }
    
    func testStaticIntOptional() {
        let key = UserDefaults.Key<Int?>("int")
        XCTAssert(defaults[key] == nil)
        defaults[key] = 10
        XCTAssert(defaults[key] == 10)
    }
    
    func testStaticInt() {
        let key = UserDefaults.Key<Int>("int")
        XCTAssert(defaults[key] == 0)
        defaults[key] += 10
        XCTAssert(defaults[key] == 10)
    }
    
    func testStaticDoubleOptional() {
        let key = UserDefaults.Key<Double?>("double")
        XCTAssert(defaults[key] == nil)
        defaults[key] = 10
        XCTAssert(defaults[key] == 10.0)
    }
    
    func testStaticDouble() {
        let key = UserDefaults.Key<Double>("double")
        XCTAssert(defaults[key] == 0)
        defaults[key] = 2.14
        defaults[key] += 1
        XCTAssert(defaults[key] == 3.14)
    }
    
    func testStaticBoolOptional() {
        let key = UserDefaults.Key<Bool?>("bool")
        XCTAssert(defaults[key] == nil)
        defaults[key] = true
        XCTAssert(defaults[key] == true)
        defaults[key] = false
        XCTAssert(defaults[key] == false)
    }
    
    func testStaticBool() {
        let key = UserDefaults.Key<Bool>("bool")
        XCTAssert(!defaults.havingKey("bool"))
        XCTAssert(defaults[key] == false)
        defaults[key] = true
        XCTAssert(defaults[key] == true)
        defaults[key] = false
        XCTAssert(defaults[key] == false)
    }
    
    func testStaticDataOptional() {
        let key = UserDefaults.Key<Data?>("data")
        XCTAssert(defaults[key] == nil)
        let data = "foobar".data(using: String.Encoding.utf8)!
        defaults[key] = data
        XCTAssert(defaults[key] == data)
    }
    
    func testStaticData() {
        let key = UserDefaults.Key<Data>("data")
        XCTAssert(defaults[key] == Data())
        let data = "foobar".data(using: String.Encoding.utf8)!
        defaults[key] = data
        XCTAssert(defaults[key] == data)
    }
    
    func testStaticDate() {
        let key = UserDefaults.Key<Date?>("date")
        XCTAssert(defaults[key] == nil)
        defaults[key] = Date.distantPast
        XCTAssert(defaults[key] == Date.distantPast)
        let now = Date()
        defaults[key] = now
        XCTAssert(defaults[key] == now)
    }
    
    func testStaticURL() {
        let key = UserDefaults.Key<URL?>("url")
        XCTAssert(defaults[key] == nil)
        defaults[key] = URL(string: "https://github.com")
        XCTAssert(defaults[key]! == URL(string: "https://github.com"))
    }
    
    func testStaticDictionaryOptional() {
        let key = UserDefaults.Key<[String: Any]?>("dictionary")
        XCTAssert(defaults[key] == nil)
        defaults[key] = ["foo": "bar", "bar": 123, "baz": Data()]
        XCTAssert(defaults[key]! as NSDictionary == ["foo": "bar", "bar": 123, "baz": Data()])
    }
    
    func testStaticDictionary() {
        let key = UserDefaults.Key<[String: Any]>("dictionary")
        XCTAssert(defaults[key] as NSDictionary == [:])
        defaults[key] = ["foo": "bar", "bar": 123, "baz": Data()]
        XCTAssert(defaults[key] as NSDictionary == ["foo": "bar", "bar": 123, "baz": Data()])
        defaults[key]["lol"] = Date.distantFuture
        XCTAssert(defaults[key]["lol"] as! Date == .distantFuture)
        defaults[key]["lol"] = nil
        defaults[key]["baz"] = nil
        XCTAssert(defaults[key] as NSDictionary == ["foo": "bar", "bar": 123])
    }
    
    // --
    
    func testStaticArrayOptional() {
        let key = UserDefaults.Key<[Any]?>("array")
        XCTAssert(defaults[key] == nil)
        defaults[key] = []
        XCTAssertEqual(defaults[key]?.count, 0)
        defaults[key] = [1, "foo", Data()]
        XCTAssertEqual(defaults[key]?.count, 3)
        XCTAssertEqual(defaults[key]?[0] as? Int, 1)
        XCTAssertEqual(defaults[key]?[1] as? String, "foo")
        XCTAssertEqual(defaults[key]?[2] as? Data, Data())
    }
    
    func testStaticArray() {
        let key = UserDefaults.Key<[Any]>("array")
        XCTAssertEqual(defaults[key].count, 0)
        defaults[key].append(1)
        defaults[key].append("foo")
        defaults[key].append(Data())
        XCTAssertEqual(defaults[key].count, 3)
        XCTAssertEqual(defaults[key][0] as? Int, 1)
        XCTAssertEqual(defaults[key][1] as? String, "foo")
        XCTAssertEqual(defaults[key][2] as? Data, Data())
    }
    
    func testMutatingStaticArray() {
        let key = UserDefaults.Key<[Any]>("array")
        XCTAssert(defaults[key] as NSArray == [])
        defaults[key].append(1)
        defaults[key].append("foo")
        defaults[key].append(false)
        defaults[key].append(Data())
        XCTAssert(defaults[key] as NSArray == [1, "foo", false, Data()])
    }
    
    // --
    
    func testStaticStringArrayOptional() {
        let key = UserDefaults.Key<[String]?>("strings")
        XCTAssert(defaults[key] == nil)
        defaults[key] = ["foo", "bar"]
        defaults[key]?.append("baz")
        XCTAssert(defaults[key]! == ["foo", "bar", "baz"])
    }
    
    func testStaticStringArray() {
        let key = UserDefaults.Key<[String]>("strings")
        XCTAssert(defaults[key] == [])
        defaults[key] = ["foo", "bar"]
        defaults[key].append("baz")
        XCTAssert(defaults[key] == ["foo", "bar", "baz"])
    }
    
    func testStaticIntArrayOptional() {
        let key = UserDefaults.Key<[Int]?>("ints")
        XCTAssert(defaults[key] == nil)
        defaults[key] = [1, 2, 3]
        XCTAssert(defaults[key]! == [1, 2, 3])
    }
    
    func testStaticIntArray() {
        let key = UserDefaults.Key<[Int]>("ints")
        XCTAssert(defaults[key] == [])
        defaults[key] = [3, 2, 1]
        defaults[key].sort()
        XCTAssert(defaults[key] == [1, 2, 3])
    }
    
    func testStaticDoubleArrayOptional() {
        let key = UserDefaults.Key<[Double]?>("doubles")
        XCTAssert(defaults[key] == nil)
        defaults[key] = [1.1, 2.2, 3.3]
        XCTAssert(defaults[key]! == [1.1, 2.2, 3.3])
    }
    
    func testStaticDoubleArray() {
        let key = UserDefaults.Key<[Double]>("doubles")
        XCTAssert(defaults[key] == [])
        defaults[key] = [1.1, 2.2, 3.3]
        XCTAssert(defaults[key] == [1.1, 2.2, 3.3])
    }
    
    func testStaticBoolArrayOptional() {
        let key = UserDefaults.Key<[Bool]?>("bools")
        XCTAssert(defaults[key] == nil)
        defaults[key] = [true, false, true]
        XCTAssert(defaults[key]! == [true, false, true])
    }
    
    func testStaticBoolArray() {
        let key = UserDefaults.Key<[Bool]>("bools")
        XCTAssert(defaults[key] == [])
        defaults[key] = [true, false, true]
        XCTAssert(defaults[key] == [true, false, true])
    }
    
    func testStaticDataArrayOptional() {
        let key = UserDefaults.Key<[Data]?>("datas")
        XCTAssert(defaults[key] == nil)
        let data = "foobar".data(using: String.Encoding.utf8)!
        defaults[key] = [data, Data()]
        XCTAssert(defaults[key]! == [data, Data()])
    }
    
    func testStaticDataArray() {
        let key = UserDefaults.Key<[Data]>("datas")
        XCTAssert(defaults[key] == [])
        defaults[key] = [Data()]
        XCTAssert(defaults[key] == [Data()])
    }
    
    func testStaticDateArrayOptional() {
        let key = UserDefaults.Key<[Date]?>("dates")
        XCTAssert(defaults[key] == nil)
        defaults[key] = [Date.distantFuture]
        XCTAssert(defaults[key]! == [Date.distantFuture])
    }
    
    func testStaticDateArray() {
        let key = UserDefaults.Key<[Date]>("dates")
        XCTAssert(defaults[key] == [])
        defaults[key] = [Date.distantFuture]
        XCTAssert(defaults[key] == [Date.distantFuture])
    }
    
    func testShortcutsAndExistence() {
        XCTAssert(defaults[.strings] == [])
        XCTAssert(!defaults.havingKey(.strings))
        
        defaults[.strings] = []
        
        XCTAssert(defaults[.strings] == [])
        XCTAssert(defaults.havingKey(.strings))
        
        defaults.removeObject(forKey: .strings)
        
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
        let key = UserDefaults.Key<Color?>("color")
        XCTAssert(defaults[key] == nil)
        defaults[key] = .white
        XCTAssert(defaults[key]! == Color.white)
        defaults[key] = nil
        XCTAssert(defaults[key] == nil)
    }
    
    func testArchiving2() {
        let key = UserDefaults.Key<Color>("color")
        XCTAssert(!defaults.havingKey(key))
        XCTAssert(defaults[key] == Color.white)
        defaults[key] = .black
        XCTAssert(defaults[key] == Color.black)
    }
    
    // --
    
    func testEnumArchiving() {
        let key = UserDefaults.Key<TestEnum?>("enum")
        XCTAssert(defaults[key] == nil)
        defaults[key] = .A
        XCTAssert(defaults[key]! == .A)
        defaults[key] = .C
        XCTAssert(defaults[key]! == .C)
        defaults[key] = nil
        XCTAssert(defaults[key] == nil)
    }
    
    func testEnumArchiving2() {
        let key = UserDefaults.Key<TestEnum>("enum")
        XCTAssert(!defaults.havingKey(key))
        XCTAssert(defaults[key] == .A)
        defaults[key] = .C
        XCTAssert(defaults[key] == .C)
        defaults.removeObject(forKey: key)
        XCTAssert(!defaults.havingKey(key))
        XCTAssert(defaults[key] == .A)
    }
    
    func testEnumArchiving3() {
        let key = UserDefaults.Key<TestEnum2?>("enum")
        XCTAssert(defaults[key] == nil)
        defaults[key] = .ten
        XCTAssert(defaults[key]! == .ten)
        defaults[key] = .thirty
        XCTAssert(defaults[key]! == .thirty)
        defaults[key] = nil
        XCTAssert(defaults[key] == nil)
    }
}

extension UserDefaults.Keys {
    static let strings = UserDefaults.Key<[String]>("strings")
    static let optStrings = UserDefaults.Key<[String]?>("strings")
}
