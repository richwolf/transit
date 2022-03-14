//
//  TransitTests.swift
//

import XCTest
@testable import Transit

final class TransitTests: XCTestCase {
  var agencyFileURL: URL? = nil;
  
  override func setUp() {
    super.setUp()
    let resourcePath = Bundle.module.resourcePath
    let feedURL = URL(fileURLWithPath: resourcePath!)
    let feed = Feed(contentsOfURL: feedURL)
    if let agencyName = feed.agency?.name {
      print(agencyName)
    }
    if let routes = feed.routes {
      for route in routes {
        print(route)
      }
    }
    if let stops = feed.stops {
      for stop in stops {
				print(stop)
      }
    }
  }
  
  func test_Wazzis() {
    XCTAssert(true)
  }
}

/*
func test_initWithURL() {
  if let agencyFileURL = self.agencyFileURL {
    if let agency = Feed.agencyFromFeed(url: agencyFileURL) {
      XCTAssertNil(agency.agencyID, "CTA agency ID should be nil")
      XCTAssertEqual(agency.name, "Chicago Transit Authority")
      XCTAssertEqual(agency.url, URL(string: "http://transitchicago.com"))
      XCTAssertEqual(agency.timeZone, TimeZone(identifier: "America/Chicago"))
      XCTAssertEqual(agency.language, "en")
      XCTAssertEqual(agency.phone, "1-888-YOURCTA")
      XCTAssertEqual(
        agency.fareURL,
        URL(string: "http://www.transitchicago.com/travel_information/fares/default.aspx"))
      XCTAssertNil(agency.email, "CTA email address should be nil")
    }
  }
}
*/
