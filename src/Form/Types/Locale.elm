module Form.Types.Locale exposing
    ( Locale(..)
    , toString, urlParser
    , enAU
    )

{-| Locale data type


# Locale

@docs Locale


# Helpers

@docs toString, urlParser


# Locales

@docs enAU

-}

import Form.Types.CountryCode as CountryCode
import Form.Types.LanguageCode as LanguageCode
import Url.Parser as UrlParser


{-| -}
type Locale
    = Locale LanguageCode.LanguageCode CountryCode.CountryCode


{-| -}
fromString : String -> Maybe Locale
fromString str =
    case String.split "-" str of
        [ language, country ] ->
            Maybe.map2 Locale
                (LanguageCode.fromString language)
                (CountryCode.fromString country)

        _ ->
            Nothing


{-| -}
toString : Locale -> String
toString (Locale language country) =
    LanguageCode.toString language ++ "-" ++ CountryCode.toString country


{-| -}
enAU : Locale
enAU =
    Locale LanguageCode.EN CountryCode.AU


{-| -}
urlParser : UrlParser.Parser (Locale -> a) a
urlParser =
    UrlParser.custom "LOCALE" fromString
