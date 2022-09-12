module Form.Validate.Phone exposing (mobileErrorToMessage, phoneValidator, toMobilePlaceholder)

{-| -}

import Form.Format.Phone as Phone
import Form.Locale as Locale
import Form.Locale.CountryCode as CountryCode
import Form.Locale.Phone as Phone
import Form.Validate.Types as ValidatorTypes
import List.Extra as ListExtra
import Regex
import String.Extra as StringExtra


phoneValidator : ValidatorTypes.Validator
phoneValidator (Locale.Locale _ code) value =
    let
        normalisedValue =
            value |> String.words |> String.concat
    in
    if Regex.contains (Phone.mobileRegex code) normalisedValue then
        Ok (formatForSubmission code normalisedValue)

    else if Regex.contains (Phone.landlineRegex code) normalisedValue then
        Err ValidatorTypes.InvalidMobilePhoneNumber

    else
        Err ValidatorTypes.InvalidPhoneNumber


{-| -}
mobileErrorToMessage : ValidatorTypes.ErrorToMessage
mobileErrorToMessage (Locale.Locale _ country) str =
    case country of
        CountryCode.AU ->
            "Invalid mobile number (example: 4XX XXX XXX)"

        CountryCode.NZ ->
            let
                defaultPrefix =
                    "20"

                firstTwoNumbers =
                    if String.length str >= 2 then
                        String.slice 0 2 str

                    else
                        defaultPrefix
            in
            "Invalid mobile number (example: " ++ firstTwoNumbers ++ " XXX XXX[XX])"

        CountryCode.US ->
            "Invalid mobile number (example: 212 2XX XXXX)"

        _ ->
            "Invalid mobile number"


{-| -}
formatForSubmission : CountryCode.CountryCode -> String -> String
formatForSubmission code =
    String.words
        >> String.concat
        >> (\phone -> Phone.phonePrefix code ++ phone)


formatGroups : CountryCode.CountryCode -> List Int
formatGroups code =
    case code of
        CountryCode.NZ ->
            [ 2, 3, 5 ]

        CountryCode.US ->
            [ 3, 3, 4 ]

        _ ->
            [ 3, 3, 3 ]


{-| -}
formatForDisplay : CountryCode.CountryCode -> String -> String
formatForDisplay code =
    StringExtra.rightOf (Phone.phonePrefix code)
        >> String.toList
        >> ListExtra.groupsOfVarying (formatGroups code)
        >> List.map String.fromList
        >> String.join " "


toMobilePlaceholder : Maybe CountryCode.CountryCode -> String
toMobilePlaceholder code =
    case code of
        Just CountryCode.US ->
            "212 200 0000"

        Just CountryCode.NZ ->
            "20 000 0000"

        Just _ ->
            "400 000 000"

        Nothing ->
            ""
