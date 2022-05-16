//
// Agency.swift
//

import Foundation

// MARK: AgencyField

/// Describes the various fields found within an ``Agency`` record or header.
///
/// `AgencyField`s are generally members of `Set`s that enumerate
/// the fields found within an ``Agency`` record or header. The following,
/// for example, returns the `Set` of agency fields found within
/// the `myAgencies` feed header:
/// ```swift
///   let fields = myAgencies.headerFields
/// ```
///
/// Should you need it, use `rawValue` to obtain the GTFS agency field name
/// associated with an `AgencyField` value as a `String`:
/// ```swift
///   let gtfsField = AgencyField.locale.rawValue  //  Returns "agency_lang"
/// ```
public enum AgencyField: String, Hashable, KeyPathVending {
  /// Agency ID field.
  case agencyID = "agency_id"
  /// Agency name field.
  case name = "agency_name"
  /// Agency URL field.
  case url = "agency_url"
  /// Agency time zone field.
  case timeZone = "agency_timezone"
  /// Agency locale field.
  case locale = "agency_lang"
  /// Agency phone number field.
  case phone = "agency_phone"
  /// Agency fare URL field.
  case fareURL = "agency_fare_url"
  /// Agency email address field.
  case email = "agency_email"
	///
	case skip = "agency_skip"

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
		case .skip: return \Agency.skip
    }
  }
}

// MARK: - Agency

/// A representation of an Agency record.
public struct Agency: Hashable, Identifiable {
	
  /// A globally unique identifier. Because GTFS does not guarantee
  /// that IDs will be unique
  public let id = UUID()
  /// The agency brand ID. This ID is usually synonymous with the
  /// agency itself. But in the event that multiple services are contained
  /// within the same dataset, this ID can be used to uniquely identify
  /// each.
  public var agencyID: String?
  /// The full name of the agency.
  public var name: String = ""
  /// Agency URL.
  public var url: URL = URL(string: "https://unnamed.com")!
  /// Agency time zone.
  public var timeZone: TimeZone = TimeZone(identifier: "UTC")!
  /// Agency locale.
  public var locale: Locale?
  /// Agency phone number.
  public var phone: String?
  /// Agency fare URL.
  public var fareURL: URL?
  /// Agency email address.
  public var email: String?
	
	public var skip: String? = nil

  /// A `Set` that enumerates the fields that must appear within an ``Agency``
	/// record.
  public static let requiredFields: Set<AgencyField>
    = [.name, .url, .timeZone]
  /// A `Set` that enumerates the fields that may be conditionally required
	/// to appear within an ``Agency`` record.
  public static let conditionallyRequiredFields: Set<AgencyField>
    = [.agencyID]
  /// A `Set` that enumerates the fields that may optionally appear within an
	/// ``Agency`` record.
  public static let optionalFields: Set<AgencyField>
    = [.locale, .phone, .fareURL, .email]

  /// Basic init.
  public init(
		agencyID: String? = nil,
		name: String = "",
		url: URL = URL(string: "https://unnamed.com")!,
		timeZone: TimeZone = TimeZone(identifier: "UTC")!,
		locale: Locale? = nil,
		phone: String? = nil,
		fareURL: URL? = nil,
		email: String? = nil
	) {
    self.agencyID = agencyID
    self.name = name
    self.url = url
    self.timeZone = timeZone
    self.locale = locale
    self.phone = phone
    self.fareURL = fareURL
    self.email = email
  }

  /// Init from a record.
  public init(
		from record: String,
		using headerFields: [AgencyField]
	) throws {
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
				case .skip:
					continue
        }
      }
    } catch let error {
      throw error
    }
  }

}

extension Agency: Equatable {
  
	public static func == (leftHand: Agency, rightHand: Agency) -> Bool {
    return
			leftHand.agencyID == rightHand.agencyID &&
			leftHand.name == rightHand.name &&
			leftHand.url == rightHand.url &&
			leftHand.timeZone == rightHand.timeZone &&
			leftHand.locale == rightHand.locale &&
			leftHand.phone == rightHand.phone &&
			leftHand.fareURL == rightHand.fareURL &&
			leftHand.email == rightHand.email
  }
	
}

extension Agency: CustomStringConvertible {
  
	public var description: String {
    return "Agency: \(self.name)"
  }
	
}

extension Agency: CustomDebugStringConvertible {
	
	public var debugDescription: String {
		return "Agency"
	}
	
}

// MARK: - Agencies

/// A representation of a complete Agency dataset.
public struct Agencies: Identifiable, RandomAccessCollection {
	public var startIndex: Int = 0
	
	public var endIndex: Int = 0
	
	public var agencies: [Agency] = []
	
	/// A globally unique identifier.
  public let id = UUID()
	
  /// Header fields.
	public var headerFields: [AgencyField] = []
		
	public var hasRequiredFields: Bool {
		return Agency.requiredFields.isSubset(of: headerFields)
	}

	public var hasConditionallyRequiredFields: Bool {
		return Agency.conditionallyRequiredFields.isSubset(of: headerFields)
	}
	
	public var hasRequiredAgencyIDs: Bool {
		if agencies.count > 0 {
			return agencies.allSatisfy { $0.agencyID != nil }
		}
		return true
	}

	public var hasMatchingTimeZones: Bool {
		if agencies.count > 0 {
			return agencies.dropFirst().allSatisfy {
				$0.timeZone == agencies.first?.timeZone
			}
		}
		return true	}
	
	public var isValid: Bool {
		return hasRequiredFields && hasRequiredAgencyIDs && hasMatchingTimeZones
	}
	
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

  public init<S: Sequence>(_ sequence: S) where S.Iterator.Element == Agency {
    for agency in sequence {
      self.add(agency)
    }
  }

  /// Initialize agencies dataset from file.
  public init(from url: URL) throws {
    do {
      let records = try String(contentsOf: url).splitRecords()

      if records.count < 1 { return }
      let headerRecord = String(records[0])
      self.headerFields = try headerRecord.readHeader()

      self.agencies.reserveCapacity(records.count - 1)
      for agencyRecord in records[1 ..< records.count] {
				let agency = try Agency(from: String(agencyRecord),
																using: headerFields)
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
