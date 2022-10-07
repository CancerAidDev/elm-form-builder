module Form.Lib.RegexValidation exposing (RegexValidation, decoder)

import Json.Decode as Decode
import Json.Decode.Pipeline as DecodePipeline


type alias RegexValidation =
    { pattern : String
    , message : String
    }


decoder : Decode.Decoder RegexValidation
decoder =
    Decode.succeed RegexValidation
        |> DecodePipeline.required "pattern" Decode.string
        |> DecodePipeline.optional "message" Decode.string ""
