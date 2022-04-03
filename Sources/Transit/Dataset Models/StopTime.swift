//
// StopTime.swift
//

import Foundation

// MARK: StopTimeField

/// All fields that may appear within a `StopTime` record.
public enum StopTimeField: String, Hashable, KeyPathVending {
  /// Trip ID field.
  case tripID = "trip_id"
  /// Trip arrival field.
  case arrival = "arrival_time"
  /// Trip departure field.
  case departure = "departure_time"
  /// Stop ID field.
  case stopID = "stop_id"
  /// Stop sequence number field.
  case stopSequenceNumber = "stop_sequence"
  /// Stop heading sign field.
  case stopHeadingSign = "stop_headsign"
  /// Stop pickup type field.
  case pickupType = "pickup_type"
  /// Stop drop off type field.
  case dropOffType = "drop_off_type"
  /// Stop continuous pickup field.
  case continuousPickup = "continuous_pickup"
  /// Stop continuous drop off field.
  case continuousDropOff = "continuous_drop_off"
  /// Stop distance traveled for shape field.
  case distanceTraveledForShape = "shape_dist_traveled"
  /// Stop time point type field.
  case timePointType = "timepoint"

  internal var path: AnyKeyPath {
    switch self {
    case .tripID: return \StopTime.tripID
    case .arrival: return \StopTime.arrival
    case .departure: return \StopTime.departure
    case .stopID: return \StopTime.stopID
    case .stopSequenceNumber: return \StopTime.stopSequenceNumber
    case .stopHeadingSign: return \StopTime.stopHeadingSign
    case .pickupType: return \StopTime.pickupType
    case .dropOffType: return \StopTime.dropOffType
    case .continuousPickup: return \StopTime.continuousPickup
    case .continuousDropOff: return \StopTime.continuousDropOff
    case .distanceTraveledForShape: return \StopTime.distanceTraveledForShape
    case .timePointType: return \StopTime.timePointType
    }
  }
}

// MARK: - StopTime

/// A representation of a single StopTime record.
public struct StopTime: Hashable, Identifiable {
  public var id = UUID()
  public var tripID: TransitID = ""
  public var arrival: Date?
  public var departure: Date?
  public var stopID: TransitID = ""
  public var stopSequenceNumber: UInt = 0
  public var stopHeadingSign: String?
  public var pickupType: Int?
  public var dropOffType: Int?
  public var continuousPickup: Int?
  public var continuousDropOff: Int?
  public var distanceTraveledForShape: Double?
  public var timePointType: Int?

  public init(
		tripID: TransitID = "",
		arrival: Date? = nil,
		departure: Date? = nil,
		stopID: TransitID = "",
		stopSequenceNumber: UInt = 0,
		stopHeadingSign: String? = nil,
		pickupType: Int? = nil,
		dropOffType: Int? = nil,
		continuousPickup: Int? = nil,
		continuousDropOff: Int? = nil,
		distanceTraveledForShape: Double? = nil,
		timePointType: Int? = nil
	) {
    self.tripID = tripID
    self.arrival = arrival
    self.departure = departure
    self.stopID = stopID
    self.stopSequenceNumber = stopSequenceNumber
    self.stopHeadingSign = stopHeadingSign
    self.pickupType = pickupType
    self.dropOffType = dropOffType
    self.continuousPickup = continuousPickup
    self.continuousDropOff = continuousDropOff
    self.distanceTraveledForShape = distanceTraveledForShape
    self.timePointType = timePointType
  }

  init(
		from record: String,
		using headers: [StopTimeField]
	) throws {
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
        case .arrival, .departure, .pickupType, .dropOffType,
             .continuousPickup, .continuousDropOff,
             .distanceTraveledForShape, .timePointType:
          break
        }
      }
    } catch let error {
      throw error
    }
  }
}

extension StopTime: Equatable {
  public static func == (lhs: StopTime, rhs: StopTime) -> Bool {
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
    // TODO: Add to header fields supported by this collection
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
        let stopTime = try StopTime(from: String(stopTimeRecord),
																		using: headerFields)
        self.add(stopTime)
      }
    } catch let error {
      throw error
    }
  }
}

extension StopTimes: Sequence {
  public typealias Iterator = IndexingIterator<[StopTime]>

  public func makeIterator() -> Iterator {
    return stopTimes.makeIterator()
  }
}
