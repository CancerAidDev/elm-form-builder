module Form.Types.LanguageCode exposing (LanguageCode(..), fromString, toString)


type LanguageCode
    = EN


fromString : String -> Maybe LanguageCode
fromString str =
    case str of
        "en" ->
            Just EN

        _ ->
            Nothing


toString : LanguageCode -> String
toString code =
    case code of
        EN ->
            "en"
