module Form.Validate.Types exposing (ErrorToMessage, StringError(..), Validator)

import Form.Locale as Locale


type StringError
    = RequiredError
    | InvalidOption
    | InvalidMobilePhoneNumber
    | InvalidPhoneNumber
    | InvalidEmail
    | InvalidDate
    | InvalidUrl


type alias Validator =
    Locale.Locale -> String -> Result StringError String


type alias ErrorToMessage =
    Locale.Locale -> String -> String
