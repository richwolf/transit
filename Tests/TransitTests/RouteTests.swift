//
//  RouteTests.swift
//

import XCTest
@testable import Transit

final class RouteTests: XCTestCase {
  
  var routesURL: URL? = nil;
  
  override func setUp() {
    super.setUp()
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
    XCTAssertEqual(RouteField.dropoffPolicy.path, \Route.dropoffPolicy)
  }
}
