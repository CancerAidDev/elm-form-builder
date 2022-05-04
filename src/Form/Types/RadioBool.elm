module Form.Types.RadioBool exposing (decoder, fromString, toString)

import Json.Decode as Decode
import Json.Decode.Extra as DecodeExtra


fromString : String -> Maybe Bool
fromString str =
    case str of
        "Yes" ->
            Just True

        "No" ->
            Just False

        _ ->
            Nothing


toString : Bool -> String
toString bool =
    if bool then
        "Yes"

    else
        "No"


decoder : Decode.Decoder Bool
decoder =
    Decode.string
        |> Decode.andThen
            (fromString >> DecodeExtra.fromMaybe "Invalid radio bool value type")
