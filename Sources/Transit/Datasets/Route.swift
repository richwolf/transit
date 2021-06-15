//
//  Route.swift
//

import Foundation
import CoreGraphics

// MARK: RouteField

///  All possible fields contained within a ``Route`` record.
public enum RouteField: String, Hashable, KeyPathVending {
  ///  Route ID field.
  case routeID = "route_id"
  ///  Agency ID field.
  case agencyID = "agency_id"
  ///  Route name field.
  case name = "route_long_name"
  ///  Route short name field.
  case shortName = "route_short_name"
  ///  Route details field.
  case details = "route_desc"
  ///  Route type field.
  case type = "route_type"
  ///  Route URL field.
  case url = "route_url"
  ///  Route color field.
  case color = "route_color"
  ///  Route text color field.
  case textColor = "route_text_color"
  ///  Route sort order field.
  case sortOrder = "route_sort_order"
  ///  Route pickup policy field.
  case pickupPolicy = "continuous_pickup"
  ///  Route dropoff policy field.
  case dropoffPolicy = "continuous_drop_off"
  
  internal var path: AnyKeyPath {
    switch self {
    case .routeID: return \Route.routeID
    case .agencyID: return \Route.agencyID
    case .name: return \Route.name
    case .shortName: return \Route.shortName
    case .details: return \Route.details
    case .type: return \Route.type
    case .url: return \Route.url
    case .color: return \Route.color
    case .textColor: return \Route.textColor
    case .sortOrder: return \Route.sortOrder
    case .pickupPolicy: return \Route.pickupPolicy
    case .dropoffPolicy: return \Route.dropoffPolicy
    }
  }
}

public enum RouteType: UInt, Hashable {
  case tram = 0
  case subway = 1
  case rail = 2
  case bus = 3
  case ferry = 4
  case cable = 5
  case aerial = 6
  case funicular = 7
  case trolleybus = 11
  case monorail = 12
}

public enum PickupDropffPolicy: UInt, Hashable {
  case continuous = 0
  case none = 1
  case coordinateWithAgency = 2
  case coordinateWithDriver = 3
}

// MARK: Route

// TODO: Routes method to test for required and conditionally required fields.
// TODO: Routes method to ensure that feed with mutiple agencies does not omit agencyIDs
// TODO:   if routes refer to both agencies.
// TODO: Routes method to ensure that either name or shortName provided for all routes.

///  A representation of a single Route record.
public struct Route: Identifiable {
  public let id = UUID()
  public var routeID: TransitID = ""
  public var agencyID: TransitID?
  public var name: String?
  public var shortName: String?
  public var details: String?
  public var type: RouteType = .bus
  public var url: URL?
  public var color: CGColor?
  public var textColor: CGColor?
  public var sortOrder: UInt?
  public var pickupPolicy: PickupDropffPolicy?
  public var dropoffPolicy: PickupDropffPolicy?
  
  public static let requiredFields: Set<RouteField>
    = [.routeID, .type]
  public static let conditionallyRequiredFields: Set<RouteField>
    = [.agencyID, .name, .shortName]
  public static let optionalFields: Set<RouteField>
    = [.details, .url, .color, .textColor, .sortOrder,
       .pickupPolicy, .dropoffPolicy]
  
  public init(routeID: TransitID = "Unidentified route",
       agencyID: TransitID? = nil,
       name: String? = nil,
       shortName: String? = nil,
       details: String? = nil,
       type: RouteType = .bus,
       url: URL? = nil,
       color: CGColor? = nil,
       textColor: CGColor? = nil,
       sortOrder: UInt? = nil,
       pickupPolicy: PickupDropffPolicy? = nil,
       dropoffPolicy: PickupDropffPolicy? = nil) {
    self.routeID = routeID
    self.agencyID = agencyID
    self.name = name
    self.shortName = shortName
    self.details = details
    self.type = type
    self.url = url
    self.color = color
    self.textColor = textColor
    self.sortOrder = sortOrder
    self.pickupPolicy = pickupPolicy
    self.dropoffPolicy = dropoffPolicy
  }
  
