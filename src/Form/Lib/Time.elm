module Form.Lib.Time exposing (initTime, toDateString)

import Iso8601
import Time
import Time.Extra as TimeExtra


toDateString : Time.Posix -> String
toDateString =
    -- Iso8601.fromTime produces a date with timestamp
    -- Take first 10 characters to return "YYYY-MM-DD"
    Iso8601.fromTime >> String.left 10


initTime : String -> Time.Posix
initTime =
    let
        default =
            TimeExtra.partsToPosix Time.utc <|
                TimeExtra.Parts 2022 Time.Jan 1 0 0 0 0
    in
    Iso8601.toTime >> Result.withDefault default
