module Form.Validate.Email exposing (emailValidator)

import Form.Field as Field
import Form.Format.Email as Email
import Form.Locale as Locale
import Form.Validate.Types as ValidatorTypes
import Regex


emailValidator : ValidatorTypes.ValidatorByLocale
emailValidator (Locale.Locale _ code) field =
    if Regex.contains (Email.regex code) (Field.getStringValue_ field) then
        Ok field

    else
        Err ValidatorTypes.InvalidEmail
