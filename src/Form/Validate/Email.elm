module Form.Validate.Email exposing (emailValidator)

import Form.Format.Email as Email
import Form.Locale as Locale
import Form.Validate.Types as ValidatorTypes
import Regex


emailValidator : ValidatorTypes.Validator
emailValidator (Locale.Locale _ code) value =
    if Regex.contains (Email.regex code) value then
        Ok value

    else
        Err ValidatorTypes.InvalidEmail
