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
import Form.Validate.Date as Date
import Form.Validate.Email as Email
import Form.Validate.Options as Options
import Form.Validate.Phone as Phone
import Form.Validate.Regex as RegexValidator
import Form.Validate.Required as Required
import Form.Validate.Types as Types
import Form.Validate.UrlValidator as UrlValidator


{-| Validator API for a StringField being valid.
-}
validate : Types.Validator
validate field =
    let
        requiredResult =
            Required.requiredValidator field
    in
    case requiredResult of
        Err err ->
            if Field.isRequired (Field.StringField_ field) == Required.Yes then
                Err err

            else
                Ok field

        Ok _ ->
            case field of
                Field.SimpleField { tipe, regexValidation } ->
                    let
                        simpleFieldValidator : Field.StringField -> Result Types.StringFieldError Field.StringField
                        simpleFieldValidator valField =
                            case tipe of
                                FieldType.Email ->
                                    Email.emailValidator valField

                                FieldType.Url ->
                                    UrlValidator.urlValidator valField

                                FieldType.Text ->
                                    Ok valField

                                FieldType.TextArea ->
                                    Ok valField

                                FieldType.Time ->
                                    Ok valField
                    in
                    simpleFieldValidator field
                        |> Result.andThen (RegexValidator.regexValidator regexValidation)

                Field.PhoneField _ ->
                    Phone.phoneValidator field

                Field.DateField _ ->
                    Date.dateValidator field

                Field.SelectField { options } ->
                    Options.optionsValidator options field

                Field.SearchableSelectField { options } ->
                    Options.optionsValidator options field

                Field.HttpSelectField { options } ->
                    Options.remoteOptionsValidator options field

                Field.RadioField { options } ->
                    Options.optionsValidator options field


{-| Localised error message API for a StringField error.
-}
errorToMessage : Types.ErrorToMessage
errorToMessage field error =
    case error of
        Types.RequiredError ->
            "Field is required"

        Types.InvalidOption ->
            "Invalid option"

        Types.InvalidMobilePhoneNumber ->
            Phone.mobileErrorToMessage field

        Types.InvalidPhoneNumber ->
            "Invalid phone number"

        Types.InvalidEmail ->
            "Invalid email address"

        Types.InvalidDate ->
            -- Only old browsers without a date picker should trigger this error
            "Date format should be YYYY-MM-DD"

        Types.InvalidUrl ->
            "Invalid url"

        Types.RegexIncongruence msg ->
            msg
