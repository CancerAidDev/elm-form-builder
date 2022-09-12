module Form.Validate.Date exposing (dateValidator)

import Form.Field as Field
import Form.Validate.Types as ValidatorTypes
import Iso8601


{-| Validator API for IOS 8601 dates.
-}
dateValidator : ValidatorTypes.Validator
dateValidator _ field =
    Iso8601.toTime (Field.getStringValue_ field)
        |> Result.map (\_ -> field)
        |> Result.mapError (always (ValidatorTypes.InvalidDate field))
