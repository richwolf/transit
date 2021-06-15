//
//  String+Substring.swift
//

import XCTest
@testable import Transit

// MARK: Substring nextField() tests

final class Substring_nextField_Tests: XCTestCase {
  
  func test_simpleRecord() {
    var record = "one,2,three" as Substring
    XCTAssertEqual(try? record.nextField(), "one")
  }
  
  func test_singleFieldInRecord() {
    var record = "one" as Substring
    XCTAssertEqual(try? record.nextField(), "one")
  }
  
  func test_singleFieldInRecordVerifyRemainingSubstringIsEmpty() {
    var record = "one" as Substring
    _ = try? record.nextField()
    XCTAssertEqual(record, "" as Substring)
  }
  
  func test_emptyFieldInRecord() {
    var record = "" as Substring
    XCTAssertThrowsError(try record.nextField())
    { error in
      XCTAssertEqual(error as! TransitError, TransitError.emptySubstring)
      XCTAssertEqual(error.localizedDescription, "Substring is empty")
    }
  }
  
  func test_quotedField() {
    var record = "\"one\",2,three" as Substring
    XCTAssertEqual(try? record.nextField(), "one")
  }
  
  func test_quotedFieldVerifyRemainingSubstring() {
    var record = "\"one\",2,three" as Substring
    _ = try? record.nextField()
    XCTAssertEqual(record, "2,three" as Substring)
  }
  
  func test_fieldContainsUnbalancedQuotes() {
    var record = "\"one,2,three" as Substring
    XCTAssertThrowsError(try record.nextField())
    { error in
      XCTAssertEqual(error as? TransitError, TransitError.quoteExpected)
      XCTAssertEqual(error.localizedDescription, "A quote was expected, but not found")
    }
  }
  
  func test_quotedFieldAtEndOfRecord() {
    var record = "\"one\"" as Substring
    XCTAssertEqual(try? record.nextField(), "one")
  }
  
  func test_quotedFieldWithoutTrailingComma() {
    var record = "\"one\"2,three" as Substring
    XCTAssertThrowsError(try record.nextField())
    { error in
      XCTAssertEqual(error as? TransitError, TransitError.commaExpected)
      XCTAssertEqual(error.localizedDescription, "A comma was expected, but not found")
    }
  }
}

// MARK: - String readRecord() tests

final class String_readRecord_Tests: XCTestCase {
    
  func test_simpleRecord() {
    let record = "one,2,three"
    XCTAssertEqual(try? record.readRecord(), ["one", "2", "three"])
  }
  
  func test_emptyRecord() {
    let record = ""
    XCTAssertEqual(try? record.readRecord(), [])
  }
  
  func test_recordWithEmptyField() {
      let record = "one,2,,three"
      XCTAssertEqual(try? record.readRecord(), ["one", "2", "", "three"])
  }
  
  func test_recordWithQuotedField() {
      let record = "one,\"2\",three"
      XCTAssertEqual(try? record.readRecord(), ["one", "2", "three"])
  }
  
  func test_recordWithFieldContainingCommas() {
      let record = "one,\"tw,o\",three"
      XCTAssertEqual(try? record.readRecord(), ["one", "tw,o", "three"])
  }
  
  //
  
  func test_recordContainsFieldWithUnbalancedQuotes() {
    let record = "\"one,2,three"
    XCTAssertThrowsError(try record.readRecord())
    { error in
      XCTAssertEqual(error as? TransitError, TransitError.quoteExpected)
      XCTAssertEqual(error.localizedDescription, "A quote was expected, but not found")
    }
  }
  
  func test_recordContainsQuotedFieldWithoutTrailingComma() {
    let record = "\"one\"2,three"
    XCTAssertThrowsError(try record.readRecord())
    { error in
      XCTAssertEqual(error as? TransitError, TransitError.commaExpected)
      XCTAssertEqual(error.localizedDescription, "A comma was expected, but not found")
    }
  }
}

// MARK: - String readHeader() tests

final class StringReadHeaderTests: XCTestCase {
  
  func test_header() {
    let header = "agency_name,agency_url,agency_timezone"
    XCTAssertEqual(try header.readHeader() as [AgencyField],
                   [AgencyField.name, AgencyField.url, AgencyField.timeZone])
  }
  
