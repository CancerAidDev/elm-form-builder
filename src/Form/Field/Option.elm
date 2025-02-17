module Form.Field.Option exposing (Option, decoder, remoteOptionDecoder)

{-| Field option type


# Option

@docs Option, decoder, remoteOptionDecoder

-}

import Json.Decode as Decode
import Json.Decode.Pipeline as DecodePipeline


{-| -}
type alias Option =
    { value : String
    , label : Maybe String
    }


{-| -}
decoder : Decode.Decoder Option
decoder =
    Decode.succeed Option
        |> DecodePipeline.required "value" Decode.string
        |> DecodePipeline.optional "label" (Decode.map Just Decode.string) Nothing


{-| -}
remoteOptionDecoder : Decode.Decoder Option
remoteOptionDecoder =
    Decode.succeed Option
        |> DecodePipeline.required "id" Decode.string
        |> DecodePipeline.required "name" (Decode.map Just Decode.string)
