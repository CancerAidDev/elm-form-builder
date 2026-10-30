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
import Form.Format.Date as DateFormat
import Form.Locale as Locale
import Form.Locale.CountryCode as CountryCode
import Form.Validate.Date as Date
import Form.Validate.Email as Email
import Form.Validate.Options as Options
import Form.Validate.Phone as Phone
import Form.Validate.Regex as RegexValidator
import Form.Validate.Required as Required
import Form.Validate.Types as Types
import Form.Validate.UrlValidator as UrlValidator
import Time


{-| Validator API for a StringField being valid. The current time and zone are used for date ranges.
-}
validate : Time.Zone -> Time.Posix -> Types.Validator
validate zone time locale field =
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
                Field.SimpleField { tipe, regexValidation } ->
                    let
                        simpleFieldValidator : Field.StringField -> Result Types.StringFieldError Field.StringField
                        simpleFieldValidator valField =
                            case tipe of
                                FieldType.Email ->
                                    Email.emailValidator locale valField

                                FieldType.Phone ->
                                    Phone.phoneValidator locale valField

                                FieldType.Url ->
                                    UrlValidator.urlValidator locale valField

                                FieldType.Text ->
                                    Ok valField

                                FieldType.TextArea ->
                                    Ok valField

                                FieldType.Time ->
                                    Ok valField
                    in
                    simpleFieldValidator field
                        |> Result.andThen (RegexValidator.regexValidator regexValidation)

                Field.DateField { tipe } ->
                    Date.dateValidator zone time tipe locale field

                Field.SelectField { options } ->
                    Options.optionsValidator options locale field

                Field.SearchableSelectField { options } ->
                    Options.optionsValidator options locale field

                Field.HttpSelectField { options } ->
                    Options.remoteOptionsValidator options locale field

                Field.HttpSearchableSelectField { options } ->
                    Options.remoteOptionsValidator options locale field

                Field.RadioField { options } ->
                    Options.optionsValidator options locale field

                Field.ColorField _ ->
                    Ok field


{-| Localised error message API for a StringField error.
-}
errorToMessage : Types.ErrorToMessage
errorToMessage locale field error =
    case error of
        Types.RequiredError ->
            "Field is required"

        Types.InvalidOption ->
            "Invalid option"

        Types.InvalidMobilePhoneNumber ->
            Phone.mobileErrorToMessage locale field

        Types.InvalidPhoneNumber ->
            "Invalid phone number"

        Types.InvalidEmail ->
            "Invalid email address"

        Types.InvalidDate ->
            "Enter a valid date (" ++ dateFormat locale field ++ ")"

        Types.DateTooEarly earliest ->
            "Date must be on or after " ++ formatDate locale field earliest

        Types.DateTooLate latest ->
            "Date must be on or before " ++ formatDate locale field latest

        Types.InvalidUrl ->
            "Invalid url"

        Types.RegexIncongruence msg ->
            msg


{-| Masked date inputs show dates in the locale's date order, and date pickers take ISO 8601 dates.
-}
maskedDateCode : Locale.Locale -> Field.StringField -> Maybe CountryCode.CountryCode
maskedDateCode (Locale.Locale _ code) field =
    case Field.getStringType field of
        FieldType.DateType { input } ->
            case input of
                FieldType.Masked ->
                    Just code

                FieldType.Calendar ->
                    Nothing

        _ ->
            Nothing


dateFormat : Locale.Locale -> Field.StringField -> String
dateFormat locale field =
    maskedDateCode locale field
        |> Maybe.map (Just >> DateFormat.placeholder)
        |> Maybe.withDefault "YYYY-MM-DD"


formatDate : Locale.Locale -> Field.StringField -> String -> String
formatDate locale field isoDate =
    maskedDateCode locale field
        |> Maybe.map (\code -> DateFormat.toDisplay (Just code) isoDate)
        |> Maybe.withDefault isoDate
