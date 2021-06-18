# ``Transit/Agency``

## Overview

The table below shows the mapping between the possible GTFS fields found within an `Agency` dataset record and Transit ``Agency`` property names. In addition, it shows the Swift types associated with each of those properties.

Note that `agency_lang` is mapped to ``Agency/locale`` to make explicit the Swift type. GTFS condiatonally required or optional field types are mapped into Swift optional types.

GTFS Field Name   | Swift Property Name | Swift Type
----------------- | ------------------- | ----------
`agency_id`       | ``Agency/agencyID`` | `String?`
`agency_name`     | ``Agency/name``     | `String`
`agency_url`      | ``Agency/url``      | `URL`
`agency_timezone` | ``Agency/timeZone`` | `TimeZone`
`agency_lang`     | ``Agency/locale``   | `Locale?`
`agency_phone`    | ``Agency/phone``    | `String?`
`agency_fare_url` | ``Agency/fareURL``  | `URL?`
`agency_email`    | ``Agency/email``    | `String?`

## Topics

### Create an Agency

