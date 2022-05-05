module Form.Lib.Time exposing (toDateString)

import Iso8601
import Time


toDateString : Time.Posix -> String
toDateString =
    -- Iso8601.fromTime produces a date with timestamp
    -- Take first 10 characters to return "YYYY-MM-DD"
    Iso8601.fromTime >> String.left 10
