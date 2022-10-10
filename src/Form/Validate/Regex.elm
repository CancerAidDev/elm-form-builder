module Form.Validate.Regex exposing (regexValidator)

import Form.Field as Field
import Form.Lib.RegexValidation as RegexValidation
import Form.Validate.Types as ValidatorTypes
import Regex


regexValidator : Maybe RegexValidation.RegexValidation -> Field.StringField -> Result ValidatorTypes.StringFieldError Field.StringField
regexValidator regexValidation field =
    case regexValidation of
        Just { pattern, message } ->
            if Regex.contains pattern (Field.getStringValue_ field) then
                Ok field

            else
                Err <| ValidatorTypes.RegexIncongruence message

        Nothing ->
            Ok field
