module Form.Format.Date exposing (formatForSubmission)

{-| -}

import Form.Locale.CountryCode as CountryCode
import Iso8601
import Time


formatForSubmission : CountryCode.CountryCode -> Time.Posix -> String
formatForSubmission _ value =
    Iso8601.fromTime value
