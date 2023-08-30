module Form.Validate.Types exposing
    ( ValidatorByLocale, ValidatorByCode
    , ErrorToMessage, StringFieldError(..)
    )

{-| Types used for validation.


# Validate

@docs ValidatorByLocale, ValidatorByCode


# Error Messages

@docs ErrorToMessage, StringFieldError

-}

import Form.Field as Field
import Form.Locale as Locale
import Form.Locale.CountryCode as CountryCode


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


{-| API for validating StringFields by locale(already with just the value of the field)
-}
type alias ValidatorByLocale =
    Locale.Locale -> Field.StringField -> Result StringFieldError Field.StringField


{-| API for validating StringFields by country code (already with just the value of the field)
-}
type alias ValidatorByCode =
    CountryCode.CountryCode -> Field.StringField -> Result StringFieldError Field.StringField


{-| API for localised error messages
-}
type alias ErrorToMessage =
    Maybe CountryCode.CountryCode -> Field.StringField -> StringFieldError -> String
