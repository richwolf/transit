//
//  StopTests.swift
//

import XCTest
@testable import Transit

final class StopTests: XCTestCase {
  var stopsFileURL: URL? = nil;
  
  override func setUp() {
    super.setUp()
    self.stopsFileURL =
      Bundle.module.url(forResource: "stops", withExtension: "txt")
  }
  
  func test_dummy() {
  }
}
