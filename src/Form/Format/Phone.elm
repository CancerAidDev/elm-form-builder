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
    case code of
        CountryCode.AU ->
            "^4(?:83[0-38]|93[0-6])\\d{5}|4(?:[0-3]\\d|4[047-9]|5[0-25-9]|6[06-9]|7[02-9]|8[0-24-9]|9[0-27-9])\\d{6}$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never

        CountryCode.NZ ->
            "^2[0-27-9]\\d{7,8}|21\\d{6}$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never

        CountryCode.US ->
            "^5(?:05(?:[2-57-9]\\d\\d|6(?:[0-35-9]\\d|44))|82(?:2(?:0[0-3]|[268]2)|3(?:0[02]|22|33)|4(?:00|4[24]|65|82)|5(?:00|29|58|83)|6(?:00|66|82)|7(?:58|77)|8(?:00|42|5[25]|88)|9(?:00|9[89])))\\d{4}|(?:2(?:0[1-35-9]|1[02-9]|2[03-589]|3[149]|4[08]|5[1-46]|6[0279]|7[0269]|8[13])|3(?:0[1-57-9]|1[02-9]|2[01356]|3[0-24679]|4[167]|5[12]|6[014]|8[056])|4(?:0[124-9]|1[02-579]|2[3-5]|3[0245]|4[023578]|58|6[349]|7[0589]|8[04])|5(?:0[1-47-9]|1[0235-8]|20|3[0149]|4[01]|5[19]|6[1-47]|7[0-5]|8[056])|6(?:0[1-35-9]|1[024-9]|2[03689]|[34][016]|5[01679]|6[0-279]|78|8[0-29])|7(?:0[1-46-8]|1[2-9]|2[04-7]|3[1247]|4[037]|5[47]|6[02359]|7[0-59]|8[156])|8(?:0[1-68]|1[02-8]|2[068]|3[0-289]|4[03578]|5[046-9]|6[02-5]|7[028])|9(?:0[1346-9]|1[02-9]|2[0589]|3[0146-8]|4[01357-9]|5[12469]|7[0-389]|8[04-69]))[2-9]\\d{6}$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never

        _ ->
            "^\\d{7,15}$"
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
formatForSubmission code phone =
    String.words phone
        |> String.concat
        |> (\p -> Phone.phonePrefix code ++ p)


{-| The groupings of digits for phone numbers
-}
formatForDisplay : CountryCode.CountryCode -> String -> String
formatForDisplay code phone =
    StringExtra.rightOf (Phone.phonePrefix code) phone
        |> String.toList
        |> ListExtra.groupsOfVarying (formatGroups code)
        |> List.map String.fromList
        |> String.join " "


formatGroups : CountryCode.CountryCode -> List Int
formatGroups code =
    case code of
        CountryCode.NZ ->
            [ 2, 3, 5 ]

        CountryCode.US ->
            [ 3, 3, 4 ]

        CountryCode.AU ->
            [ 3, 3, 3 ]

        _ ->
            []
