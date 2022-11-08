module Form.Lib.Time exposing
    ( toDateString
    , offsetYear
    , offsetDay
    )

{-| Helper functions for working with elm/time


# Time

@docs toDateString

@docs offsetYear

-}

import Iso8601
import Time
import Time.Extra as TimeExtra


{-| Uses Iso8601.fromTime produces a date with timestamp and takes first 10 characters to return "YYYY-MM-DD"
-}
toDateString : Time.Posix -> String
toDateString =
    Iso8601.fromTime >> String.left 10


{-| Offsets a time by the given number of years and returns a new time, floored to the start of the year.
-}
offsetYear : Int -> Time.Posix -> Time.Posix
offsetYear offset time =
    time
        |> TimeExtra.add TimeExtra.Year offset Time.utc
        |> TimeExtra.floor TimeExtra.Year Time.utc


offsetDay : Int -> Time.Posix -> Time.Posix
offsetDay offset time =
    time
        |> TimeExtra.add TimeExtra.Day offset Time.utc
