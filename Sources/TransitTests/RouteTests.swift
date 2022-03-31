//
// RouteTests.swift
//

import XCTest
@testable import Transit

final class RouteTests: XCTestCase {

  var routeFileURL: URL?

	override func setUp() {
		super.setUp()
		self.routeFileURL =
			Bundle.module.url(forResource: "route", withExtension: "txt")
	}

  func test_keyPath() {
    XCTAssertEqual(RouteField.routeID.path, \Route.routeID)
    XCTAssertEqual(RouteField.agencyID.path, \Route.agencyID)
    XCTAssertEqual(RouteField.name.path, \Route.name)
    XCTAssertEqual(RouteField.shortName.path, \Route.shortName)
    XCTAssertEqual(RouteField.details.path, \Route.details)
    XCTAssertEqual(RouteField.type.path, \Route.type)
    XCTAssertEqual(RouteField.url.path, \Route.url)
    XCTAssertEqual(RouteField.color.path, \Route.color)
    XCTAssertEqual(RouteField.textColor.path, \Route.textColor)
    XCTAssertEqual(RouteField.sortOrder.path, \Route.sortOrder)
    XCTAssertEqual(RouteField.pickupPolicy.path, \Route.pickupPolicy)
    XCTAssertEqual(RouteField.dropOffPolicy.path, \Route.dropOffPolicy)
  }
	
	func test_initWithNoArguments() {
		let route = Route()
		XCTAssertEqual(route.routeID, "Unidentified route")
		XCTAssertNil(route.agencyID)
		XCTAssertNil(route.name)
		XCTAssertNil(route.shortName)
		XCTAssertNil(route.details)
		XCTAssertEqual(route.type, .bus)
		XCTAssertNil(route.url)
		XCTAssertNil(route.color)
		XCTAssertNil(route.textColor)
		XCTAssertNil(route.sortOrder)
		XCTAssertNil(route.pickupPolicy)
		XCTAssertNil(route.dropOffPolicy)
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
