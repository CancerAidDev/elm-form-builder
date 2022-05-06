module Form.Field.RadioBool exposing (fromString, toString, decoder)

{-| RadioBool helpers.


# RadioBool

@docs fromString, toString, decoder

-}

import Json.Decode as Decode
import Json.Decode.Extra as DecodeExtra


{-| -}
fromString : String -> Maybe Bool
fromString str =
    case str of
        "Yes" ->
            Just True

        "No" ->
            Just False

        _ ->
            Nothing


{-| -}
toString : Bool -> String
toString bool =
    if bool then
        "Yes"

    else
        "No"


{-| -}
decoder : Decode.Decoder Bool
decoder =
    Decode.string
        |> Decode.andThen
            (fromString >> DecodeExtra.fromMaybe "Invalid radio bool value type")
