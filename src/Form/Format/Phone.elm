module Form.Format.Phone exposing
    ( mobileRegex, landlineRejectRegex
    , formatForSubmission, formatForDisplay
    )

{-| Mobile phone number regular expressions and formatting.


# Phone Regexes

@docs mobileRegex, landlineRejectRegex


# Phone Formatting

@docs formatForSubmission, formatForDisplay

-}

import Form.Locale.CountryCode as CountryCode
import Form.Locale.Phone as Phone
import List.Extra as ListExtra
import Regex
import String.Extra as StringExtra


{-| The numbers to accept based on country.
-}
mobileRegex : CountryCode.CountryCode -> Regex.Regex
mobileRegex code =
    -- Regex from: https://github.com/google/libphonenumber/blob/30db8f67a1c06b3ab052497477be1d9f18312387/resources/PhoneNumberMetadata.xml
    case code of
        CountryCode.AU ->
            "^4(?:79[01]|83[0-389]|94[0-4])\\d{5}|4(?:[0-36]\\d|4[047-9]|5[0-25-9]|7[02-8]|8[0-24-9]|9[0-37-9])\\d{6}$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never

        CountryCode.NZ ->
            "^2(?:[0-27-9]\\d|6)\\d{6,7}|2(?:1\\d|75)\\d{5}$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never

        -- Validates both US and Canadian numbers
        CountryCode.US ->
            "^(?:5056(?:[0-35-9]\\d|4[468])|7302[0-4]\\d)\\d{4}|(?:472[24]|505[2-57-9]|7306|983[2-47-9])\\d{6}|(?:2(?:0[1-35-9]|1[02-9]|2[03-57-9]|3[1459]|4[08]|5[1-46]|6[0279]|7[0269]|8[13])|3(?:0[1-57-9]|1[02-9]|2[013569]|3[0-24679]|4[167]|5[0-2]|6[01349]|8[056])|4(?:0[124-9]|1[02-579]|2[3-5]|3[0245]|4[023578]|58|6[349]|7[0589]|8[04])|5(?:0[1-47-9]|1[0235-8]|20|3[0149]|4[01]|5[179]|6[1-47]|7[0-5]|8[0256])|6(?:0[1-35-9]|1[024-9]|2[03689]|3[016]|4[0156]|5[01679]|6[0-279]|78|8[0-29])|7(?:0[1-46-8]|1[2-9]|2[04-8]|3[1247]|4[037]|5[47]|6[02359]|7[0-59]|8[156])|8(?:0[1-68]|1[02-8]|2[068]|3[0-2589]|4[03578]|5[046-9]|6[02-5]|7[028])|9(?:0[1346-9]|1[02-9]|2[0589]|3[0146-8]|4[01357-9]|5[12469]|7[0-389]|8[04-69]))[2-9]\\d{6}$|^(?:2(?:04|[23]6|[48]9|50|63)|3(?:06|43|54|6[578]|82)|4(?:03|1[68]|[26]8|3[178]|50|74)|5(?:06|1[49]|48|79|8[147])|6(?:04|[18]3|39|47|72)|7(?:0[59]|42|53|78|8[02])|8(?:[06]7|19|25|7[39])|90[25])[2-9]\\d{6}$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never

        _ ->
            "^\\d.*$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never


{-| The landline numbers to reject (we only accept mobile numbers) based on country.
-}
landlineRejectRegex : CountryCode.CountryCode -> Regex.Regex
landlineRejectRegex code =
    case code of
        CountryCode.AU ->
            "^\\d{9}$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never

        _ ->
            "^\\d.*$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never


{-| -}
formatForSubmission : CountryCode.CountryCode -> String -> String
formatForSubmission code =
    String.words
        >> String.concat
        >> (\phone -> Phone.phonePrefix code ++ phone)


{-| The groupings of digits for phone numbers
-}
formatForDisplay : CountryCode.CountryCode -> String -> String
formatForDisplay code =
    StringExtra.rightOf (Phone.phonePrefix code)
        >> String.toList
        >> ListExtra.groupsOfVarying (formatGroups code)
        >> List.map String.fromList
        >> String.join " "


formatGroups : CountryCode.CountryCode -> List Int
formatGroups code =
    case code of
        CountryCode.NZ ->
            [ 2, 3, 5 ]

        CountryCode.US ->
            [ 3, 3, 4 ]

        _ ->
            [ 3, 3, 3 ]
