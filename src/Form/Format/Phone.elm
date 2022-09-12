module Form.Format.Phone exposing (mobileRegex, landlineRegex)

{-| Mobile (cell) and landline phone number regular expressions


# Phone

@docs mobileRegex, landlineRegex

-}

import Form.Locale.CountryCode as CountryCode
import Regex


landlineRegex : CountryCode.CountryCode -> Regex.Regex
landlineRegex code =
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
mobileRegex : CountryCode.CountryCode -> Regex.Regex
mobileRegex code =
    case code of
        CountryCode.AU ->
            "^4\\d{8}$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never

        CountryCode.NZ ->
            "^2\\d{7,9}$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never

        CountryCode.US ->
            "^5(?:05(?:[2-57-9]\\d\\d|6(?:[0-35-9]\\d|44))|82(?:2(?:0[0-3]|[268]2)|3(?:0[02]|22|33)|4(?:00|4[24]|65|82)|5(?:00|29|58|83)|6(?:00|66|82)|7(?:58|77)|8(?:00|42|5[25]|88)|9(?:00|9[89])))\\d{4}|(?:2(?:0[1-35-9]|1[02-9]|2[03-589]|3[149]|4[08]|5[1-46]|6[0279]|7[0269]|8[13])|3(?:0[1-57-9]|1[02-9]|2[01356]|3[0-24679]|4[167]|5[12]|6[014]|8[056])|4(?:0[124-9]|1[02-579]|2[3-5]|3[0245]|4[023578]|58|6[349]|7[0589]|8[04])|5(?:0[1-47-9]|1[0235-8]|20|3[0149]|4[01]|5[19]|6[1-47]|7[0-5]|8[056])|6(?:0[1-35-9]|1[024-9]|2[03689]|[34][016]|5[01679]|6[0-279]|78|8[0-29])|7(?:0[1-46-8]|1[2-9]|2[04-7]|3[1247]|4[037]|5[47]|6[02359]|7[0-59]|8[156])|8(?:0[1-68]|1[02-8]|2[068]|3[0-289]|4[03578]|5[046-9]|6[02-5]|7[028])|9(?:0[1346-9]|1[02-9]|2[0589]|3[0146-8]|4[01357-9]|5[12469]|7[0-389]|8[04-69]))[2-9]\\d{6}$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never

        _ ->
            "^\\d.*$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never
