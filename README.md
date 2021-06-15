# Transit

Transit strives to be the Swiftiest way to interact with a GTFS static feed.

## Introduction

GTFS, or the [General Transit Feed Specification](https://developers.google.com/transit/gtfs), is a data specificatioin created by Google that allows a transit agency to describe a transit system to developers. More formally, GTFS is actually two two distinct data specifications: the **GTFS Static Specification** and the **GTFS Real-Time Specification**. The GTFS Static Specification describes those features of a transit system that are semi-permanent (i.e., routes, stops, schedules, etc.). The GTFS Real-Time Specification, on the other hand, describes the moment-to-moment state of a transit system (i.e., where specific vehicles are located, estimated arrival times, etc.). The Transit package currently supports the GTFS Static Specification (the GTFS Real-Time specification may be supported in the future). Within this document, GTFS should be taken to refer to the GTFS Static Specification.

## Installing Transit

Transit is distributed as a [Swift package](https://developer.apple.com/documentation/swift_packages). There are many online tutorials which describe how packages can be installed in an Xcode project.

## Nomenclature

## Using Transit

### Swift Optionals and GTFS Conditionally Required Fields

GTFS distinguishes between three field types: required, conditionally required, and optional. A required field, as its name suggests, must appear in a GTFS feed. An optional feild, on the other hand, may or may not be included within a GTFS feed. Finally, a conditionally required field must be included in a feed if certain conditions are not met…otherwise, it may be safely left out of a feed.

Swift, of course, has instance members that are either strictly optional or strictly required…there is no straightforward way to mark an instance member as “conditinal”. Because this is the case, Transit considers any conditiaonlly required GTFS field to be optional in Swift.

For example, any `Agency` in a GTFS feed is conditionally required to have an `id` if it is included in a feed containing other `Agency` instances (otherwise there is no way to distinguish between different `Agency` instances in a GTFS feed). However, if a feed contains just a single `Agecny`, then that `Agency` need not have an `id`.

In Swift, there is no way to mark a member of a struct optional in some cases, but required in others. Transit, therefore, considers instance members corresponding to GTFS conditiaonlly required fields to be optional. It is, however, necessary to ensure that a GTFS feed conforms to the GTFS specification. For this reason, Transit provides a `doesConform` method which verifies that any Transit instance conforms to the GTFS specification.

### `id`s

Tranist makes all its types `Indentifiable` so that you can use easily use them with frameworks like SwiftUI. Unfortunately, GTFS does not guarantee that IDs will be unique across all GTFS datasets. You might, for example, be dealing with two transit agencies that each vend a route whose ID is “1”. In order to guarantee that all Transit isntances contain unique IDs, Transit instances each of their own IDs.

### `desc` versus `details`

Two GTFS dataset files (`routes.txt` and `stops.txt`) use a `desc` or “description” field. So-as-to avoid confusion with the `CustomStringConvertible` protocol (which requires that adoptors implement a `description` computed member), Transit uses `details` for the `desc` GTFS field. In other words:

```swift
myRoute.details
```

returns a GTFS Agency `desc` field value as a `String` whereas:

```swift
myRoute.description
```
returns a `String` suitable for use the the `CustomStringConvertible` protocol.
