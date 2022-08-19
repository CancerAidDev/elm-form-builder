module Form.Lib.Nonempty exposing (decoder)

{-| Helper functions for working with mgold/elm-nonempty-list


# Nonempty

@docs decoder

-}

import Json.Decode as Decode
import Json.Decode.Extra as DecodeExtra
import List.Nonempty as Nonempty


{-| -}
decoder : Decode.Decoder a -> Decode.Decoder (Nonempty.Nonempty a)
decoder d =
    Decode.list d
        |> Decode.andThen
            (Nonempty.fromList
                >> DecodeExtra.fromMaybe "List must have at least one element"
            )
