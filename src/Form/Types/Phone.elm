module Form.Types.Phone exposing (formatForDisplay, formatForSubmission, mobileRegex, regex)

import Form.Types.CountryCode as CountryCode
import List.Extra as ListExtra
import Regex
import String.Extra as StringExtra


phonePrefix : CountryCode.CountryCode -> String
phonePrefix code =
    case code of
        CountryCode.AU ->
            "+61"


regex : CountryCode.CountryCode -> Regex.Regex
regex code =
    case code of
        CountryCode.AU ->
            "^\\d{9}$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never


mobileRegex : CountryCode.CountryCode -> Regex.Regex
mobileRegex code =
    case code of
        CountryCode.AU ->
            "^4\\d{8}$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never


formatForSubmission : CountryCode.CountryCode -> String -> String
formatForSubmission code =
    String.words
        >> String.concat
        >> (\phone -> phonePrefix code ++ phone)


formatForDisplay : CountryCode.CountryCode -> String -> String
formatForDisplay code =
    StringExtra.rightOf (phonePrefix code)
        >> String.toList
        >> ListExtra.groupsOf 3
        >> List.map String.fromList
        >> String.join " "
