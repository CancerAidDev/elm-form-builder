module Form.Types.LanguageCode exposing (LanguageCode(..), fromString, toString)

{-| Limited [ISO 639-1](https://en.wikipedia.org/wiki/ISO_639-1) support. Currently limited to "en".


# LanguageCode

@docs LanguageCode, fromString, toString

-}


{-| -}
type LanguageCode
    = EN


{-| -}
fromString : String -> Maybe LanguageCode
fromString str =
    case str of
        "en" ->
            Just EN

        _ ->
            Nothing


{-| -}
toString : LanguageCode -> String
toString code =
    case code of
        EN ->
            "en"
