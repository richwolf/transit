//
// String+Substring.swift
//

// swiftlint:disable todo
// swiftlint:disable file_length

// TODO: Write "writeRecord".
// TODO: Write "writeHeader".

import Foundation
import CoreGraphics
import CoreLocation

// MARK: Substring

extension Substring {

  /**
   Scans for, then returns, the next GTFS field found within `self`.
   
   `nextField` scans characters within `self` for a GTFS field. It will
	 scan characters until either a delimiting comma is found (which delimits
	 the target field from any subsequent fields in `self`) or there are no
	 more characters available to scan in `self` (i.e.,`self` is the final field
	 in the substring). If a comma is embedded within the text of the target
	 field, then the field must be enclosed within a pair
	 of escaping double-quotation marks (and there must be no leading or
	 trailing spaces before, or after, those quotation marks). `nextfield`
	 mutates `self`, so upon return, `self` will begin at the
	 character immediately following the extracted field (excluding any comma
	 delimiter separating the target field from subsequent fields). If self contains no characters, `nextField` assumes it is
	 the final field within the substring and returns an empty string as the
	 field value.
   - Returns: A `String` containing the next GTFS field found within `self`.
   - Throws: `TransitParseError.quoteExpected` will be thrown if a quoted
	 field is not terminated correctly. `TransitParseError.commaExpected` will
	 be thrown if a comma delimiter does not immediately follow a quoted field (except for the final field).
   - Tag: Substring-nextField
   */
  mutating func nextField() throws -> String {
		
		guard !self.isEmpty else { return "" }
		
		switch self[startIndex] {
    case "\"":
      removeFirst()
      guard let nextQuote = firstIndex(of: "\"") else {
        throw TransitError.quoteExpected
      }
      let field = prefix(upTo: nextQuote)
      self = self[index(after: nextQuote)...]
      if !isEmpty {
        let comma = removeFirst()
        if comma != "," { throw TransitError.commaExpected }
      }
      return String(field)
		case ",":
			removeFirst()
			return String("")
    default:
      if let nextComma = firstIndex(of: ",") {
        let field = prefix(upTo: nextComma)
          self = self[index(after: nextComma)...]
          return String(field)
      } else {
          let field = self
          removeAll()
          return String(field)
      }
    }
  }
}

// MARK: - String

extension String {

  /**
   Returns all GTFS fields contained within `self`.
   
   `readRecord` scans `self` for GTFS fields and returns those fields as an
   array of `String`s. Fields are delimited by commas. If a comma is contained
   within a field, then the field must be escaped by enclosing it within
	 quotation marks (`"`).
   - Returns: An array of `String`s containing all GTFS fields found within
	 `self`.
   - Throws: `TransitError.quoteExpected` will be thrown if a quoted field is
	 not terminated correctly. `TransitError.commaExpected` will be thrown if a
	 comma delimiter does not immediately follow a quoted field (except for the
	 final field).
   - Tag: String-readRecord
   */
  public func readRecord() throws -> [String] {
    var remainder = self[..<self.endIndex]
    var result: [String] = []
    do {
      while !remainder.isEmpty {
        try result.append(remainder.nextField())
      }
			// In the case that the record ends with a comma, then there is
			// an extra field that was not detected by `nextField` and we
			// add it as an empty string
			if self.last == "," {
				result.append("")
			}
					
    } catch let error {
      throw error
    }
    return result
  }

