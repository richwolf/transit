//
//  Stop.swift
//

import Foundation
import CoreLocation

// MARK: StopField

///  All possible fields that may appear within a `Stop` record.
public enum StopField: String, Hashable, KeyPathVending {
  ///  Stop ID field.
  case stopID = "stop_id"
  ///  Stop code field.
  case code = "stop_code"
  ///  Stop name field.
  case name = "stop_name"
  ///  Stop details field.
  case details = "stop_desc"
  ///  Stop latitude field.
  case latitude = "stop_lat"
  ///  Stop longitude field.
  case longitude = "stop_lon"
  ///  Stop zone ID field.
  case zoneID = "zone_id"
  ///  Stop URL field.
  case url = "stop_url"
  ///  Stop location type field.
  case locationType = "location_type"
  ///  Stop parent station ID field.
  case parentStationID = "parent_station"
  ///  Stop timezone field.
  case timeZone = "stop_timezone"
  ///  Stop accessibility field.
  case accessibility = "wheelchair_boarding"
  ///  Stop level ID field.
  case levelID = "level_id"
  ///  Stop platform code field.
  case platformCode = "platform_code"
  
  internal var path: AnyKeyPath {
    switch self {
    case .stopID: return \Stop.stopID
    case .code: return \Stop.code
    case .name: return \Stop.name
    case .details: return \Stop.details
    case .latitude: return \Stop.latitude
    case .longitude: return \Stop.longitude
    case .zoneID: return \Stop.zoneID
    case .url: return \Stop.url
    case .locationType: return \Stop.locationType
    case .parentStationID: return \Stop.parentStationID
    case .timeZone: return \Stop.timeZone
    case .accessibility: return \Stop.accessibility
    case .levelID: return \Stop.levelID
    case .platformCode: return \Stop.platformCode
    }
  }
}

/// - Tag: StopCode
public typealias StopCode = String

/// - Tag: StopLocationType
public enum StopLocationType: UInt, Hashable {
  case stopOrPlatform = 0
  case station = 1
  case entranceOrExit = 2
  case genericNode = 3
  case boardingArea = 4
}

/// - Tag: Accessibility
public enum Accessibility: UInt, Hashable {
  case unknownOrInherits = 0
  case partialOrFull = 1
  case none = 2
}

///  A representation of a single Stop record.
public struct Stop: Identifiable {
  public let id = UUID()
  public var stopID: TransitID = ""
  public var code: StopCode?
  public var name: String?
  public var details: String?
  public var latitude: CLLocationDegrees?
  public var longitude: CLLocationDegrees?
  public var zoneID: TransitID?
  public var url: URL?
  public var locationType: StopLocationType?
  public var parentStationID: TransitID?
  public var timeZone: TimeZone?
  public var accessibility: Accessibility?
  public var levelID: TransitID?
  public var platformCode: String?
  
  public init(stopID: TransitID = "Unidentified stop",
       code: StopCode? = nil,
       name: String? = nil,
       details: String? = nil,
       latitude: CLLocationDegrees? = nil,
       longitude: CLLocationDegrees? = nil,
       zoneID: TransitID? = nil,
       url: URL? = nil,
       locationType: StopLocationType? = nil,
       parentStationID: TransitID? = nil,
       timeZone: TimeZone? = nil,
       accessibility: Accessibility? = nil,
       levelID: TransitID? = nil,
       platformCode: String?) {
    self.stopID = stopID
    self.code = code
    self.name = name
    self.details = details
    self.latitude = latitude
    self.longitude = longitude
    self.zoneID = zoneID
    self.url = url
    self.locationType = locationType
    self.parentStationID = parentStationID
    self.timeZone = timeZone
    self.accessibility = accessibility
    self.levelID = levelID
    self.platformCode = platformCode
  }
  
  public static let requiredFields: Set =
    [StopField.stopID]
  
  init(from record: String, using headers: [StopField]) throws {
    do {
      let fields = try record.readRecord()
      if fields.count != headers.count {
        throw TransitError.headerRecordMismatch
      }
      for (index, header) in headers.enumerated() {
        let field = fields[index]
        switch header {
        case .stopID:
          try field.assignStringTo(&self, for: header)
        case .code, .name, .details, .zoneID, .parentStationID, .levelID, .platformCode:
          try field.assignOptionalStringTo(&self, for: header)
        case .url:
          try field.assignOptionalURLTo(&self, for: header)
        case .timeZone:
          try field.assignOptionalTimeZoneTo(&self, for: header)
        case .latitude, .longitude:
          try field.assignOptionalCLLocationDegreesTo(&self, for: header)
        case .locationType:
          break
        case .accessibility:
          break
        }
      }
    } catch let error {
      throw error
    }
  }
  
  public static func stopLocationTypeFrom(string: String) -> StopLocationType? {
    if let rawValue = UInt(string) {
      return StopLocationType(rawValue: rawValue)
    } else {
      return nil
    }
  }
  
  public static func accessibilityFrom(string: String) -> Accessibility? {
    if let rawValue = UInt(string) {
      return Accessibility(rawValue: rawValue)
    } else {
      return nil
    }
  }
  
  private static let requiredHeaders: Set =
    [StopField.stopID]
}

extension Stop: Equatable {
  public static func ==(lhs: Stop, rhs: Stop) -> Bool {
    return
      lhs.stopID == rhs.stopID &&
      lhs.code == rhs.code &&
      lhs.name == rhs.name &&
      lhs.details == rhs.details &&
      lhs.latitude == rhs.longitude &&
      lhs.longitude == rhs.longitude &&
      lhs.zoneID == rhs.zoneID &&
      lhs.url == rhs.url &&
      lhs.locationType == rhs.locationType &&
      lhs.parentStationID == rhs.parentStationID &&
      lhs.timeZone == rhs.timeZone &&
      lhs.accessibility == rhs.accessibility &&
      lhs.levelID == rhs.levelID &&
      lhs.platformCode == rhs.platformCode
  }
}

extension Stop: CustomStringConvertible {
	public var description: String {
    return "Stop: \(self.stopID)"
  }
}

// MARK: - Stops

///  A representation of a complete Stops dataset.
public struct Stops: Identifiable {
  public let id = UUID()
  public var headerFields = [StopField]()
  fileprivate var stops = [Stop]()
  
  subscript(index: Int) -> Stop {
    get {
      return stops[index]
    }
    set(newValue) {
      stops[index] = newValue
    }
  }
  
  mutating func add(_ stop: Stop) {
    // TODO: Add to header fields supported by this collection
    self.stops.append(stop)
  }
  
  mutating func remove(_ stop: Stop) {
  }
  
  init<S: Sequence>(_ sequence: S)
  where S.Iterator.Element == Stop {
    for stop in sequence {
      self.add(stop)
    }
  }
  
  init(from url: URL) throws {
    do {
      let records = try String(contentsOf: url).splitRecords()
      
      if records.count < 1 { return }
      let headerRecord = String(records[0])
      self.headerFields = try headerRecord.readHeader()
      
      self.stops.reserveCapacity(records.count - 1)
      for stopRecord in records[1 ..< records.count] {
        let stop = try Stop(from: String(stopRecord), using: headerFields)
        self.add(stop)
      }
    } catch let error {
      throw error
    }
  }
}

extension Stops: Sequence {
  public typealias Iterator = IndexingIterator<Array<Stop>>
  
  public func makeIterator() -> Iterator {
    return stops.makeIterator()
  }
}
