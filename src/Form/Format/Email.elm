module Form.Format.Email exposing (regex)

import Form.Locale.CountryCode as CountryCode
import Regex


regex : CountryCode.CountryCode -> Regex.Regex
regex _ =
    "^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*$"
        |> Regex.fromString
        |> Maybe.withDefault Regex.never
