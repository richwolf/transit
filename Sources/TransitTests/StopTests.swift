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
		let stop = Stop()
		XCTAssertEqual(stop.stopID, "Unidentified stop")
		XCTAssertNil(stop.code)
		XCTAssertNil(stop.name)
		XCTAssertNil(stop.details)
		XCTAssertNil(stop.latitude)
		XCTAssertNil(stop.longitude)
		XCTAssertNil(stop.zoneID)
		XCTAssertNil(stop.url)
		XCTAssertNil(stop.locationType)
		XCTAssertNil(stop.parentStationID)
		XCTAssertNil(stop.timeZone)
		XCTAssertNil(stop.accessibility)
		XCTAssertNil(stop.levelID)
		XCTAssertNil(stop.platformCode)
	}
	
	func test_initWithSomeArguments() {
		/*
		let agency = Agency(
			name: "Chicago Transit Authority",
			url: URL(string: "http://transitchicago.com")!,
			timeZone: TimeZone(identifier: "America/Chicago")!,
			locale: Locale(identifier: "en"),
			phone: "1-888-YOURCTA",
			fareURL: URL(string: "http://www.transitchicago.com/fares")!
		)
		XCTAssertNil(agency.agencyID)
		XCTAssertEqual(agency.name, "Chicago Transit Authority")
		XCTAssertEqual(agency.url, URL(string: "http://transitchicago.com")!)
		XCTAssertEqual(agency.timeZone, TimeZone(identifier: "America/Chicago")!)
		XCTAssertEqual(agency.locale, Locale(identifier: "en"))
		XCTAssertEqual(agency.phone, "1-888-YOURCTA")
		XCTAssertEqual(agency.fareURL,
									 URL(string: "http://www.transitchicago.com/fares")!)
		XCTAssertNil(agency.email)
		 */
	}
	
	func test_initWithAllArguments() {
		/*
		let agency = Agency(
			agencyID: "Chicago Transit Authority",
			name: "Chicago Transit Authority",
			url: URL(string: "http://transitchicago.com")!,
			timeZone: TimeZone(identifier: "America/Chicago")!,
			locale: Locale(identifier: "en"),
			phone: "1-888-YOURCTA",
			fareURL: URL(string: "http://www.transitchicago.com/fares")!,
			email: "cta@transitchicago.com"
		)
		XCTAssertEqual(agency.agencyID, "Chicago Transit Authority")
		XCTAssertEqual(agency.name, "Chicago Transit Authority")
		XCTAssertEqual(agency.url, URL(string: "http://transitchicago.com")!)
		XCTAssertEqual(agency.timeZone, TimeZone(identifier: "America/Chicago")!)
		XCTAssertEqual(agency.locale, Locale(identifier: "en"))
		XCTAssertEqual(agency.phone, "1-888-YOURCTA")
		XCTAssertEqual(agency.fareURL,
									 URL(string: "http://www.transitchicago.com/fares")!)
		XCTAssertEqual(agency.email, "cta@transitchicago.com")
		 */
	}
}
