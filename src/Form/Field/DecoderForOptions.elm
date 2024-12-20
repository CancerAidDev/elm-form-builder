module Form.Field.DecoderForOptions exposing (DecoderForOptions, remoteOptionDecoder, default, decoder)

{-| Field decorder for options type


# DecoderForOptions

@docs DecoderForOptions, remoteOptionDecoder, default, decoder

-}

import Form.Field.Option as Option
import Json.Decode as Decode
import Json.Decode.Pipeline as DecodePipeline


{-| -}
type alias DecoderForOptions =
    { value : String
    , label : String
    }


{-| -}
default : DecoderForOptions
default =
    { value = "uuid"
    , label = "name"
    }


{-| -}
decoder : Decode.Decoder DecoderForOptions
decoder =
    Decode.succeed DecoderForOptions
        |> DecodePipeline.required "value" Decode.string
        |> DecodePipeline.required "label" Decode.string


{-| -}
remoteOptionDecoder : DecoderForOptions -> Decode.Decoder Option.Option
remoteOptionDecoder remoteOption =
    Decode.succeed Option.Option
        |> DecodePipeline.required remoteOption.value Decode.string
        |> DecodePipeline.required remoteOption.label (Decode.map Just Decode.string)
