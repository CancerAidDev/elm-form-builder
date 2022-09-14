module Form.Placeholder.Placeholder exposing (toPlaceholder)

{-| Placeholder is a localised String value to place inside text fields to help the user understand what to put.

@docs toPlaceholder

-}

import Form.Field.FieldType as FieldType
import Form.Locale.CountryCode as CountryCode
import Form.Placeholder.Phone as Phone


{-| Placeholder to render for the given field type.
-}
toPlaceholder : FieldType.FieldType -> Maybe CountryCode.CountryCode -> String
toPlaceholder fieldType code =
    case fieldType of
        FieldType.StringType (FieldType.SimpleType FieldType.Email) ->
            "your@email.com"

        FieldType.StringType (FieldType.SimpleType FieldType.Phone) ->
            Phone.toMobilePlaceholder code

        _ ->
            ""
