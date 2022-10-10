module Form.Lib.RegexValidation exposing (decoder, RegexValidation)

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
