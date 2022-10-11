module Form.Validate.Regex exposing (regexValidator)

import Form.Field as Field
import Form.Lib.RegexValidation as RegexValidation
import Form.Validate.Types as ValidatorTypes
import Regex


regexValidator : List RegexValidation.RegexValidation -> Field.StringField -> Result ValidatorTypes.StringFieldError Field.StringField
regexValidator regexValidation field =
    case regexValidation of
        { pattern, message } :: xs ->
            if Regex.contains pattern (Field.getStringValue_ field) then
                regexValidator xs field

            else
                Err <| ValidatorTypes.RegexIncongruence message

        [] ->
            Ok field
