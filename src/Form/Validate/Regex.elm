module Form.Validate.Regex exposing (regexValidator)

import Form.Field as Field
import Form.Lib.RegexValidation as RegexValidation
import Form.Validate.Types as ValidatorTypes
import Regex


regexValidator : (Field.StringField -> String) -> List RegexValidation.RegexValidation -> Field.StringField -> Result ValidatorTypes.StringFieldError Field.StringField
regexValidator getValue regexValidation field =
    let
        value =
            getValue field
    in
    case regexValidation of
        { pattern, message } :: xs ->
            if Regex.contains pattern value then
                regexValidator getValue xs field

            else
                Err <| ValidatorTypes.RegexIncongruence message

        [] ->
            Ok field
