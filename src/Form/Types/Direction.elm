module Form.Types.Direction exposing (Direction(..), decoder, fromString, toString)

import Json.Decode as Decode
import Json.Decode.Extra as DecodeExtra


type Direction
    = Row
    | Column


toString : Direction -> String
toString value =
    case value of
        Row ->
            "row"

        Column ->
            "column"


fromString : String -> Maybe Direction
fromString str =
    case String.toLower str of
        "row" ->
            Just Row

        "column" ->
            Just Column

        _ ->
            Nothing


decoder : Decode.Decoder Direction
decoder =
    Decode.string
        |> Decode.andThen
            (fromString >> DecodeExtra.fromMaybe "Invalid direction value type")
