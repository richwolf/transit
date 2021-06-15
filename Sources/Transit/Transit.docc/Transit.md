# ``Transit``

Transit strives to be the Swiftiest way to interact with a GTFS static dataset feed.

## Overview

GTFS, or the
[General Transit Feed Specification](https://developers.google.com/transit/gtfs), is a data specificatioin created by Google that allows a transit agency to describe a transit system to developers. More formally, GTFS is actually two two distinct data specifications: the **GTFS Static Specification** and the **GTFS Real-Time Specification**. The GTFS Static Specification describes those features of a transit system that are semi-permanent (i.e., routes, stops, schedules, etc.). The GTFS Real-Time Specification, on the other hand, describes the moment-to-moment state of a transit system (i.e., where specific vehicles are located, estimated arrival times, etc.). The Transit package currently supports the GTFS Static Specification (the GTFS Real-Time specification may be supported in the future). Within this document, GTFS should be taken to refer to the GTFS Static Specification.

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
