//
//  AnyCodableTests.swift
//  AnyCodableTests
//
//  Created by Valerio Mazzeo on 14/03/2018.
//  Copyright © 2018 Asensei. All rights reserved.
//

import XCTest
@testable import AnyCodable

class AnyCodableTests: XCTestCase {

    static let allTests = [
        ("testEncodable", testEncodable),
        ("testDecodable", testDecodable)
    ]

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testEncodable() throws {

        let anyCodable = AnyCodable(AnyCodableTests.mockDataStructure)
        let data = try JSONEncoder().encode(anyCodable)

        let dataString = String(data: data, encoding: .utf8)!

        XCTAssertNoThrow(try JSONDecoder().decode(AnyCodable.self, from: data))
        XCTAssertTrue(dataString.contains("\"dictionary\":{\"key\":\"value\"}"))
        XCTAssertTrue(dataString.contains("\"optionalDictionary\":{\"key\":\"value\",\"nil\":null}") || dataString.contains("\"optionalDictionary\":{\"nil\":null,\"key\":\"value\"}"))
        XCTAssertTrue(dataString.contains("\"array\":[\"a\",\"b\",\"c\"]"))
        XCTAssertTrue(dataString.contains("\"optionalArray\":[\"a\",\"b\",\"c\",null]"))
        XCTAssertTrue(dataString.contains("\"bool\":true"))
        XCTAssertTrue(dataString.contains("\"int\":1"))
        XCTAssertTrue(dataString.contains("\"int8\":1"))
        XCTAssertTrue(dataString.contains("\"int16\":1"))
        XCTAssertTrue(dataString.contains("\"int32\":1"))
        XCTAssertTrue(dataString.contains("\"int64\":1"))
        XCTAssertTrue(dataString.contains("\"uint\":1"))
        XCTAssertTrue(dataString.contains("\"uint8\":1"))
        XCTAssertTrue(dataString.contains("\"uint16\":1"))
        XCTAssertTrue(dataString.contains("\"uint32\":1"))
        XCTAssertTrue(dataString.contains("\"uint64\":1"))
        XCTAssertTrue(dataString.contains("\"float\":1.1"))
        XCTAssertTrue(dataString.contains("\"double\":1.1"))
        XCTAssertTrue(dataString.contains("\"double-rounded\":2"))
        XCTAssertTrue(dataString.contains("\"string\":\"test\""))
        XCTAssertTrue(dataString.contains("\"nil\":null"))
    }

    func testDecodable() throws {

        let data = try JSONSerialization.data(withJSONObject: AnyCodableTests.mockDataStructure)

        let anyCodable = try JSONDecoder().decode(AnyCodable.self, from: data)
        let any = anyCodable.value as! [String: Any?]

        XCTAssertEqual(any["dictionary"] as! [String: String], ["key": "value"])
        XCTAssertEqual((any["optionalDictionary"] as! [String: Any?])["key"] as? String, "value")
        XCTAssertNil((any["optionalDictionary"] as! [String: Any?])["nil"]!)
        XCTAssertEqual(any["array"] as! [String], ["a", "b", "c"])
        XCTAssertEqual((any["optionalArray"] as! [String?])[0], "a")
        XCTAssertEqual((any["optionalArray"] as! [String?])[1], "b")
        XCTAssertEqual((any["optionalArray"] as! [String?])[2], "c")
        XCTAssertNil((any["optionalArray"] as! [String?])[3])
        XCTAssertEqual(any["bool"] as! Bool, true)
        XCTAssertEqual(any["int"] as! Int, Int(1))
        XCTAssertEqual(any["int8"] as! Int, Int(1))
        XCTAssertEqual(any["int16"] as! Int, Int(1))
        XCTAssertEqual(any["int32"] as! Int, Int(1))
        XCTAssertEqual(any["int64"] as! Int, Int(1))
        XCTAssertEqual(any["uint"] as! Int, Int(1))
        XCTAssertEqual(any["uint8"] as! Int, Int(1))
        XCTAssertEqual(any["uint16"] as! Int, Int(1))
        XCTAssertEqual(any["uint32"] as! Int, Int(1))
        XCTAssertEqual(any["uint64"] as! Int, Int(1))
        XCTAssertEqual(any["float"] as! Double, Double(1.1), accuracy: 0.001)
        XCTAssertEqual(any["double"] as! Double, Double(1.1), accuracy: 0.001)
        XCTAssertEqual(any["double-rounded"] as! Int, Int(2))
        XCTAssertEqual(any["string"] as! String, "test")
        XCTAssertNil(any["nil"]!)
    }

