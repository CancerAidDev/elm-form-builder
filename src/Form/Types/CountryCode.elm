module Form.Types.CountryCode exposing (CountryCode(..), fromString, toString)


type CountryCode
    = AU


fromString : String -> Maybe CountryCode
fromString str =
    case str of
        "AU" ->
            Just AU

        _ ->
            Nothing


toString : CountryCode -> String
toString code =
    case code of
        AU ->
            "AU"
