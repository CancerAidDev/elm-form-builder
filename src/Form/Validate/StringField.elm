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
validate : Locale.Locale -> Field.StringField -> Result Types.StringFieldError String
validate locale field =
    let
        trimmed =
            String.trim (Field.getStringValue_ field)

        requiredResult =
            Required.requiredValidator locale trimmed
    in
    case requiredResult of
        Err err ->
            if Field.isRequired (Field.StringField_ field) == Required.Yes then
                Err err

            else
                Ok trimmed

        Ok _ ->
            case field of
                Field.SimpleField { tipe } ->
                    case tipe of
                        FieldType.Email ->
                            Email.emailValidator locale trimmed

                        FieldType.Date _ ->
                            Date.dateValidator locale trimmed

                        FieldType.Phone ->
                            Phone.phoneValidator locale trimmed

                        FieldType.Url ->
                            UrlValidator.urlValidator locale trimmed

                        FieldType.Text ->
                            Ok trimmed

                        FieldType.TextArea ->
                            Ok trimmed

                Field.SelectField { options } ->
                    Options.optionsValidator options locale trimmed

                Field.HttpSelectField { options } ->
                    Options.remoteOptionsValidator options locale trimmed

                Field.RadioField { options } ->
                    Options.optionsValidator options locale trimmed


{-| Localised error message API for a StringField error.
-}
errorToMessage : Types.StringFieldError -> Locale.Locale -> Field.StringField -> String
errorToMessage error locale field =
    case error of
        Types.RequiredError ->
            "Field is required"

        Types.InvalidOption ->
            "Invalid option"

        Types.InvalidMobilePhoneNumber ->
            let
                trimmed =
                    String.trim (Field.getStringValue_ field)
            in
            Phone.mobileErrorToMessage locale trimmed

        Types.InvalidPhoneNumber ->
            "Invalid phone number"

        Types.InvalidEmail ->
            "Invalid email address"

        Types.InvalidDate ->
            -- Only old browsers without a date picker should trigger this error
            "Date format should be YYYY-MM-DD"

        Types.InvalidUrl ->
            "Invalid url"
