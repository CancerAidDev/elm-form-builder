module Form.Placeholder.Placeholder exposing (toPlaceholder)

{-| Placeholder is a localised String value to place inside text fields to help the user understand what to put.

@docs toPlaceholder

-}

import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Placeholder.Phone as Phone


{-| Placeholder to render for the given field type.
-}
toPlaceholder : Field.Field -> String
toPlaceholder field =
    case field of
        Field.StringField_ (Field.SimpleField properties) ->
            case properties.tipe of
                FieldType.Email ->
                    "your@email.com"

                _ ->
                    ""

        Field.StringField_ (Field.PhoneField properties) ->
            case properties.countryCode of
                Just code ->
                    Phone.toMobilePlaceholder code

                Nothing ->
                    Maybe.map Phone.toMobilePlaceholder properties.countryCodeDropdown.value |> Maybe.withDefault ""

        _ ->
            ""
