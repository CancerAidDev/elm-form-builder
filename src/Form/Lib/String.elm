module Form.Lib.String exposing (..)


fromMaybeInt : Maybe Int -> String
fromMaybeInt int =
    case int of
        Nothing ->
            ""

        Just num ->
            String.fromInt num
