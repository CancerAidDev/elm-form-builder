module Form.Format.Email exposing (regex, ForbiddenDomain, decoderForbiddenDomain)

{-| A (simple and quite possibly wrong) email regular expression

@docs regex, ForbiddenDomain, decoderForbiddenDomain

-}

import Json.Decode as Decode
import Json.Decode.Pipeline as DecodePipeline
import Regex


{-| -}
decoderForbiddenDomain : Decode.Decoder ForbiddenDomain
decoderForbiddenDomain =
    Decode.succeed ForbiddenDomain
        |> DecodePipeline.required "domain" Decode.string
        |> DecodePipeline.required "message" Decode.string


{-| -}
type alias ForbiddenDomain =
    { domain : String
    , message : String
    }


{-| -}
regex : Regex.Regex
regex =
    "^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*$"
        |> Regex.fromString
        |> Maybe.withDefault Regex.never
