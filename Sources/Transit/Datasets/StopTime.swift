//
//  StopTime.swift
//

import Foundation

// MARK: StopTimeField

///  All possible fields contained within a ``StopTime`` record.
public enum StopTimeField: String, Hashable, KeyPathVending {
  ///  Trip ID field.
  case tripID = "trip_id"
  ///  Trip arrival field.
  case arrival = "arrival_time"
  ///  Trip departure field.
  case departure = "departure_time"
  ///  Stop ID field.
  case stopID = "stop_id"
  ///  Stop sequence number field.
  case stopSequenceNumber = "stop_sequence"
  ///  Stop heading sign field.
  case stopHeadingSign = "stop_headsign"
  ///  Stop pickup type field.
  case pickupType = "pickup_type"
  ///  Stop dropoff type field.
  case dropoffType = "drop_off_type"
  ///  Stop continuous pickup field.
  case continuousPickup = "continuous_pickup"
  ///  Stop continuous dropoff field.
  case continuousDropoff = "continuous_drop_off"
  ///  Stop distance traveled for shape field.
  case distanceTraveledForShape = "shape_dist_traveled"
  ///  Stop timepoint type field.
  case timepointType = "timepoint"
  
  internal var path: AnyKeyPath {
    switch self {
    case .tripID: return \StopTime.tripID
    case .arrival: return \StopTime.arrival
    case .departure: return \StopTime.departure
    case .stopID: return \StopTime.stopID
    case .stopSequenceNumber: return \StopTime.stopSequenceNumber
    case .stopHeadingSign: return \StopTime.stopHeadingSign
    case .pickupType: return \StopTime.pickupType
    case .dropoffType: return \StopTime.dropoffType
    case .continuousPickup: return \StopTime.continuousPickup
    case .continuousDropoff: return \StopTime.continuousDropoff
    case .distanceTraveledForShape: return \StopTime.distanceTraveledForShape
    case .timepointType: return \StopTime.timepointType
    }
  }
}

///  A representation of a single StopTime record.
public struct StopTime: Identifiable {
  public var id = UUID()
  public var tripID: TransitID = ""
  public var arrival: Date?
  public var departure: Date?
  public var stopID: TransitID = ""
  public var stopSequenceNumber: UInt = 0
  public var stopHeadingSign: String?
  public var pickupType: Int?
  public var dropoffType: Int?
  public var continuousPickup: Int?
  public var continuousDropoff: Int?
  public var distanceTraveledForShape: Double?
  public var timepointType: Int?
  
  public init(tripID: TransitID = "",
       arrival: Date? = nil,
       departure: Date? = nil,
       stopID: TransitID = "",
       stopSequenceNumber: UInt = 0,
       stopHeadingSign: String? = nil,
       pickupType: Int? = nil,
       dropoffType: Int? = nil,
       continuousPickup: Int? = nil,
       continuousDropoff: Int? = nil,
       distanceTraveledForShape: Double? = nil,
       timepointType: Int? = nil) {
    self.tripID = tripID
    self.arrival = arrival
    self.departure = departure
    self.stopID = stopID
    self.stopSequenceNumber = stopSequenceNumber
    self.stopHeadingSign = stopHeadingSign
    self.pickupType = pickupType
    self.dropoffType = dropoffType
    self.continuousPickup = continuousPickup
    self.continuousDropoff = continuousDropoff
    self.distanceTraveledForShape = distanceTraveledForShape
    self.timepointType = timepointType
  }
  
  init(from record: String, using headers: [StopTimeField]) throws {
    do {
      let fields = try record.readRecord()
      if fields.count != headers.count {
        throw TransitError.headerRecordMismatch
      }
      for (index, header) in headers.enumerated() {
        let field = fields[index]
        switch header {
        case .tripID, .stopID:
          try field.assignStringTo(&self, for: header)
        case .stopHeadingSign:
          try field.assignOptionalStringTo(&self, for: header)
        case .stopSequenceNumber:
          try field.assignUIntTo(&self, for: header)
        case .arrival, .departure, .pickupType, .dropoffType,
             .continuousPickup, .continuousDropoff,
             .distanceTraveledForShape, .timepointType:
          break
        }
      }
    } catch let error {
      throw error
    }
  }
}

extension StopTime: Equatable {
  public static func ==(lhs: StopTime, rhs: StopTime) -> Bool {
    return
      lhs.tripID == rhs.tripID &&
      lhs.stopID == rhs.stopID
  }
}

extension StopTime: CustomStringConvertible {
  public var description: String {
    return "StopTime: \(self.tripID) \(self.stopID)"
  }
}

// MARK: - StopTimes

/// - Tag: StopTimes
public struct StopTimes: Identifiable {
  public let id = UUID()
  public var headerFields = [StopTimeField]()
  fileprivate var stopTimes = [StopTime]()
  
  subscript(index: Int) -> StopTime {
    get {
      return stopTimes[index]
    }
    set(newValue) {
      stopTimes[index] = newValue
    }
  }
  
  mutating func add(_ stopTime: StopTime) {
    // TODO: Add to header fields supported by this colleciton
    self.stopTimes.append(stopTime)
  }
  
  mutating func remove(_ stopTime: StopTime) {
  }
  
  init<S: Sequence>(_ sequence: S)
  where S.Iterator.Element == StopTime {
    for stopTime in sequence {
      self.add(stopTime)
    }
  }
  
  init(from url: URL) throws {
    do {
      let records = try String(contentsOf: url).splitRecords()
      
      if records.count < 1 { return }
      let headerRecord = String(records[0])
      self.headerFields = try headerRecord.readHeader()
      
      self.stopTimes.reserveCapacity(records.count - 1)
      for stopTimeRecord in records[1 ..< records.count] {
        let stopTime = try StopTime(from: String(stopTimeRecord), using: headerFields)
        self.add(stopTime)
      }
    } catch let error {
      throw error
    }
  }
}

extension StopTimes: Sequence {
  public typealias Iterator = IndexingIterator<Array<StopTime>>
  
  public func makeIterator() -> Iterator {
    return stopTimes.makeIterator()
  }
}
