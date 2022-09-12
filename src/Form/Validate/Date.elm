module Form.Validate.Date exposing (dateValidator)

import Form.Validate.Types as ValidatorTypes
import Iso8601


{-| Validator API for IOS 8601 dates.
-}
dateValidator : ValidatorTypes.Validator
dateValidator _ value =
    Iso8601.toTime value
        |> Result.map Iso8601.fromTime
        |> Result.mapError (always ValidatorTypes.InvalidDate)
