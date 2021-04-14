//
//  Agency.swift
//

import Foundation

// MARK: Agency

/// - Tag: AgencyField
public enum AgencyField: String, Hashable, KeyPathVending {
  case agencyID = "agency_id"
  case name = "agency_name"
  case url = "agency_url"
  case timeZone = "agency_timezone"
  case language = "agency_lang"
  case phone = "agency_phone"
  case fareURL = "agency_fare_url"
  case email = "agency_email"
  
  public var path: AnyKeyPath {
    switch self {
    case .agencyID: return \Agency.agencyID
    case .name: return \Agency.name
    case .url: return \Agency.url
    case .timeZone: return \Agency.timeZone
    case .language: return \Agency.language
    case .phone: return \Agency.phone
    case .fareURL: return \Agency.fareURL
    case .email: return \Agency.email
    }
  }
}

/// - Tag: Agency
public struct Agency: Identifiable {
  public let id = UUID()
  public var agencyID: TransitID?
  public var name: String = "Unnamed Agency"
  public var url: URL = URL(string: "https://unnamed.com")!
  public var timeZone: TimeZone = TimeZone(identifier: "UTC")!
  public var language: String?
  public var phone: String?
  public var fareURL: URL?
  public var email: String?
  
  public static let requiredFields: Set =
    [AgencyField.name, AgencyField.url, AgencyField.timeZone]
  
  public init(agencyID: TransitID? = nil,
       name: String = "Unnamed Agency",
       url: URL = URL(string: "https://unnamed.com")!,
       timeZone: TimeZone = TimeZone(identifier: "UTC")!,
       language: String? = nil,
       phone: String? = nil,
       fareURL: URL? = nil,
       email: String? = nil) {
    self.agencyID = agencyID
    self.name = name
    self.url = url
    self.timeZone = timeZone
    self.language = language
    self.phone = phone
    self.fareURL = fareURL
    self.email = email
  }
  
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
        case .agencyID, .language, .phone, .email:
          try field.assignOptionalStringTo(&self, for: header)
        case .url:
          try field.assignURLValueTo(&self, for: header)
        case .fareURL:
          try field.assignOptionalURLTo(&self, for: header)
        case .timeZone:
          try field.assignTimeZoneTo(&self, for: header)
        }
      }
    } catch let error {
      throw error
    }
  }
  
  /*
   public static func containsRequiredFields(_ fields: [AgencyField]) -> Bool {
    let fieldSet = Set(fields)
    return Self.requiredFields.isSubset(of: fieldSet)
   }
   */
}

extension Agency: Equatable {
  public static func ==(lhs: Agency, rhs: Agency) -> Bool {
    return
      lhs.agencyID == rhs.agencyID &&
      lhs.name == rhs.name &&
      lhs.url == rhs.url &&
      lhs.timeZone == rhs.timeZone &&
      lhs.language == rhs.language &&
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

/// - Tag: Agencies
public struct Agencies: Identifiable {
  public let id = UUID()
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
    // TODO: Add to header fields supported by this colleciton
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

/*  This needs to go into a -> Bool checker
if !Agency.containsRequiredFields(headers) {
  throw TransitError.missingRequiredFields
} */
// TODO: setup a boolean for transit agency with multiple ids
//   in this case, agencyID is required.
// TODO: A public function that ensures that all agencies have the same timezone
