module Form.Placeholder.Placeholder exposing (toPlaceholder)

{-| Placeholder is a localised String value to place inside text fields to help the user understand what to put.

@docs toPlaceholder

-}

import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Locale.CountryCode as CountryCode
import Form.Placeholder.Phone as Phone


{-| Placeholder to render for the given field type.
-}
toPlaceholder : Field.Field -> Maybe CountryCode.CountryCode -> String
toPlaceholder fieldType code =
    case fieldType of
        Field.StringField_ (Field.SimpleField { tipe }) ->
            case tipe of
                FieldType.Email ->
                    "your@email.com"

                FieldType.Phone ->
                    Phone.toMobilePlaceholder code

                _ ->
                    ""

        Field.StringField_ (Field.PhoneUniversalField { selectedCountryCode }) ->
            Phone.toMobilePlaceholder selectedCountryCode

        _ ->
            ""
