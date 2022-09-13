module Form.Validate.Phone exposing (phoneValidator, mobileErrorToMessage)

{-| Phone number helpers


# Phone

@docs phoneValidator, mobileErrorToMessage

-}

import Form.Field as Field
import Form.Format.Phone as Phone
import Form.Locale as Locale
import Form.Locale.CountryCode as CountryCode
import Form.Validate.Types as ValidatorTypes
import Regex


{-| Validator API for localised (mobile/cell/landline) phone numbers.
-}
phoneValidator : ValidatorTypes.Validator
phoneValidator (Locale.Locale _ code) field =
    let
        normalisedValue =
            String.trim (Field.getStringValue_ field) |> String.words |> String.concat
    in
    if Regex.contains (Phone.mobileRegex code) normalisedValue then
        Ok field

    else if Regex.contains (Phone.landlineRejectRegex code) normalisedValue then
        Err ValidatorTypes.InvalidMobilePhoneNumber

    else
        Err ValidatorTypes.InvalidPhoneNumber


{-| Error Message API for localised (mobile/cell/landline) phone number validation
-}
mobileErrorToMessage : ValidatorTypes.ErrorToMessage
mobileErrorToMessage (Locale.Locale _ country) field =
    case country of
        CountryCode.AU ->
            "Invalid mobile number (example: 4XX XXX XXX)"

        CountryCode.NZ ->
            let
                str =
                    String.trim (Field.getStringValue_ field)

                firstTwoNumbers =
                    if String.length str >= 2 then
                        String.slice 0 2 str

                    else
                        "20"
            in
            "Invalid mobile number (example: " ++ firstTwoNumbers ++ " XXX XXX[XX])"

        CountryCode.US ->
            "Invalid mobile number (example: 212 2XX XXXX)"

        _ ->
            "Invalid mobile number"
