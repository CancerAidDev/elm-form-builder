module Form.Validate.Types exposing
    ( Validator
    , ErrorToMessage, StringFieldError(..)
    )

{-| Types used for validation.


# Validate

@docs Validator


# Error Messages

@docs ErrorToMessage, StringFieldError

-}

import Form.Field as Field
import Form.Locale as Locale


{-| Error messages that can be produced or displayed for a StringField
-}
type StringFieldError
    = RequiredError
    | InvalidOption
    | InvalidMobilePhoneNumber
    | InvalidPhoneNumber
    | InvalidEmail
    | InvalidDate
    | InvalidUrl
    | RegexIncongruence String
    | IllegalRegex


{-| API for validating StringFields (already with just the value of the field)
-}
type alias Validator =
    Locale.Locale -> Field.StringField -> Result StringFieldError Field.StringField


{-| API for localised error messages
-}
type alias ErrorToMessage =
    Locale.Locale -> Field.StringField -> StringFieldError -> String
