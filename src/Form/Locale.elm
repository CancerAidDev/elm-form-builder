module Form.Locale exposing
    ( Locale(..)
    , fromString, toString, urlParser, toCountryCodeString
    , enAU, enNZ, enUS
    )

{-| Locale data type


# Locale

@docs Locale


# Helpers

@docs fromString, toString, urlParser, toCountryCodeString


# Locales

@docs enAU, enNZ, enUS

-}

import Form.Locale.CountryCode as CountryCode
import Form.Locale.LanguageCode as LanguageCode
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
toCountryCodeString : Locale -> String
toCountryCodeString (Locale _ country) =
    CountryCode.toString country


{-| -}
enAU : Locale
enAU =
    Locale LanguageCode.EN CountryCode.AU


{-| -}
enNZ : Locale
enNZ =
    Locale LanguageCode.EN CountryCode.NZ


{-| -}
enUS : Locale
enUS =
    Locale LanguageCode.EN CountryCode.US


{-| -}
urlParser : UrlParser.Parser (Locale -> a) a
urlParser =
    UrlParser.custom "LOCALE" fromString
