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
    {- Regex from: https://github.com/google/libphonenumber/blob/30db8f67a1c06b3ab052497477be1d9f18312387/resources/PhoneNumberMetadata.xml

       Copyright (C) 2009 The Libphonenumber Authors

       Licensed under the Apache License, Version 2.0 (the "License");
       you may not use this file except in compliance with the License.
       You may obtain a copy of the License at
       http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing, software
       distributed under the License is distributed on an "AS IS" BASIS,
       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
       See the License for the specific language governing permissions and
       limitations under the License.
    -}
    let
        -- Validates both US and Canadian numbers using North American Numbering Plan (NANP)
        nanpRegex : Regex.Regex
        nanpRegex =
            "^((?:3052(?:0[0-8]|[1-9]\\d)\\d{4}|(?:2742|305[3-9])\\d{6}|(?:472|983)[2-47-9]\\d{6}|(?:2(?:0[1-35-9]|1[02-9]|2[03-57-9]|3[1459]|4[08]|5[1-46]|6[0279]|7[0269]|8[13])|3(?:0[1-47-9]|1[02-9]|2[013-79]|3[0-24679]|4[167]|5[0-2]|6[01349]|8[056])|4(?:0[124-9]|1[02-579]|2[3-5]|3[0245]|4[023578]|58|6[349]|7[0589]|8[04])|5(?:0[1-57-9]|1[0235-8]|20|3[0149]|4[01]|5[179]|6[1-47]|7[0-5]|8[0256])|6(?:0[1-35-9]|1[024-9]|2[03689]|3[016]|4[0156]|5[01679]|6[0-279]|78|8[0-269])|7(?:0[1-46-8]|1[2-9]|2[04-8]|3[0-247]|4[0378]|5[47]|6[02359]|7[0-59]|8[156])|8(?:0[1-68]|1[02-8]|2[0168]|3[0-2589]|4[03578]|5[046-9]|6[02-5]|7[028])|9(?:0[1346-9]|1[02-9]|2[0589]|3[0146-8]|4[01357-9]|5[12469]|7[0-3589]|8[04-69]))[2-9]\\d{6}|(?:2(?:04|[23]6|[48]9|5[07]|63)|3(?:06|43|54|6[578]|82)|4(?:03|1[68]|[26]8|3[178]|50|74)|5(?:06|1[49]|48|79|8[147])|6(?:04|[18]3|39|47|72)|7(?:0[59]|42|53|78|8[02])|8(?:[06]7|19|25|7[39])|9(?:0[25]|42))[2-9]\\d{6}))$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never
    in
    case code of
        CountryCode.AU ->
            "^(4(?:79[01]|83[0-36-9]|95[0-3])\\d{5}|4(?:[0-36]\\d|4[047-9]|[58][0-24-9]|7[02-8]|9[0-47-9])\\d{6})$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never

        CountryCode.NZ ->
            "^(2(?:[0-27-9]\\d|6)\\d{6,7}|2(?:1\\d|75)\\d{5})$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never

        CountryCode.US ->
            nanpRegex

        CountryCode.CA ->
            nanpRegex

        _ ->
            "^\\d*$"
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
    let
        -- North American Numbering Plan (NANP) format.
        -- US and Canada share the same numbering structure.
        nanpGroup : List Int
        nanpGroup =
            [ 3, 3, 4 ]
    in
    case code of
        CountryCode.NZ ->
            [ 2, 3, 5 ]

        CountryCode.US ->
            nanpGroup

        CountryCode.CA ->
            nanpGroup

        _ ->
            [ 3, 3, 3 ]