  /**
   Returns all GTFS header fields contained within `self`.
   
   `readHeader` scans `self` for contained GTFS header fields and returns them
	 as an array of header `FieldType`s. Header fields are delimited by commas.
	 If a comma is contained within a header field, then the field must be
	 escaped by enclosing it within quotation marks (`"`). If `readHeader` cannot
	 find a `FieldType` that corresponds to a known GTFS field, it will discard
	 the errant field and continue scanning.
   - Returns: An array of `String`s containing all GTFS header fields found
	 within `self`.
   - Throws: `TransitError.quoteExpected` will be thrown if a quoted field is
	 not terminated correctly. `TransitError.commaExpected` will be thrown if a
	 comma delimiter does not immediately follow a quoted field (except for the
	 final field).
   - Tag: String-readHeader
   */
  public func readHeader<FieldType: RawRepresentable>() throws -> [FieldType]
	where FieldType.RawValue == String {
    let components = try self.readRecord()
		return components.map {
			if let headerField = FieldType(rawValue: $0) {
				return headerField
			} else {
				return FieldType(rawValue: "nonstandard")!
      }
    }
  }

  /**
   Return all GTFS records contained within `self`.
   
   `splitRecords()` scans `self` for GTFS records and returns them as an array
   of `Substring`s. GTFS records must be delimited by a line feed, carriage
	 return, or a carriage return followed by line feed. Each GTFS record should
	 then be processed to extract the GTFS fields contained within it.
   - Returns: An array of `Substring`s containing all GTFS records found
	 within `self`.
   - Tag: String-splitRecords
   */
  func splitRecords() -> [Substring] {
    return self.split(whereSeparator: { char in
      switch char {
      case "\r", "\n", "\r\n": return true
      default: return false
      }
    })
  }

