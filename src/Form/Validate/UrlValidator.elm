module Form.Validate.UrlValidator exposing (urlValidator)

import Form.Validate.Types as ValidateTypes
import Url


{-| Validator API for a value being URL.
-}
urlValidator : ValidateTypes.Validator
urlValidator _ value =
    case Url.fromString value of
        Just _ ->
            Ok value

        Nothing ->
            Err ValidateTypes.InvalidUrl
