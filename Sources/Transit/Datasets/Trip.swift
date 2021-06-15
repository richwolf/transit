//
//  Trip.swift
//

import Foundation

// MARK: TripField

///  All possible fields contained within a ``Trip`` record.
public enum TripField: String, Hashable, KeyPathVending {
  case routeID = "route_id"
  case serviceID = "service_id"
  case tripID = "trip_id"
  case headsign = "trip_headsign"
  case shortName = "trip_short_name"
  case direction = "direction_id"
  case blockID = "block_id"
  case shapeID = "shape_id"
  case isAccessible = "wheelchair_accessible"
  case bikesAllowed = "bikes_allowed"
  //case scheduledTripID = "schd_trip_id" // This is not in GTFS??
  //case dir = "direction" // This is not in GTFS??
  
  internal var path: AnyKeyPath {
    switch self {
    case .routeID: return \Trip.routeID
    case .serviceID: return \Trip.serviceID
    case .tripID: return \Trip.tripID
    case .headsign: return \Trip.headsign
    case .shortName: return \Trip.shortName
    case .direction: return \Trip.direction
    case .blockID: return \Trip.blockID
    case .shapeID: return \Trip.shapeID
    case .isAccessible: return \Trip.isAccessible
    case .bikesAllowed: return \Trip.bikesAllowed
    //case .scheduledTripID: return \Trip.scheduledTripID  // This is not in GTFS??
    //case .dir: return \Trip.dir  // This is not in GTFS??

    }
  }
}

/// - Tag: Direction
public enum Direction: UInt, Hashable {
  case inbound = 0
  case outbound = 1
}

///  A representation of a single Trip record.
public struct Trip: Identifiable {
  public let id = UUID()
  public var routeID: TransitID = ""
  public var serviceID: TransitID = ""
  public var tripID: TransitID = ""
  public var headsign: String?
  public var shortName: String?
  public var direction: String? // Fix!
  public var blockID: TransitID?
  public var shapeID: TransitID?
  public var isAccessible: String? // Fix!
  public var bikesAllowed: String? // Fix!
  //public var scheduledTripID: TransitID? // This is not in GTFS??
  //public var dir: String? // This is not in GTFS??
  
  public static let requiredFields: Set =
    [TripField.routeID, TripField.serviceID, TripField.tripID]
  
  public init(routeID: TransitID = "",
       serviceID: TransitID = "",
       tripID: TransitID = "",
       headsign: String? = nil,
       shortName: String? = nil,
       shapeID: String? = nil) {
    self.routeID = routeID
    self.serviceID = serviceID
    self.tripID = tripID
    self.headsign = headsign
    self.shortName = shortName
    self.shapeID = shapeID
  }
  
  public init(from record: String, using headers: [TripField]) throws {
    do {
      let fields = try record.readRecord()
      if fields.count != headers.count {
        throw TransitError.headerRecordMismatch
      }
      for (index, header) in headers.enumerated() {
        let field = fields[index]
        switch header {
        case .routeID, .serviceID, .tripID:
          try field.assignStringTo(&self, for: header)
        case .headsign, .shortName, .direction, .blockID, /*.dir,*/
             .shapeID, .isAccessible, .bikesAllowed /*, .scheduledTripID */:
          try field.assignOptionalStringTo(&self, for: header)
        }
      }
    } catch let error {
      throw error
    }
  }
}

extension Trip: Equatable {
  public static func ==(lhs: Trip, rhs: Trip) -> Bool {
    return
      lhs.routeID == rhs.routeID &&
      lhs.serviceID == rhs.serviceID &&
      lhs.tripID == rhs.tripID &&
      lhs.headsign == rhs.headsign &&
      lhs.shortName == rhs.shortName &&
      lhs.shapeID == rhs.shapeID
  }
}

extension Trip: CustomStringConvertible {
  public var description: String {
    return "Trip: \(self.tripID)"
  }
}

// MARK: - Trips

/// - Tag: Trips
public struct Trips: Identifiable {
  public let id = UUID()
  public var headerFields = [TripField]()
  fileprivate var trips = [Trip]()
  
  subscript(index: Int) -> Trip {
    get {
      return trips[index]
    }
    set(newValue) {
      trips[index] = newValue
    }
  }
  
  mutating func add(_ trip: Trip) {
    // TODO: Add to header fields supported by this colleciton
    self.trips.append(trip)
  }
  
  mutating func remove(_ trip: Trip) {
  }
  
  init<S: Sequence>(_ sequence: S)
  where S.Iterator.Element == Trip {
    for trip in sequence {
      self.add(trip)
    }
  }
  
  init(from url: URL) throws {
    do {
      let records = try String(contentsOf: url).splitRecords()
      
      if records.count < 1 { return }
      let headerRecord = String(records[0])
      self.headerFields = try headerRecord.readHeader()
      
      self.trips.reserveCapacity(records.count - 1)
      for tripRecord in records[1 ..< records.count] {
        let trip = try Trip(from: String(tripRecord), using: headerFields)
        self.add(trip)
      }
    } catch let error {
      throw error
    }
  }
}

extension Trips: Sequence {
  public typealias Iterator = IndexingIterator<Array<Trip>>
  
  public func makeIterator() -> Iterator {
    return trips.makeIterator()
  }
}
