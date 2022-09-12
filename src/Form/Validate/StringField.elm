module Form.Validate.StringField exposing (validate)

import Form.Field as Field
import Form.Field.FieldType as FieldType
import Form.Field.Required as Required
import Form.Locale as Locale
import Form.Validate.Date as Date
import Form.Validate.Email as Email
import Form.Validate.Options as Options
import Form.Validate.Phone as Phone
import Form.Validate.Required as Required
import Form.Validate.Types as Types exposing (StringError(..))
import Form.Validate.UrlValidator as UrlValidator


validate : Locale.Locale -> Field.StringField -> Result Types.StringError String
validate locale field =
    let
        trimmed =
            String.trim (Field.getStringValue_ field)

        isRequired =
            Field.isRequired (Field.StringField_ field) == Required.Yes

        isRequiredValidated =
            Required.requiredValidator locale trimmed

        validateField =
            case field of
                Field.SimpleField { tipe, value } ->
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

                Field.SelectField { value, options } ->
                    Options.optionsValidator options locale trimmed

                Field.HttpSelectField { value, options } ->
                    Options.remoteOptionsValidator options locale trimmed

                Field.RadioField { value, options } ->
                    Options.optionsValidator options locale trimmed
    in
    if String.isEmpty trimmed then
        if Field.isRequired (Field.StringField_ field) == Required.Yes then
            Err Types.RequiredError

        else
            Ok trimmed

    else
        validateField


errorToMessage : StringError -> Locale.Locale -> Field.StringField -> String
errorToMessage error locale field =
    let
        trimmed =
            String.trim (Field.getStringValue_ field)
    in
    case error of
        RequiredError ->
            "Field is required"

        InvalidOption ->
            "Invalid option"

        InvalidMobilePhoneNumber ->
            Phone.mobileErrorToMessage locale trimmed

        InvalidPhoneNumber ->
            "Invalid phone number"

        InvalidEmail ->
            "Invalid email address"

        InvalidDate ->
            -- Only old browsers without a date picker should trigger this error
            "Date format should be YYYY-MM-DD"

        InvalidUrl ->
            "Invalid url"
