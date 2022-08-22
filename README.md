# Transit

Transit strives to be the Swiftiest way to interact with a GTFS static dataset feed.

## Introduction

The [General Transit Feed Specification](https://developers.google.com/transit/gtfs), or GTFS, is a dataset specification that enables a transit agency to describe a transit system to developers. More formally, GTFS is actually comprised of two data specifications: the **GTFS Static Specification** and the **GTFS Real-Time Specification**. The GTFS Static Specification describes those features of a transit system that remain reasonably static (i.e., transit routes, stops, schedules, etc.). The GTFS Real-Time Specification, on the other hand, describes the moment-to-moment state of a transit system (i.e., where specific vehicles are located, estimated arrival times, etc.). The Transit package currently supports the GTFS Static Specification (the GTFS Real-Time specification may be supported in the future). Within this document, GTFS should always be interpreted as referring to the GTFS Static Specification.

## Installing Transit

Transit is distributed as a [Swift package](https://developer.apple.com/documentation/swift_packages). There are many online tutorials which describe how packages can be installed in an Xcode project.

## Usage Example

To use Transit, simply instantiate a `Feed` with the contents of a folder containing GTFS datasets. You can then ask the feed for agency, route, and stop data.

```swift
// Create a feed
let feedURL = URL(fileURLWithPath: "path-to-folder-containing-GTFS-datasets"!)
let feed = Feed(contentsOfURL: feedURL)

// Get the agency name from the feed
if let agencyName = feed.agency?.name {
	print(agencyName)
}

// Print info for every route in the feed
if let routes = feed.routes {
	for route in routes {
		print(route)
	}
}

// Print info for every stop in the feed
if let stops = feed.stops {
	for stop in stops {
		print(stop)
	}
}
```

## Documentation

Transit has embraced Apple’s [DocC](https://developer.apple.com/documentation/docc) documentation compiler. DocC makes it simple to add documentation for a project. Please refer to the documentation included within the Transit package for details on Transit’s use or for help.
