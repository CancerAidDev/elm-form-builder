module Form.Lib.RegexValidation exposing
    ( decoder, RegexValidation
    , forbidSuffixRegex, fromSuffixConstraints
    )

{-| Helper functions for Regex Validation


# Time

@docs decoder, RegexValidation

-}

import Json.Decode as Decode
import Json.Decode.Pipeline as DecodePipeline
import Regex


{-| -}
type alias RegexValidation =
    { pattern : Regex.Regex
    , message : String
    }


{-| -}
decoder : Decode.Decoder RegexValidation
decoder =
    Decode.succeed RegexValidation
        |> DecodePipeline.required "pattern" regexDecoder
        |> DecodePipeline.optional "message" Decode.string ""


{-| -}
fromSuffixConstraints : List ( String, String ) -> List RegexValidation
fromSuffixConstraints constraints =
    let
        pairToRegexValidation : ( String, String ) -> Maybe RegexValidation
        pairToRegexValidation ( suffix, message ) =
            Maybe.map (\regex -> { pattern = regex, message = message }) <|
                forbidSuffixRegex suffix
    in
    List.filterMap pairToRegexValidation constraints


{-| Constructs a Regex that forbids a string from having the provided suffixes.
Avoids lookarounds to ensure compatibility with WebKit-based browsers.
-}
forbidSuffixRegex : String -> Maybe Regex.Regex
forbidSuffixRegex =
    Regex.fromString << forbidSuffixRegexString


forbidSuffixRegexString : String -> String
forbidSuffixRegexString suffix =
    let
        length : Int
        length =
            String.length suffix
    in
    case length of
        0 ->
            ".*"

        1 ->
            ".*" ++ suffix ++ "$"

        _ ->
            let
                firstTerm : List String
                firstTerm =
                    [ "([^"
                        ++ String.left 1 suffix
                        ++ "]"
                        ++ ".{"
                        ++ String.fromInt (length - 1)
                        ++ "}"
                    ]

                midIndices : List ( Int, Int )
                midIndices =
                    List.map (\i -> ( i, length - i - 1 )) <|
                        List.range 1 (length - 2)

                midStrings : List String
                midStrings =
                    List.map String.fromChar <| String.toList <| String.dropRight 1 <| String.dropLeft 1 suffix

                formatMidString : ( Int, Int ) -> String -> String
                formatMidString ( incrementingIndex, decrementingIndex ) char =
                    ".{"
                        ++ String.fromInt incrementingIndex
                        ++ "}[^"
                        ++ char
                        ++ "].{"
                        ++ String.fromInt decrementingIndex
                        ++ "}"

                midTerms : List String
                midTerms =
                    List.map2 formatMidString midIndices midStrings

                lastTerm : List String
                lastTerm =
                    [ ".{" ++ String.fromInt (length - 1) ++ "}[^" ++ String.right 1 suffix ++ "]$" ]

                matchShorter : List String
                matchShorter =
                    [ "^.{0," ++ String.fromInt (length - 1) ++ "})$" ]
            in
            String.join "|" <|
                List.concat [ firstTerm, midTerms, lastTerm, matchShorter ]


regexDecoder : Decode.Decoder Regex.Regex
regexDecoder =
    Decode.string
        |> Decode.andThen
            (\pattern ->
                case Regex.fromString pattern of
                    Just regex ->
                        Decode.succeed regex

                    Nothing ->
                        Decode.fail "Regex does not compile"
            )
