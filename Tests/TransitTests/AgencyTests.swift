import XCTest
@testable import Transit

final class AgencyTests: XCTestCase {
  
  var agencyFileURL: URL? = nil;
  
  override func setUp() {
    super.setUp()
    self.agencyFileURL =
      Bundle.module.url(forResource: "agency", withExtension: "txt")
  }
  
  func test_keyPath() {
    XCTAssertEqual(AgencyField.agencyID.path, \Agency.agencyID)
    XCTAssertEqual(AgencyField.name.path, \Agency.name)
    XCTAssertEqual(AgencyField.url.path, \Agency.url)
    XCTAssertEqual(AgencyField.timeZone.path, \Agency.timeZone)
    XCTAssertEqual(AgencyField.locale.path, \Agency.locale)
    XCTAssertEqual(AgencyField.phone.path, \Agency.phone)
    XCTAssertEqual(AgencyField.fareURL.path, \Agency.fareURL)
    XCTAssertEqual(AgencyField.email.path, \Agency.email)
  }
  
  // Init tests yet to implement:
  //  Test when passed some arguments
  //  Test when passed all arguments
  //  Init with a string that is not a URL
  //  Init with a crazy timezone
  
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
  
  func test_initWithSomeArguments() {
    let agency = Agency(name: "Chicago Transit Authority",
      url: URL(string: "http://transitchicago.com")!,
      timeZone: TimeZone(identifier: "America/Chicago")!,
      locale: Locale(identifier: "en"),
      phone: "1-888-YOURCTA",
      fareURL: URL(string: "http://www.transitchicago.com/fares")!)
    XCTAssertNil(agency.agencyID)
    XCTAssertEqual(agency.name, "Chicago Transit Authority")
    XCTAssertEqual(agency.url, URL(string: "http://transitchicago.com")!)
    XCTAssertEqual(agency.timeZone, TimeZone(identifier: "America/Chicago")!)
    XCTAssertEqual(agency.locale, Locale(identifier: "en"))
    XCTAssertEqual(agency.phone, "1-888-YOURCTA")
    XCTAssertEqual(agency.fareURL, URL(string: "http://www.transitchicago.com/fares")!)
    XCTAssertNil(agency.email)
  }
  
  //  Need to finish ...
  func test_initWithAllArguments() {
    let agency = Agency(agencyID: "Chicago Transit Authority",
      name: "Chicago Transit Authority",
      url: URL(string: "http://transitchicago.com")!,
      timeZone: TimeZone(identifier: "America/Chicago")!,
      locale: Locale(identifier: "en"),
      phone: "1-888-YOURCTA",
      fareURL: URL(string: "http://www.transitchicago.com/fares")!,
      email: "cat@transitchicago.com")
    XCTAssertEqual(agency.agencyID, "Chicago Transit Authority")
    XCTAssertEqual(agency.name, "Chicago Transit Authority")
  }
  
  //  Should return nil
  /*
  func test_initFromRecordWithNoHeaders() {
    let headers: [AgencyField] = []
    let record = ""
    let agency = try? Agency(from: record, using: headers)
    XCTAssertNil(agency)
  }*/
  
  func test_initFromRecordWithSomeHeaders() {
    let headers: [AgencyField] = [
      .name, .url, .timeZone, .locale, .phone, .fareURL]
    let record =
      """
      Chicago Transit Authority,\
      http://transitchicago.com,\
      America/Chicago,\
      en,\
      1-888-YOURCTA,\
      http://www.transitchicago.com/fares
      """
    let agency1 = Agency(
      name: "Chicago Transit Authority",
      url: URL(string: "http://transitchicago.com")!,
      timeZone: TimeZone(identifier: "America/Chicago")!,
      locale: Locale(identifier: "en"),
      phone: "1-888-YOURCTA",
      fareURL: URL(string: "http://www.transitchicago.com/fares")!)
    let agency2 = try? Agency(from: record, using: headers)
    print(agency1)
    print(agency2 ?? "nil result")
    XCTAssertEqual(agency1, agency2)
  }
  
  //  Should return nil ... must check headers
  func test_initFromRecordWithMissingHeaders() {
  }
  
  func test_initFromRecordWithAllHeaders() {
  }
  
  func test_customStringConvertible() {
    let agency = Agency(name: "Chicago Transit Authority",
      url: URL(string: "http://transitchicago.com")!,
      timeZone: TimeZone(identifier: "America/Chicago")!)
    XCTAssertEqual(agency.description, "Agency: Chicago Transit Authority")
  }
}
