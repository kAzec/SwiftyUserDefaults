# Transient

![Platforms](https://img.shields.io/badge/platforms-ios%20%7C%20osx%20%7C%20watchos%20%7C%20tvos-lightgrey.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](#carthage)
![Swift version](https://img.shields.io/badge/swift-2.2-orange.svg)

#### Modern Swift API for `NSUserDefaults`
###### Transient makes user defaults enjoyable to use by combining expressive Swifty API with the benefits of static typing. Define your keys in one place, use value types easily, and get extra safety and convenient compile-time checks for free.

Read [Statically-typed NSUserDefaults](http://radex.io/swift/nsuserdefaults/static) for more information about this project.

-------
<p align="center">
    <a href="#features">Features</a> &bull;
    <a href="#usage">Usage</a> &bull;
    <a href="#custom-types">Custom types</a> &bull;
    <a href="#traditional-api">Traditional API</a> &bull; 
    <a href="#installation">Installation</a> &bull; 
    <a href="#more-like-this">More info</a>
</p>
-------

## Features

**There's only two steps to using Transient:**

Step 1: Define your keys

```swift
extension NSUserDefaults.Keys {
    static let username = UserDefaultsKey<String?>("username")
    static let launchCount = UserDefaultsKey<Int>("launchCount")
}
```

Step 2: Just use it!

```swift
let defaults = NSUserDefaults.standardUserDefaults()

// Get and set user defaults easily
let username = defaults[.username]
defaults[.hotkeyEnabled] = true

// Modify value types in place
defaults[.launchCount]++
defaults[.volume] += 0.1
defaults[.strings] += "… can easily be extended!"

// Use and modify typed arrays
defaults[.libraries].append("Transient")
defaults[.libraries][0] += " 2.0"

// Easily work with custom serialized types
defaults[.color] = NSColor.whiteColor()
defaults[.color]?.whiteComponent // => 1.0
```

The convenient dot syntax is only available if you define your keys by extending magic `NSUserDefaults.Keys` class. You can also just pass the `UserDefaultsKey` value in square brackets, or use a more traditional string-based API. How? Keep reading.

## Usage

### Define your keys

To get the most out of Transient, define your user defaults keys ahead of time:

```swift
let colorKey = UserDefaultsKey<String>("color")
```

Just create a `UserDefaultsKey` object, put the type of the value you want to store in angle brackets, the key name in parentheses, and you're good to go.

```swift
defaults[colorKey] = "red"
defaults[colorKey] // => "red", typed as String
```

The compiler won't let you set a wrong value type, and fetching conveniently returns `String`.

### Take shortcuts

For extra convenience, define your keys by extending magic `NSUserDefaults.Keys` class and adding static properties:

```swift
extension NSUserDefaults.Keys {
    static let username = UserDefaultsKey<String?>("username")
    static let launchCount = UserDefaultsKey<Int>("launchCount")
}
```

And use the shortcut dot syntax:

```swift
defaults[.username] = "joe"
defaults[.launchCount]
```

### Just use it!

You can easily modify value types (strings, numbers, array) in place, as if you were working with a plain old dictionary:

```swift
// Modify value types in place
defaults[.launchCount]++
defaults[.volume] += 0.1
defaults[.strings] += "… can easily be extended!"

// Use and modify typed arrays
defaults[.libraries].append("Transient")
defaults[.libraries][0] += " 2.0"

// Easily work with custom serialized types
defaults[.color] = NSColor.whiteColor()
defaults[.color]?.whiteComponent // => 1.0
```

### Supported types

Transient supports all of the standard `NSUserDefaults` types, like strings, numbers, booleans, arrays and dictionaries.

Here's a full table:

| Optional variant       | Non-optional variant  | Default value |
|------------------------|-----------------------|---------------|
| `String?`              | `String`              | `""`          |
| `Int?`                 | `Int`                 | `0`           |
| `Double?`              | `Double`              | `0.0`         |
| `Bool?`                | `Bool`                | `false`       |
| `NSData?`              | `NSData`              | `NSData()`    |
| `NSObject?`            | n/a                   | n/a           |
| `NSDate?`              | n/a                   | n/a           |
| `NSURL?`               | n/a                   | n/a           |
| `NSUUID?`              | n/a                   | n/a           |
| `[AnyObject]?`         | `[AnyObject]`         | `[]`          |
| `[String: AnyObject]?` | `[String: AnyObject]` | `[:]`         |

You can mark a type as optional to get `nil` if the key doesn't exist. Otherwise, you'll get a default value that makes sense for a given type.

#### Typed arrays

Additionally, typed arrays are available for these types:

| Array type | Optional variant |
|------------|------------------|
| `[String]` | `[String]?`      |
| `[Int]`    | `[Int]?`         |
| `[Double]` | `[Double]?`      |
| `[Bool]`   | `[Bool]?`        |
| `[NSData]` | `[NSData]?`      |
| `[NSDate]` | `[NSDate]?`      |

### Custom types

You can easily store custom `NSCoding`-compliant types by extending `NSUserDefaults` with this stub subscript:

```swift
extension NSUserDefaults {
    subscript(key: UserDefaultsKey<NSColor?>) -> NSColor? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }
}
```

Just copy&paste this and change `NSColor` to your class name.

Here's a usage example:

```swift
extension NSUserDefaults.Keys {
    static let color = UserDefaultsKey<NSColor?>("color")
}

defaults[.color] // => nil
defaults[.color] = NSColor.whiteColor()
defaults[.color] // => w 1.0, a 1.0
defaults[.color]?.whiteComponent // => 1.0
```

#### Custom types with default values

If you don't want to deal with `nil` when fetching a user default value, you can remove `?` marks and supply the default value, like so:

```swift
extension NSUserDefaults {
    subscript(key: UserDefaultsKey<NSColor>) -> NSColor {
        get { return unarchive(key) ?? NSColor.clearColor() }
        set { archive(key, newValue) }
    }
}
```

#### Enums

In addition to `NSCoding`, you can store `enum` values the same way:

```swift
enum MyEnum: String {
    case A, B, C
}

extension NSUserDefaults {
    subscript(key: UserDefaultsKey<MyEnum?>) -> MyEnum? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }
}
```

The only requirement is that the enum has to be `RawRepresentable` by a simple type like `String` or `Int`.

### Existence

```swift
if !defaults.havingKey(.hotkey) {
    defaults.removeObjectForKey(.hotkeyOptions)
}
```

You can use the `havingKey` method to check for key's existence in the user defaults, plus the `removeObjectForKey(_:)` method which works with `UserDefaultsKeys` instance instead of plain String.

## Traditional API

There's also a more traditional string-based API available. This is considered legacy API, and it's recommended that you use statically defined keys instead.

```swift
defaults["color"].string            // returns String?
defaults["launchCount"].int         // returns Int?
defaults["chimeVolume"].double      // returns Double?
defaults["loggingEnabled"].bool     // returns Bool?
defaults["lastPaths"].array         // returns NSArray?
defaults["credentials"].dictionary  // returns NSDictionary?
defaults["hotkey"].data             // returns NSData?
defaults["firstLaunchAt"].date      // returns NSDate?
defaults["anything"].object         // returns NSObject?
defaults["anything"].number         // returns NSNumber?
```

When you don't want to deal with the `nil` case, you can use these helpers that return a default value for non-existing defaults:

```swift
defaults["color"].stringValue            // defaults to ""
defaults["launchCount"].intValue         // defaults to 0
defaults["chimeVolume"].doubleValue      // defaults to 0.0
defaults["loggingEnabled"].boolValue     // defaults to false
defaults["lastPaths"].arrayValue         // defaults to []
defaults["credentials"].dictionaryValue  // defaults to [:]
defaults["hotkey"].dataValue             // defaults to NSData()
```

## Installation
#### Carthage

Just add to your Cartfile:

```ruby
github "kAzec/Transient"
```

#### Manually

Simply copy `Sources/*.swift` to your Xcode project.

## More

If you like Transient, check out [SwiftyTimer](https://github.com/radex/SwiftyTimer), which applies the same swifty approach to `NSTimer`.

You might also be interested in my blog posts which explain the design process behind those libraries:
- [Swifty APIs: NSUserDefaults](http://radex.io/swift/nsuserdefaults/)
- [Statically-typed NSUserDefaults](http://radex.io/swift/nsuserdefaults/static)
- [Swifty APIs: NSTimer](http://radex.io/swift/nstimer/)
- [Swifty methods](http://radex.io/swift/methods/)

### Contributing

If you have comments, complaints or ideas for improvements, feel free to open an issue or a pull request. Or [ping me on Twitter](http://twitter.com/radexp).

### Author and license

Radek Pietruszewski

* [github.com/radex](http://github.com/radex)
* [twitter.com/radexp](http://twitter.com/radexp)
* [radex.io](http://radex.io)
* this.is@radex.io

kAzec

* [github.com/kAzec](http://github.com/kAzec)

And other contributors.

Transient is available under the MIT license. See the LICENSE file for more info.