  // TODO: A header with missing required fields should throw
  func test_emptyHeader() {
    let header = ""
    XCTAssertEqual(try header.readHeader() as [AgencyField], [])
  }
  
  func test_headerWithEmptyField() {
    let header = "agency_name,,agency_url,agency_timezone"
    XCTAssertThrowsError(try header.readHeader() as [AgencyField])
    { error in
      XCTAssertEqual(error as? TransitError, TransitError.invalidFieldType)
      XCTAssertEqual(error.localizedDescription, "An invalid field type was found")
    }
  }

  func test_headerWithTrailingComma() {
    let header = "\"agency_name,agency_url,agency_timezone"
    XCTAssertThrowsError(try header.readHeader() as [AgencyField])
    { error in
      XCTAssertEqual(error as? TransitError, TransitError.quoteExpected)
    }
  }
}
  
// MARK: - String splitRecords() tests
final class StringSplitRecordsTests: XCTestCase {

  func test_basicLines() {
      let records = "one,2,,three\nfour,five"
    XCTAssertEqual(records.splitRecords(), ["one,2,,three", "four,five"])
  }
  
  func test_linesWithCRLF() {
      let records = "one,2,,three\r\nfour,five"
    XCTAssertEqual(records.splitRecords(), ["one,2,,three", "four,five"])
  }
  
}

// MARK: - String color tests
final class StringColorTests: XCTestCase {
  
  func test_basic() {
    let colorString = "ffffffff"
    XCTAssertEqual(colorString.color, CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
  }
  
  func test_nonHexString() {
    let colorString = "uncool"
    XCTAssertNil(colorString.color)
  }
  
  func test_basicPrecededByOctothorpe() {
    let colorString = "#ffffffff"
    XCTAssertEqual(colorString.color, CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
  }
  
  func test_basicPrecededByPercentSign() {
    let colorString = "%ffffffff"
    XCTAssertNil(colorString.color)
  }
  
  func test_sixCharacters() {
    let colorString = "#ffffff"
    XCTAssertEqual(colorString.color, CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
  }
  
  func test_fiveCharacters() {
    let colorString = "%fffff"
    XCTAssertNil(colorString.color)
  }
  
}

// MARK: -

final class Blah: XCTestCase {

  func test_thing1() {
    var agency = Agency()
    let header = AgencyField.name
    let field = "Test Agency"
    try? field.assignStringTo(&agency, for: header)
    XCTAssertEqual(agency.name, "Test Agency")
  }
  
  // Test where instance does not contain field type
  func testy3() {
    var instance = Agency()
    let w = "Test Agency"
    let header = RouteField.name
    XCTAssertThrowsError(try w.assignStringTo(&instance, for: header))
    { error in
      XCTAssertEqual(error as? TransitAssignError, TransitAssignError.invalidPath)
    }
  }
  
  // Test where string value is trying to be assigned to some other type (URL)
  func testy() {
    var instance = Agency()
    let w = "stupid"
    let header = AgencyField.url
    XCTAssertThrowsError(try w.assignStringTo(&instance, for: header))
    { error in
      XCTAssertEqual(error as? TransitAssignError, TransitAssignError.invalidPath)
    }
  }
  
  // Test the error description string

}

// MARK: - String StringAndSubstringTests() tests
final class StringAndSubstringTests: XCTestCase {
    
  func test_fieldsFromAgencyWithCTAFeed() {
    let fields: [AgencyField]? = try!
      """
      agency_name,\
      agency_url,\
      agency_timezone,\
      agency_lang,\
      agency_phone,\
      agency_fare_url
      """.readHeader()
    XCTAssertEqual(fields, [.name, .url, .timeZone, .locale, .phone, .fareURL])
  }
  
  func test_fieldsFromAgencyWithAllFields() {
    let fields: [AgencyField]? = try!
      """
      agency_id,\
      agency_name,\
      agency_url,\
      agency_timezone,\
      agency_lang,\
      agency_phone,\
      agency_fare_url,\
      agency_email
      """.readHeader()
    XCTAssertEqual(fields, [.agencyID, .name, .url, .timeZone, .locale,
                            .phone, .fareURL, .email])
  }
}
