module Form.Field.DecoderForOptions exposing (DecoderForOptions, remoteOptionsDecoder, default, decoder)

{-| Field decorder for options type


# DecoderForOptions

@docs DecoderForOptions, remoteOptionsDecoder, default, decoder

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
remoteOptionsDecoder : DecoderForOptions -> Decode.Decoder (List Option.Option)
remoteOptionsDecoder remoteOption =
    let
        optionDecoder =
            Decode.succeed Option.Option
                |> DecodePipeline.required remoteOption.value Decode.string
                |> DecodePipeline.required remoteOption.label (Decode.map Just Decode.string)
    in
    Decode.oneOf [ Decode.list optionDecoder, Decode.field "data" (Decode.list optionDecoder) ]
