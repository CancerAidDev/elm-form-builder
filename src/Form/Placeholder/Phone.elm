module Form.Placeholder.Phone exposing (toMobilePlaceholder)

{-| Return placeholder based on country code.

@docs toMobilePlaceholder

-}

import Form.Locale.CountryCode as CountryCode


{-| -}
toMobilePlaceholder : Maybe CountryCode.CountryCode -> String
toMobilePlaceholder code =
    case code of
        Just CountryCode.US ->
            "212 200 0000"

        Just CountryCode.NZ ->
            "20 000 0000"

        Just CountryCode.AU ->
            "400 000 000"

        _ ->
            ""
