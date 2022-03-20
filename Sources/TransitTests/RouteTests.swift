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

		/*
		XCTAssertNil(agency.agencyID)
		XCTAssertEqual(agency.name, "")
		XCTAssertEqual(agency.url, URL(string: "https://unnamed.com")!)
		XCTAssertEqual(agency.timeZone, TimeZone(identifier: "UTC")!)
		XCTAssertNil(agency.locale)
		XCTAssertNil(agency.phone)
		XCTAssertNil(agency.fareURL)
		XCTAssertNil(agency.email)
		 */
	}
}
