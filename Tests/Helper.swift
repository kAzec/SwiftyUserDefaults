#if os(OSX)
    import Cocoa
    typealias Color = NSColor
#else
    import UIKit
    typealias Color = UIColor
#endif

import Transient

extension UserDefaults {
    
    subscript(key: Key<Color?>) -> Color? {
        get { return retrieve(forKey: key) }
        set { store(newValue, forKey: key) }
    }
    
    subscript(key: Key<Color>) -> Color {
        get { return retrieve(forKey: key) ?? .white }
        set { store(newValue, forKey: key) }
    }
}

enum TestEnum: String {
    case A, B, C
}

extension UserDefaults {
    subscript(key: Key<TestEnum?>) -> TestEnum? {
        get { return retrieve(forKey: key) }
        set { store(newValue, forKey: key) }
    }
}

extension UserDefaults {
    subscript(key: Key<TestEnum>) -> TestEnum {
        get { return retrieve(forKey: key) ?? .A }
        set { store(newValue, forKey: key) }
    }
}

enum TestEnum2: Int {
    case ten = 10
    case twenty = 20
    case thirty = 30
}

extension UserDefaults {
    subscript(key: Key<TestEnum2?>) -> TestEnum2? {
        get { return retrieve(forKey: key) }
        set { store(newValue, forKey: key) }
    }
}
