module Form.Validate.UrlValidator exposing (urlValidator)

import Form.Field as Field
import Form.Validate.Types as ValidateTypes
import Url


{-| Validator API for a value being URL.
-}
urlValidator : ValidateTypes.ValidatorByLocale
urlValidator _ field =
    case Url.fromString (Field.getStringValue_ field) of
        Just _ ->
            Ok field

        Nothing ->
            Err ValidateTypes.InvalidUrl
