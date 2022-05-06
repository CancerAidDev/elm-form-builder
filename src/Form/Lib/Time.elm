module Form.Lib.Time exposing (toDateString)

{-| Helper functions for working with elm/time


# Time

@docs toDateString

-}

import Iso8601
import Time


{-| -}
toDateString : Time.Posix -> String
toDateString =
    -- Iso8601.fromTime produces a date with timestamp
    -- Take first 10 characters to return "YYYY-MM-DD"
    Iso8601.fromTime >> String.left 10
