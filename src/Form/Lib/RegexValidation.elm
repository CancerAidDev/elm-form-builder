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
    { pattern : String
    , message : String
    }


{-| -}
decoder : Decode.Decoder RegexValidation
decoder =
    (Decode.succeed RegexValidation
        |> DecodePipeline.required "pattern" Decode.string
        |> DecodePipeline.optional "message" Decode.string ""
    )
        |> Decode.andThen regexCheckValidity


regexCheckValidity : RegexValidation -> Decode.Decoder RegexValidation
regexCheckValidity { pattern, message } =
    case Regex.fromString pattern of
        Just _ ->
            Decode.succeed { pattern = pattern, message = message }

        Nothing ->
            Decode.fail ("Invalid regex pattern: \"" ++ pattern ++ "\"")
