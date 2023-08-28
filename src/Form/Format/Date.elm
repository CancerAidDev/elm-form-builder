module Form.Format.Date exposing (formatForSubmission)

{-| -}

import Iso8601
import Time


formatForSubmission : Time.Posix -> String
formatForSubmission value =
    Iso8601.fromTime value
