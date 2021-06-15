# ``Transit/Route``

## Overview

The table below shows the mapping between the possible GTFS fields found within an `Route` dataset record and Transit ``Route`` property names. In addition, it shows the Swift types associated with each of those properties.

GTFS Field Name       | Swift Property Name     | Swift Type
--------------------- | ----------------------- | ----------
`route_id`            | ``Route/routeID``       | `String`
`agency_id`           | ``Route/agencyID``      | `String?`
`route_long_name`     | ``Route/name``          | `String?`
`route_short_name`    | ``Route/shortName``     | `String?`
`route_desc`          | ``Route/details``       | `String?`
`route_type`          | ``Route/type``          | ``RouteType``
`route_url`           | ``Route/url``           | `URL?`
`route_color`         | ``Route/color``         | `CGColor?`
`route_text_color`    | ``Route/textColor``     | `CGColor?`
`route_sort_order`    | ``Route/sortOrder``     | `UInt?`
`continuous_pickup`   | ``Route/pickupPolicy``  | ``PickupDropffPolicy?``
`continuous_drop_off` | ``Route/dropoffPolicy`` | ``PickupDropffPolicy?``

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
