//
// StopTests.swift
//

import XCTest
@testable import Transit

final class StopTests: XCTestCase {
  var stopsFileURL: URL?

  override func setUp() {
    super.setUp()
    self.stopsFileURL =
      Bundle.module.url(forResource: "stops", withExtension: "txt")
  }
	
	func test_keyPath() {
		XCTAssertEqual(StopField.stopID.path, \Stop.stopID)
		XCTAssertEqual(StopField.code.path, \Stop.code)
		XCTAssertEqual(StopField.name.path, \Stop.name)
		XCTAssertEqual(StopField.details.path, \Stop.details)
		XCTAssertEqual(StopField.latitude.path, \Stop.latitude)
		XCTAssertEqual(StopField.longitude.path, \Stop.longitude)
		XCTAssertEqual(StopField.zoneID.path, \Stop.zoneID)
		XCTAssertEqual(StopField.url.path, \Stop.url)
		XCTAssertEqual(StopField.locationType.path, \Stop.locationType)
		XCTAssertEqual(StopField.parentStationID.path, \Stop.parentStationID)
		XCTAssertEqual(StopField.timeZone.path, \Stop.timeZone)
		XCTAssertEqual(StopField.accessibility.path, \Stop.accessibility)
		XCTAssertEqual(StopField.levelID.path, \Stop.levelID)
		XCTAssertEqual(StopField.platformCode.path, \Stop.platformCode)
	}
	
	func test_initWithNoArguments() {
		let agency = Agency()
		XCTAssertNil(agency.agencyID)
		XCTAssertEqual(agency.name, "")
		XCTAssertEqual(agency.url, URL(string: "https://unnamed.com")!)
		XCTAssertEqual(agency.timeZone, TimeZone(identifier: "UTC")!)
		XCTAssertNil(agency.locale)
		XCTAssertNil(agency.phone)
		XCTAssertNil(agency.fareURL)
		XCTAssertNil(agency.email)
	}
}
