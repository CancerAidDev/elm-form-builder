module Form.Placeholder.Placeholder exposing (..)

{-| Placeholder is a localised String value to place inside text fields to help the user understand what to put.

@docs toPlaceholder

-}

import Form.Field.FieldType as FieldType exposing (SimpleFieldType(..))
import Form.Locale.CountryCode as CountryCode
import Form.Placeholder.Phone as Phone


toPlaceholder : FieldType.SimpleFieldType -> Maybe CountryCode.CountryCode -> String
toPlaceholder fieldType code =
    case fieldType of
        Email ->
            "your@email.com"

        Phone ->
            Phone.toMobilePlaceholder code

        _ ->
            ""