    func testPlistEncodable() throws {

        let anyCodable = AnyCodable(AnyCodableTests.mockDataStructure)
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let data = try encoder.encode(anyCodable)

        let dataString = String(data: data, encoding: .utf8)!

        XCTAssertNoThrow(try PropertyListDecoder().decode(AnyCodable.self, from: data))
        XCTAssertTrue(dataString.contains("""
            <key>optionalDictionary</key>\n\t<dict>\n\t\t<key>key</key>\n\t\t<string>value</string>\n\t\t<key>nil</key>\n\t\t<string>$null</string>\n\t</dict>
            """))
    }

    func testPlistDecodable() throws {

        let input = AnyCodable(AnyCodableTests.mockDataStructure)
        let data = try PropertyListEncoder().encode(input)

        let output = try PropertyListDecoder().decode(AnyCodable.self, from: data)
        let any = output.value as! [String: Any?]

        XCTAssertEqual(any["dictionary"] as! [String: String], ["key": "value"])
        XCTAssertEqual((any["optionalDictionary"] as! [String: Any?])["key"] as? String, "value")
        XCTAssertNil((any["optionalDictionary"] as! [String: Any?])["nil"]!)
        XCTAssertEqual(any["array"] as! [String], ["a", "b", "c"])
        XCTAssertEqual((any["optionalArray"] as! [String?])[0], "a")
        XCTAssertEqual((any["optionalArray"] as! [String?])[1], "b")
        XCTAssertEqual((any["optionalArray"] as! [String?])[2], "c")
        XCTAssertNil((any["optionalArray"] as! [String?])[3])
        XCTAssertEqual(any["bool"] as! Bool, true)
        XCTAssertEqual(any["int"] as! Int, Int(1))
        XCTAssertEqual(any["int8"] as! Int, Int(1))
        XCTAssertEqual(any["int16"] as! Int, Int(1))
        XCTAssertEqual(any["int32"] as! Int, Int(1))
        XCTAssertEqual(any["int64"] as! Int, Int(1))
        XCTAssertEqual(any["uint"] as! Int, Int(1))
        XCTAssertEqual(any["uint8"] as! Int, Int(1))
        XCTAssertEqual(any["uint16"] as! Int, Int(1))
        XCTAssertEqual(any["uint32"] as! Int, Int(1))
        XCTAssertEqual(any["uint64"] as! Int, Int(1))
        XCTAssertEqual(any["float"] as! Double, Double(1.1), accuracy: 0.001)
        XCTAssertEqual(any["double"] as! Double, Double(1.1), accuracy: 0.001)
        XCTAssertEqual(any["double-rounded"] as! Int, Int(2))
        XCTAssertEqual(any["string"] as! String, "test")
        XCTAssertNil(any["nil"]!)
    }

    func testPlistFile() throws {
        let data = try testData(forResource: "test", ofType: "plist")
        XCTAssertNoThrow(try PropertyListDecoder().decode(AnyCodable.self, from: data))
    }
}

extension AnyCodableTests {

    static let mockDataStructure: [String: Any] = [
        "dictionary": ["key": "value"],
        "optionalDictionary": ["key": "value", "nil": nil],
        "array": ["a", "b", "c"],
        "optionalArray": ["a", "b", "c", nil],
        "bool": true,
        "int": Int(1),
        "int8": Int8(1),
        "int16": Int16(1),
        "int32": Int32(1),
        "int64": Int64(1),
        "uint": UInt(1),
        "uint8": UInt8(1),
        "uint16": UInt16(1),
        "uint32": UInt32(1),
        "uint64": UInt64(1),
        "float": Float(1.1),
        "double": Double(1.1),
        "double-rounded": Double(2.00),
        "string": "test",
        "nil": NSNull(),
        "decimal": Decimal(1.23),
        "decimalNumber": NSDecimalNumber(decimal: 1.23),
        "number-bool": NSNumber(value: 1),
        "number-int": NSNumber(value: 2)
    ]
}

func testData(forResource resource: String, ofType type: String) throws -> Data {
    let bundle = Bundle(for: AnyCodableTests.self)
    let path = bundle.path(forResource: resource, ofType: type)!
    let url = URL(fileURLWithPath: path)
    return try Data(contentsOf: url)
}
