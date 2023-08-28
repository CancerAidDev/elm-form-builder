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


{-| API for validating StringFields (already with just the value of the field)
-}
type alias Validator =
    Field.StringField -> Result StringFieldError Field.StringField


{-| API for localised error messages
-}
type alias ErrorToMessage =
    Field.StringField -> StringFieldError -> String
