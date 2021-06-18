//
//  Agency.swift
//

import Foundation

// MARK: AgencyField

///  All possible fields contained within an ``Agency`` record.
public enum AgencyField: String, Hashable, KeyPathVending {
  ///  Agency ID field.
  case agencyID = "agency_id"
  ///  Agency name field.
  case name = "agency_name"
  ///  Agency URL field.
  case url = "agency_url"
  ///  Agency time zone field.
  case timeZone = "agency_timezone"
  ///  Agency locale field.
  case locale = "agency_lang"
  ///  Agency phone number field.
  case phone = "agency_phone"
  ///  Agency fare URL field.
  case fareURL = "agency_fare_url"
  ///  Agency email address field.
  case email = "agency_email"
  
  internal var path: AnyKeyPath {
    switch self {
    case .agencyID: return \Agency.agencyID
    case .name: return \Agency.name
    case .url: return \Agency.url
    case .timeZone: return \Agency.timeZone
    case .locale: return \Agency.locale
    case .phone: return \Agency.phone
    case .fareURL: return \Agency.fareURL
    case .email: return \Agency.email
    }
  }
}

// MARK: Agency

///  A representation of a single Agency record.
public struct Agency: Identifiable {
  ///  A globally unique identifier. Because GTFS does not guarantee
  ///  that IDs will be unique
  public let id = UUID()
  ///  The agency brand ID. This ID is usually synonymous with the
  ///  agency itself. But in the event that multiple services are contained
  ///  within the same dataset, this ID can be used to uniquely identify
  ///  each.
  public var agencyID: String?
  ///  The full name of the agency.
  public var name: String = ""
  ///  Agency URL.
  public var url: URL = URL(string: "https://unnamed.com")!
  ///  Agency time zone.
  public var timeZone: TimeZone = TimeZone(identifier: "UTC")!
  ///  Agency locale.
  public var locale: Locale?
  ///  Agency phone number.
  public var phone: String?
  ///  Agency fare URL.
  public var fareURL: URL?
  ///  Agency email address.
  public var email: String?
  
  ///  A set enumerating the required fields in an ``Agency`` record.
  public static let requiredFields: Set<AgencyField>
    = [.name, .url, .timeZone]
  ///  A set enumerating the conditionally required fields in an ``Agency`` record.
  public static let conditionallyRequiredFields: Set<AgencyField>
    = [.agencyID]
  ///  A set enumerating the optional fields in an ``Agency`` record.
  public static let optionalFields: Set<AgencyField>
    = [.locale, .phone, .fareURL, .email]
  
  ///  Basic init.
  public init(agencyID: String? = nil,
       name: String = "",
       url: URL = URL(string: "https://unnamed.com")!,
       timeZone: TimeZone = TimeZone(identifier: "UTC")!,
       locale: Locale? = nil,
       phone: String? = nil,
       fareURL: URL? = nil,
       email: String? = nil) {
    self.agencyID = agencyID
    self.name = name
    self.url = url
    self.timeZone = timeZone
    self.locale = locale
    self.phone = phone
    self.fareURL = fareURL
    self.email = email
  }
  
  ///  Init from a record.
  public init(from record: String, using headerFields: [AgencyField]) throws {
    do {
      let recordFields = try record.readRecord()
      if recordFields.count != headerFields.count {
        throw TransitError.headerRecordMismatch
      }
      for (index, header) in headerFields.enumerated() {
        let field = recordFields[index]
        switch header {
        case .name:
          try field.assignStringTo(&self, for: header)
        case .agencyID, .phone, .email:
          try field.assignOptionalStringTo(&self, for: header)
        case .url:
          try field.assignURLValueTo(&self, for: header)
        case .fareURL:
          try field.assignOptionalURLTo(&self, for: header)
        case .locale:
          try field.assignLocaleTo(&self, for: header)
        case .timeZone:
          try field.assignTimeZoneTo(&self, for: header)
        }
      }
    } catch let error {
      throw error
    }
  }
}

extension Agency: Equatable {
  public static func ==(lhs: Agency, rhs: Agency) -> Bool {
    return
      lhs.agencyID == rhs.agencyID &&
      lhs.name == rhs.name &&
      lhs.url == rhs.url &&
      lhs.timeZone == rhs.timeZone &&
      lhs.locale == rhs.locale &&
      lhs.phone == rhs.phone &&
      lhs.fareURL == rhs.fareURL &&
      lhs.email == rhs.email
  }
}

extension Agency: CustomStringConvertible {
  public var description: String {
    return "Agency: \(self.name)"
  }
}

// MARK: - Agencies

// TODO: Method to test for required and conditionally required fields.
// TODO: Method to ensure that feed with mutiple agencies does not omit agencyIDs.
// TODO: Method to ensure that all contained agencies have the same timezone.

///  A representation of a complete Agency dataset.
public struct Agencies: Identifiable {
  ///  A globally unique identifier.
  public let id = UUID()
  ///  Header fields.
  public var headerFields = [AgencyField]()
  fileprivate var agencies = [Agency]()
  
  public subscript(index: Int) -> Agency {
    get {
      return agencies[index]
    }
    set(newValue) {
      agencies[index] = newValue
    }
  }
  
  mutating func add(_ agency: Agency) {
    self.agencies.append(agency)
  }
  
  mutating func remove(_ agency: Agency) {
  }
  
  public init<S: Sequence>(_ sequence: S)
  where S.Iterator.Element == Agency {
    for agency in sequence {
      self.add(agency)
    }
  }
  
  ///  Grab agency dataset from file.
  public init(from url: URL) throws {
    do {
      let records = try String(contentsOf: url).splitRecords()
      
      if records.count < 1 { return }
      let headerRecord = String(records[0])
      self.headerFields = try headerRecord.readHeader()
      
      self.agencies.reserveCapacity(records.count - 1)
      for agencyRecord in records[1 ..< records.count] {
        let agency = try Agency(from: String(agencyRecord), using: headerFields)
        self.add(agency)
      }
    } catch let error {
      throw error
    }
  }
}

extension Agencies: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: Agency...) {
    self.init(elements)
  }
}
