module Form.Locale exposing
    ( Locale(..)
    , fromString, toString, decoder, encode, urlParser, toCountryCodeString
    , enAU, enNZ, enUS
    , enCA
    )

{-| Locale data type


# Locale

@docs Locale


# Helpers

@docs fromString, toString, decoder, encode, urlParser, toCountryCodeString


# Locales

@docs enAU, enNZ, enUS

-}

import Form.Locale.CountryCode as CountryCode
import Form.Locale.LanguageCode as LanguageCode
import Json.Decode as Decode
import Json.Decode.Extra as DecodeExtra
import Json.Encode as Encode
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
decoder : Decode.Decoder Locale
decoder =
    Decode.string
        |> Decode.andThen
            (fromString >> DecodeExtra.fromMaybe "Invalid locale")


{-| -}
encode : Locale -> Encode.Value
encode =
    toString >> Encode.string


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
enCA : Locale
enCA =
    Locale LanguageCode.EN CountryCode.CA


{-| -}
urlParser : UrlParser.Parser (Locale -> a) a
urlParser =
    UrlParser.custom "LOCALE" fromString
