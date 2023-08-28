module Form.Validate.Email exposing (emailValidator)

import Form.Field as Field
import Form.Format.Email as Email
import Form.Validate.Types as ValidatorTypes
import Regex


emailValidator : ValidatorTypes.Validator
emailValidator field =
    if Regex.contains Email.regex (Field.getStringValue_ field) then
        Ok field

    else
        Err ValidatorTypes.InvalidEmail
