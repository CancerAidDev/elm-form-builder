module Form.Types.RadioEnum exposing (Value(..), decoder, fromString, toBool, toString)

import Json.Decode as Decode
import Json.Decode.Extra as DecodeExtra


type Value
    = Yes
    | No
    | NA


toBool : Maybe Value -> Maybe Bool
toBool value =
    case value of
        Just Yes ->
            Just True

        Just No ->
            Just False

        _ ->
            Nothing


toString : Value -> String
toString value =
    case value of
        Yes ->
            "Yes"

        No ->
            "No"

        NA ->
            "N/A"


fromString : String -> Maybe Value
fromString str =
    case str of
        "Yes" ->
            Just Yes

        "No" ->
            Just No

        "N/A" ->
            Just NA

        _ ->
            Nothing


decoder : Decode.Decoder Value
decoder =
    Decode.string
        |> Decode.andThen
            (fromString >> DecodeExtra.fromMaybe "Invalid radio bool value type")
