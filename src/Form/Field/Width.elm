module Form.Field.Width exposing (Width(..), decoder, toStyle)

{-| Form element width


# Width

@docs Width, decoder, toStyle

-}

import Json.Decode as Decode
import Json.Decode.Extra as DecodeExtra


{-| -}
type Width
    = HalfSize
    | FullSize


{-| -}
fromString : String -> Maybe Width
fromString str =
    case str of
        "50%" ->
            Just HalfSize

        "100%" ->
            Just FullSize

        _ ->
            Nothing


{-| -}
toStyle : Width -> String
toStyle width =
    case width of
        HalfSize ->
            "is-col-span-1"

        FullSize ->
            "is-col-span-2 is-col-span-1-mobile"


{-| -}
decoder : Decode.Decoder Width
decoder =
    Decode.string
        |> Decode.andThen
            (fromString >> DecodeExtra.fromMaybe "Invalid width type")
