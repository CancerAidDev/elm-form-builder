module Form.Field.RemoteOptionDecoder exposing
    ( RemoteOptionDecoder, remoteOptionDecoder
    , decoder, default
    )

{-| Field remote option decorder type


# RemoteOptionDecoder

@docs RemoteOptionDecoder, remoteOptionDecoder

-}

import Form.Field.Option as Option
import Json.Decode as Decode
import Json.Decode.Pipeline as DecodePipeline


type alias RemoteOptionDecoder =
    { value : String
    , label : String
    }


default : RemoteOptionDecoder
default =
    { value = "uuid"
    , label = "name"
    }


decoder : Decode.Decoder RemoteOptionDecoder
decoder =
    Decode.succeed RemoteOptionDecoder
        |> DecodePipeline.required "value" Decode.string
        |> DecodePipeline.required "label" Decode.string


{-| -}
remoteOptionDecoder : RemoteOptionDecoder -> Decode.Decoder Option.Option
remoteOptionDecoder remoteOption =
    Decode.succeed Option.Option
        |> DecodePipeline.required remoteOption.value Decode.string
        |> DecodePipeline.required remoteOption.label (Decode.map Just Decode.string)
