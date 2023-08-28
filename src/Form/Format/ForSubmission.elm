module Form.Format.ForSubmission exposing (formatForSubmission)

{-| Translates between what is displayed in the form and what is submitted to the server.

@docs formatForSubmission

-}

import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Format.Date as Date
import Form.Format.Phone as Phone
import Form.Locale.CountryCode as CountryCode


{-| -}
formatForSubmission : Field.StringField -> String
formatForSubmission field =
    let
        value =
            Field.getStringValue_ field
    in
    case field of
        Field.SimpleField { tipe } ->
            case tipe of
                FieldType.Email ->
                    value

                FieldType.Url ->
                    value

                FieldType.Text ->
                    value

                FieldType.TextArea ->
                    value

                FieldType.Time ->
                    value

        Field.PhoneField _ ->
            Phone.formatForSubmission (Maybe.withDefault CountryCode.AU <| Field.getCountryCode (Field.StringField_ field)) (Field.getStringValue_ field)

        Field.DateField _ ->
            Field.getParsedDateValue_ field
                |> Maybe.map Date.formatForSubmission
                |> Maybe.withDefault (Field.getStringValue_ field)

        Field.SelectField _ ->
            value

        Field.SearchableSelectField _ ->
            value

        Field.HttpSelectField _ ->
            value

        Field.RadioField _ ->
            value