  /**
   The `CGColor` representation of `self` or `nil` if `self` cannot be
	 represented as a `CGColor`.
   
   `color` returns a `CGColor` representation of `self` whenever `self`
	 consists of either six or eight hexadecimal characters, optionally preceded
	 by the octothorp (`#`) character; it returns `nil` otherwise. The color
	 encoding should be RGB (for six characters) or RGBA (for eight characters).
	 If the encoding is six characters, then a value of 1.0 will be used as an
	 alpha value.
   - Tag: String-color
   */
  var color: CGColor? {
    var hexString = self
		guard !hexString.isEmpty else { return nil }
    if hexString.hasPrefix("#") {
      let start = self.index(hexString.startIndex, offsetBy: 1)
      hexString = String(self[start...])
    }
    let red, green, blue, alpha: CGFloat
    var hexNumber: UInt64 = 0
    let scanner = Scanner(string: hexString)
    if scanner.scanHexInt64(&hexNumber) {
      if hexString.count == 8 {
        red   = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        green = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        blue  = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        alpha = CGFloat( hexNumber & 0x000000ff) / 255
      } else if hexString.count == 6 {
        red   = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        green = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        blue  = CGFloat( hexNumber & 0x000000ff) / 255
        alpha = 1.0
      } else {
        return nil
      }
			return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(),
										 components: [red, green, blue, alpha])
    }
    return nil
  }

  /**
   Set `self` as the `String` value corresponding to `field` within `instance`.
   
   `assignStringTo` attempts to assign the `String` value associated with
   `self` into `instance` using the `WriteableKeyPath` associated with `field`.
   `field` must conform to the `KeyPathVending` protocol.
   - Throws: `TransitAssignError.invalidPath` if there is no `WriteableKeyPath`
   associated with `field`.
   - Tag: String-assignStringTo
   */
  func assignStringTo<InstanceType, FieldType>(
		_ instance: inout InstanceType,
		for field: FieldType)
	throws where FieldType: KeyPathVending {
    guard let path = field.path as? WritableKeyPath<InstanceType, String>
		else {
      throw TransitAssignError.invalidPath
    }
    instance[keyPath: path] = self
  }

  /**
   Set `self` as a value for an optional `String` field in `instance`.
   - Tag: String-assignOptionalStringTo
   */
  func assignOptionalStringTo<InstanceType, FieldType>(
		_ instance: inout InstanceType,
		for field: FieldType)
	throws where FieldType: KeyPathVending {
    guard let path = field.path as? WritableKeyPath<InstanceType, String?>
		else {
      throw TransitAssignError.invalidPath
    }
		guard self.count > 0 else {
			instance[keyPath: path] = nil
			return
		}
    instance[keyPath: path] = self
  }

  func assignUIntTo<InstanceType, FieldType>(
		_ instance: inout InstanceType,
		for field: FieldType)
	throws where FieldType: KeyPathVending {
    guard let path = field.path as? WritableKeyPath<InstanceType, UInt>
		else {
      throw TransitAssignError.invalidPath
    }
		let trimmed = self.trimmingCharacters(in: .whitespaces)
    guard let uInt = UInt(trimmed)
		else {
      throw TransitAssignError.invalidValue
    }
    instance[keyPath: path] = uInt
  }

  /**
   Set `self` as a value for an optional `UInt` field in `instance`.
   - Tag: String-assignOptionalUIntTo
   */
  func assignOptionalUIntTo<InstanceType, FieldType>(
		_ instance: inout InstanceType,
		for field: FieldType)
	throws where FieldType: KeyPathVending {
    guard let path = field.path as? WritableKeyPath<InstanceType, UInt?>
		else {
      throw TransitAssignError.invalidPath
    }
		let trimmed = self.trimmingCharacters(in: .whitespaces)
		guard trimmed.count > 0 else {
			instance[keyPath: path] = nil
			return
		}
    guard let uInt = UInt(self)
		else {
      throw TransitAssignError.invalidValue
    }
    instance[keyPath: path] = uInt
  }

  /**
   Set `self` as a value for a `URL` field in `instance`.
   - Tag: String-assignURLValueTo
   */
  func assignURLValueTo<InstanceType, FieldType>(
		_ instance: inout InstanceType,
		for field: FieldType)
  throws where FieldType: KeyPathVending {
    guard let path = field.path as? WritableKeyPath<InstanceType, URL>
		else {
      throw TransitAssignError.invalidPath
    }
		let trimmed = self.trimmingCharacters(in: .whitespaces)
    guard let url = URL(string: trimmed)
		else {
      throw TransitAssignError.invalidValue
    }
    instance[keyPath: path] = url
  }

  /**
   Set `self` as a value for an optional `URL` field in `instance`.
   - Tag: String-assignOptionalURLTo
   */
  func assignOptionalURLTo<InstanceType, FieldType>(
		_ instance: inout InstanceType,
		for field: FieldType)
  throws where FieldType: KeyPathVending {
    guard let path = field.path as? WritableKeyPath<InstanceType, URL?>
		else {
      throw TransitAssignError.invalidPath
    }
		let trimmed = self.trimmingCharacters(in: .whitespaces)
		guard trimmed.count > 0 else {
			instance[keyPath: path] = nil
			return
		}
    guard let url = URL(string: trimmed)
		else {
      throw TransitAssignError.invalidValue
    }
    instance[keyPath: path] = url
  }

  /**
   Set `self` as a value for an optional `TimeZone` field in `instance`.
   - Tag: String-assignTimeZoneTo
   */
  func assignTimeZoneTo<InstanceType, FieldType>(
		_ instance: inout InstanceType,
		for field: FieldType)
  throws where FieldType: KeyPathVending {
    guard let path = field.path as? WritableKeyPath<InstanceType, TimeZone>
		else {
      throw TransitAssignError.invalidPath
    }
		let trimmed = self.trimmingCharacters(in: .whitespaces)
    guard let timeZone = TimeZone(identifier: trimmed)
		else {
      throw TransitAssignError.invalidValue
    }
    instance[keyPath: path] = timeZone
  }

  /**
   - Tag: String-assignOptionalTimeZoneTo
   */
  func assignOptionalTimeZoneTo<InstanceType, FieldType>(
		_ instance: inout InstanceType,
		for field: FieldType)
  throws where FieldType: KeyPathVending {
    guard let path = field.path as? WritableKeyPath<InstanceType, TimeZone?>
		else {
      throw TransitAssignError.invalidPath
    }
		let trimmed = self.trimmingCharacters(in: .whitespaces)
		guard trimmed.count > 0 else {
			instance[keyPath: path] = nil
			return
		}
    guard let timeZone = TimeZone(identifier: self)
		else {
      throw TransitAssignError.invalidValue
    }
    instance[keyPath: path] = timeZone
  }

  /**
   Set `self` as a value for an optional `URL` field in `instance`.
   - Tag: String-assignOptionalCGColorTo
   */
  func assignOptionalCGColorTo<InstanceType, FieldType>(
		_ instance: inout InstanceType,
		for field: FieldType)
  throws where FieldType: KeyPathVending {
    guard let path = field.path as? WritableKeyPath<InstanceType, CGColor?>
		else {
      throw TransitAssignError.invalidPath
    }
		let trimmed = self.trimmingCharacters(in: .whitespaces)
		guard trimmed.count > 0 else {
			instance[keyPath: path] = nil
			return
		}
    guard let color = trimmed.color
		else {
      throw TransitAssignError.invalidValue
    }
    instance[keyPath: path] = color
  }

  /**
   - Tag: String-assignOptionalCLLocationDegreesTo
   */
  func assignOptionalCLLocationDegreesTo<InstanceType, FieldType>(
		_ instance: inout InstanceType,
		for field: FieldType
	) throws where FieldType: KeyPathVending {
    guard let path = field.path
						as? WritableKeyPath<InstanceType, CLLocationDegrees?>
		else {
      throw TransitAssignError.invalidPath
    }
		let trimmed = self.trimmingCharacters(in: .whitespaces)
		guard trimmed.count > 0 else {
			instance[keyPath: path] = nil
			return
		}
    guard let locationDegrees = Double(trimmed)
		else {
      throw TransitAssignError.invalidValue
    }
    instance[keyPath: path] = locationDegrees
  }

  func assignLocaleTo<InstanceType, FieldType>(
		_ instance: inout InstanceType,
		for field: FieldType
	) throws where FieldType: KeyPathVending {
    guard let path = field.path as? WritableKeyPath<InstanceType, Locale?>
		else {
      throw TransitAssignError.invalidPath
    }
		let trimmed = self.trimmingCharacters(in: .whitespaces)
    let locale: Locale? = Locale(identifier: trimmed)
    instance[keyPath: path] = locale
  }

  // Remember to test passing an optional to a non-optional value assign.
  /**
   - Tag: String-assignRouteTypeTo
   */
  func assignRouteTypeTo<InstanceType, FieldType>(
		_ instance: inout InstanceType,
		for field: FieldType)
  throws where FieldType: KeyPathVending {
    guard let path = field.path as? WritableKeyPath<InstanceType, RouteType>
		else {
      throw TransitAssignError.invalidPath
    }
		let trimmed = self.trimmingCharacters(in: .whitespaces)
    guard let routeType = Route.routeTypeFrom(string: trimmed)
		else {
      throw TransitAssignError.invalidValue
    }
    instance[keyPath: path] = routeType
  }

  /**
   - Tag: String-assignOptionalPickupDropOffPolicyTo
   */
  func assignOptionalPickupDropOffPolicyTo<InstanceType, FieldType>(
		_ instance: inout InstanceType,
		for field: FieldType
	) throws where FieldType: KeyPathVending {
    guard let path = field.path
						as? WritableKeyPath<InstanceType, PickupDropOffPolicy?>
		else {
      throw TransitAssignError.invalidPath
    }
		let trimmed = self.trimmingCharacters(in: .whitespaces)
		guard trimmed.count > 0 else {
			instance[keyPath: path] = nil
			return
		}
    guard let pickupDropOffPolicy =
						Route.pickupDropOffPolicyFrom(string: trimmed)
		else {
      throw TransitAssignError.invalidValue
    }
    instance[keyPath: path] = pickupDropOffPolicy
  }
}
