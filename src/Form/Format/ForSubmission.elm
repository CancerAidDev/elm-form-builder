module Form.Format.ForSubmission exposing (formatForSubmission)

{-| Translates between what is displayed in the form and what is submitted to the server.

@docs formatForSubmission

-}

import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Format.Date as Date
import Form.Format.Phone as Phone
import Form.Locale as Locale


{-| -}
formatForSubmission : Locale.Locale -> Field.StringField -> String
formatForSubmission (Locale.Locale _ code) field =
    let
        value =
            Field.getStringValue_ field
    in
    case field of
        Field.SimpleField { tipe } ->
            case tipe of
                FieldType.Email ->
                    value

                FieldType.Phone ->
                    Phone.formatForSubmission code (Field.getStringValue_ field)

                FieldType.Url ->
                    value

                FieldType.Text ->
                    value

                FieldType.TextArea ->
                    value

        Field.DateField _ ->
            Field.getParsedDateValue_ field |> Maybe.map (Date.formatForSubmission code) |> Maybe.withDefault (Field.getStringValue_ field)

        Field.SelectField _ ->
            value

        Field.HttpSelectField _ ->
            value

        Field.RadioField _ ->
            value