  public init(from record: String, using headers: [RouteField]) throws {
    do {
      let fields = try record.readRecord()
      if fields.count != headers.count {
        throw TransitError.headerRecordMismatch
      }
      for (index, header) in headers.enumerated() {
        let field = fields[index]
        switch header {
        case .routeID:
          try field.assignStringTo(&self, for: header)
        case .agencyID, .name, .shortName, .details:
          try field.assignOptionalStringTo(&self, for: header)
        case .sortOrder:
          try field.assignOptionalUIntTo(&self, for: header)
        case .url:
          try field.assignOptionalURLTo(&self, for: header)
        case .color, .textColor:
          try field.assignOptionalCGColorTo(&self, for: header)
        case .type:
          try field.assignRouteTypeTo(&self, for: header)
        case .pickupPolicy, .dropoffPolicy:
          try field.assignOptionalPickupDropoffPolicyTo(&self, for: header)
        }
      }
    } catch let error {
      throw error
    }
  }
  
  public static func routeTypeFrom(string: String) -> RouteType? {
    if let rawValue = UInt(string) {
      return RouteType(rawValue: rawValue)
    } else {
      return nil
    }
  }
  
  public static func pickupDropoffPolicyFrom(string: String) -> PickupDropffPolicy? {
    if let rawValue = UInt(string) {
      return PickupDropffPolicy(rawValue: rawValue)
    } else {
      return nil
    }
  }
  
  private static let requiredHeaders: Set =
    [RouteField.routeID, RouteField.type]
}

extension Route: Equatable {
  public static func ==(lhs: Route, rhs: Route) -> Bool {
    return
      lhs.routeID == rhs.routeID &&
      lhs.agencyID == rhs.agencyID &&
      lhs.name == rhs.name &&
      lhs.shortName == rhs.shortName &&
      lhs.details == rhs.details &&
      lhs.type == rhs.type &&
      lhs.url == rhs.url &&
      lhs.color == rhs.color &&
      lhs.textColor == rhs.textColor &&
      lhs.sortOrder == rhs.sortOrder &&
      lhs.pickupPolicy == rhs.pickupPolicy &&
      lhs.dropoffPolicy == rhs.dropoffPolicy
  }
}

extension Route: CustomStringConvertible {
  public var description: String {
    return "Route: \(self.routeID)"
  }
}

// MARK: - Routes

///  A representation of a complete Route dataset.
public struct Routes: Identifiable {
  public let id = UUID()
  public var headerFields = [RouteField]()
  fileprivate var routes = [Route]()
  
  subscript(index: Int) -> Route {
    get {
      return routes[index]
    }
    set(newValue) {
      routes[index] = newValue
    }
  }
  
  mutating func add(_ route: Route) {
    // TODO: Add to header fields supported by this colleciton
    self.routes.append(route)
  }
  
  mutating func remove(_ route: Route) {
  }
  
  init<S: Sequence>(_ sequence: S)
  where S.Iterator.Element == Route {
    for route in sequence {
      self.add(route)
    }
  }
  
  init(from url: URL) throws {
    do {
      let records = try String(contentsOf: url).splitRecords()
      
      if records.count < 1 { return }
      let headerRecord = String(records[0])
      self.headerFields = try headerRecord.readHeader()
      
      self.routes.reserveCapacity(records.count - 1)
      for routeRecord in records[1 ..< records.count] {
        let route = try Route(from: String(routeRecord), using: headerFields)
        self.add(route)
      }
    } catch let error {
      throw error
    }
  }
}

extension Routes: Sequence {
  public typealias Iterator = IndexingIterator<Array<Route>>
  
  public func makeIterator() -> Iterator {
    return routes.makeIterator()
  }
}
