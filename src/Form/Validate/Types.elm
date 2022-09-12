module Form.Validate.Types exposing
    ( Validator, ErrorToMessage
    , StringFieldError(..)
    )

{-| Types used for validation.


# Validate

@docs StringError

@docs Validator, ErrorToMessage

-}

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


{-| API for validating StringFields (already with just the value of the field)
-}
type alias Validator =
    Locale.Locale -> String -> Result StringFieldError String


{-| API for localised error messages
-}
type alias ErrorToMessage =
    Locale.Locale -> String -> String
