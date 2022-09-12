module Form.Validate.StringField exposing
    ( validate
    , errorToMessage
    )

{-| Validate a localised StringField and produce a localised error message.


# Validate

@docs validate


# Error Messages

@docs errorToMessage

-}

import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Field.Required as Required
import Form.Locale as Locale
import Form.Validate.Date as Date
import Form.Validate.Email as Email
import Form.Validate.Options as Options
import Form.Validate.Phone as Phone
import Form.Validate.Required as Required
import Form.Validate.Types as Types
import Form.Validate.UrlValidator as UrlValidator


{-| Validator API for a StringField being valid.
-}
validate : Locale.Locale -> Field.StringField -> Result Types.StringFieldError Field.StringField
validate locale field =
    let
        requiredResult =
            Required.requiredValidator locale field
    in
    case requiredResult of
        Err err ->
            if Field.isRequired (Field.StringField_ field) == Required.Yes then
                Err err

            else
                Ok field

        Ok _ ->
            case field of
                Field.SimpleField { tipe } ->
                    case tipe of
                        FieldType.Email ->
                            Email.emailValidator locale field

                        FieldType.Date _ ->
                            Date.dateValidator locale field

                        FieldType.Phone ->
                            Phone.phoneValidator locale field

                        FieldType.Url ->
                            UrlValidator.urlValidator locale field

                        FieldType.Text ->
                            Ok field

                        FieldType.TextArea ->
                            Ok field

                Field.SelectField { options } ->
                    Options.optionsValidator options locale field

                Field.HttpSelectField { options } ->
                    Options.remoteOptionsValidator options locale field

                Field.RadioField { options } ->
                    Options.optionsValidator options locale field


{-| Localised error message API for a StringField error.
-}
errorToMessage : Locale.Locale -> Types.StringFieldError -> String
errorToMessage locale error =
    case error of
        Types.RequiredError _ ->
            "Field is required"

        Types.InvalidOption _ ->
            "Invalid option"

        Types.InvalidMobilePhoneNumber field ->
            Phone.mobileErrorToMessage locale field

        Types.InvalidPhoneNumber _ ->
            "Invalid phone number"

        Types.InvalidEmail _ ->
            "Invalid email address"

        Types.InvalidDate _ ->
            -- Only old browsers without a date picker should trigger this error
            "Date format should be YYYY-MM-DD"

        Types.InvalidUrl _ ->
            "Invalid url"
