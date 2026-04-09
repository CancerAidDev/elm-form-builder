module Form.Field.LabelExtraContent exposing (LabelExtraContent, decoder)

{-| Field label extra content type


# LabelExtraContent

@docs LabelExtraContent, decoder

-}

import Json.Decode as Decode
import Json.Decode.Pipeline as DecodePipeline


{-| -}
type alias LabelExtraContent =
    { content : String
    , classes : Maybe String
    }


{-| -}
decoder : Decode.Decoder LabelExtraContent
decoder =
    Decode.succeed LabelExtraContent
        |> DecodePipeline.required "content" Decode.string
        |> DecodePipeline.optional "classes" (Decode.map Just Decode.string) Nothing
